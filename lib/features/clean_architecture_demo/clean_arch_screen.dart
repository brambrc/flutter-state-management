import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// =============================================================================
// DOMAIN LAYER - Business Logic
// =============================================================================

// Entities
class Post {
  final int id;
  final String title;
  final String body;
  final int userId;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }
}

// Repository Interface (Abstract)
abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
}

// Use Cases
class GetPostsUseCase {
  final PostRepository repository;
  
  GetPostsUseCase(this.repository);
  
  Future<List<Post>> execute() async {
    return await repository.getPosts();
  }
}

// =============================================================================
// DATA LAYER - Data Access
// =============================================================================

// Repository Implementation
class PostRepositoryImpl implements PostRepository {
  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  
  @override
  Future<Post> getPostById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      );
      
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

// =============================================================================
// PRESENTATION LAYER - UI and State Management
// =============================================================================

// States
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

// State Management (using Provider + ChangeNotifier)
class PostNotifier extends ChangeNotifier {
  final GetPostsUseCase _getPostsUseCase;
  
  PostNotifier(this._getPostsUseCase);
  
  PostState _state = PostInitial();
  PostState get state => _state;
  
  Future<void> loadPosts() async {
    _state = PostLoading();
    notifyListeners();
    
    try {
      final posts = await _getPostsUseCase.execute();
      _state = PostLoaded(posts);
    } catch (e) {
      _state = PostError(e.toString());
    }
    
    notifyListeners();
  }
  
  void reset() {
    _state = PostInitial();
    notifyListeners();
  }
}

// UI Layer
class CleanArchScreen extends StatelessWidget {
  const CleanArchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Dependency Injection
        Provider<PostRepository>(
          create: (_) => PostRepositoryImpl(),
        ),
        ProxyProvider<PostRepository, GetPostsUseCase>(
          update: (_, repository, __) => GetPostsUseCase(repository),
        ),
        ChangeNotifierProxyProvider<GetPostsUseCase, PostNotifier>(
          create: (context) => PostNotifier(
            context.read<GetPostsUseCase>(),
          ),
          update: (_, useCase, notifier) => notifier ?? PostNotifier(useCase),
        ),
      ],
      child: const CleanArchHomePage(),
    );
  }
}

class CleanArchHomePage extends StatelessWidget {
  const CleanArchHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Demo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Clean Architecture dalam Flutter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const ArchitectureExplanation(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PostNotifier>().loadPosts();
                    },
                    child: const Text('Load Posts (API)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PostNotifier>().reset();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<PostNotifier>(
                builder: (context, notifier, child) {
                  final state = notifier.state;
                  
                  if (state is PostInitial) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.layers, size: 64, color: Colors.indigo),
                          SizedBox(height: 16),
                          Text(
                            'Clean Architecture Demo\nTekan "Load Posts" untuk melihat separation of concerns',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PostLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading posts from API...'),
                        ],
                      ),
                    );
                  } else if (state is PostLoaded) {
                    return ListView.builder(
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              post.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              post.body,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: CircleAvatar(
                              child: Text('${post.id}'),
                            ),
                            trailing: Text('User: ${post.userId}'),
                          ),
                        );
                      },
                    );
                  } else if (state is PostError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<PostNotifier>().loadPosts(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchitectureExplanation extends StatelessWidget {
  const ArchitectureExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Layers dalam Clean Architecture:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '🎨 Presentation Layer: UI & State Management (Provider/BLOC)',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              '🏢 Domain Layer: Business Logic & Use Cases',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              '💾 Data Layer: Repository & API calls',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 8),
            Text(
              'Keuntungan: Modular, Testable, Scalable, Independent',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
