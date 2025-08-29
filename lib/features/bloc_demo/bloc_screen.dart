import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class CounterEvent extends Equatable {
  const CounterEvent();
  
  @override
  List<Object> get props => [];
}

class CounterIncrement extends CounterEvent {}
class CounterDecrement extends CounterEvent {}
class CounterReset extends CounterEvent {}

// States
abstract class CounterState extends Equatable {
  const CounterState();
  
  @override
  List<Object> get props => [];
}

class CounterInitial extends CounterState {
  final int count;
  
  const CounterInitial({this.count = 0});
  
  @override
  List<Object> get props => [count];
}

class CounterChanged extends CounterState {
  final int count;
  
  const CounterChanged({required this.count});
  
  @override
  List<Object> get props => [count];
}

// Counter BLOC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<CounterIncrement>((event, emit) {
      final currentState = state;
      int currentCount = 0;
      
      if (currentState is CounterInitial) {
        currentCount = currentState.count;
      } else if (currentState is CounterChanged) {
        currentCount = currentState.count;
      }
      
      emit(CounterChanged(count: currentCount + 1));
    });
    
    on<CounterDecrement>((event, emit) {
      final currentState = state;
      int currentCount = 0;
      
      if (currentState is CounterInitial) {
        currentCount = currentState.count;
      } else if (currentState is CounterChanged) {
        currentCount = currentState.count;
      }
      
      emit(CounterChanged(count: currentCount - 1));
    });
    
    on<CounterReset>((event, emit) {
      emit(const CounterInitial());
    });
  }
}

// User Events
abstract class UserEvent extends Equatable {
  const UserEvent();
  
  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}
class RefreshUsers extends UserEvent {}

// User States
abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  
  const UserLoaded({required this.users});
  
  @override
  List<Object> get props => [users];
}

class UserError extends UserState {
  final String message;
  
  const UserError({required this.message});
  
  @override
  List<Object> get props => [message];
}

// User Model
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  
  const User({required this.id, required this.name, required this.email});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
  
  @override
  List<Object> get props => [id, name, email];
}

// User BLOC with API integration
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      
      try {
        final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/users'),
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> userData = json.decode(response.body);
          final users = userData.map((json) => User.fromJson(json)).toList();
          emit(UserLoaded(users: users));
        } else {
          emit(const UserError(message: 'Failed to load users'));
        }
      } catch (e) {
        emit(UserError(message: 'Network error: $e'));
      }
    });
    
    on<RefreshUsers>((event, emit) async {
      // Don't show loading when refreshing
      try {
        final response = await http.get(
          Uri.parse('https://jsonplaceholder.typicode.com/users'),
        );
        
        if (response.statusCode == 200) {
          final List<dynamic> userData = json.decode(response.body);
          final users = userData.map((json) => User.fromJson(json)).toList();
          emit(UserLoaded(users: users));
        } else {
          emit(const UserError(message: 'Failed to refresh users'));
        }
      } catch (e) {
        emit(UserError(message: 'Network error: $e'));
      }
    });
  }
}

class BlocScreen extends StatelessWidget {
  const BlocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterBloc()),
        BlocProvider(create: (_) => UserBloc()),
      ],
      child: const BlocDemoHome(),
    );
  }
}

class BlocDemoHome extends StatelessWidget {
  const BlocDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BLOC Demo'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Counter BLOC', icon: Icon(Icons.add)),
              Tab(text: 'API BLOC', icon: Icon(Icons.cloud)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CounterBlocTab(),
            UserBlocTab(),
          ],
        ),
      ),
    );
  }
}

class CounterBlocTab extends StatelessWidget {
  const CounterBlocTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'BLOC Counter Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              int count = 0;
              
              if (state is CounterInitial) {
                count = state.count;
              } else if (state is CounterChanged) {
                count = state.count;
              }
              
              return Text(
                '$count',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => context.read<CounterBloc>().add(CounterDecrement()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Decrement'),
              ),
              ElevatedButton(
                onPressed: () => context.read<CounterBloc>().add(CounterReset()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () => context.read<CounterBloc>().add(CounterIncrement()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Increment'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'BLOC Pattern:\n'
                '• Event-driven architecture\n'
                '• Separation of UI and business logic\n'
                '• Menggunakan Streams untuk data flow\n'
                '• Cocok untuk aplikasi besar dan kompleks\n'
                '• Mudah untuk testing dan debugging',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserBlocTab extends StatelessWidget {
  const UserBlocTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'API Integration dengan BLOC',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<UserBloc>().add(LoadUsers()),
                  child: const Text('Load Users'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<UserBloc>().add(RefreshUsers()),
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInitial) {
                  return const Center(
                    child: Text(
                      'Tekan "Load Users" untuk memuat data',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else if (state is UserLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading users...'),
                      ],
                    ),
                  );
                } else if (state is UserLoaded) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(user.name[0]),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: Text('ID: ${user.id}'),
                        ),
                      );
                    },
                  );
                } else if (state is UserError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<UserBloc>().add(LoadUsers()),
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
    );
  }
}
