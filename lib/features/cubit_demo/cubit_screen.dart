import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Counter Cubit (Simple)
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void reset() => emit(0);
  void setValue(int value) => emit(value);
}

// Todo States
abstract class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {
  final List<TodoItem> todos;
  
  const TodoInitial({this.todos = const []});
  
  @override
  List<Object> get props => [todos];
}

class TodoLoaded extends TodoState {
  final List<TodoItem> todos;
  
  const TodoLoaded({required this.todos});
  
  @override
  List<Object> get props => [todos];
}

// Todo Model
class TodoItem extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  
  const TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
  
  TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  
  @override
  List<Object> get props => [id, title, isCompleted];
}

// Todo Cubit
class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoInitial());

  void addTodo(String title) {
    final currentState = state;
    List<TodoItem> currentTodos = [];
    
    if (currentState is TodoInitial) {
      currentTodos = currentState.todos;
    } else if (currentState is TodoLoaded) {
      currentTodos = currentState.todos;
    }
    
    final newTodo = TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    
    emit(TodoLoaded(todos: [...currentTodos, newTodo]));
  }

  void toggleTodo(String id) {
    final currentState = state;
    List<TodoItem> currentTodos = [];
    
    if (currentState is TodoInitial) {
      currentTodos = currentState.todos;
    } else if (currentState is TodoLoaded) {
      currentTodos = currentState.todos;
    }
    
    final updatedTodos = currentTodos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();
    
    emit(TodoLoaded(todos: updatedTodos));
  }

  void removeTodo(String id) {
    final currentState = state;
    List<TodoItem> currentTodos = [];
    
    if (currentState is TodoInitial) {
      currentTodos = currentState.todos;
    } else if (currentState is TodoLoaded) {
      currentTodos = currentState.todos;
    }
    
    final updatedTodos = currentTodos.where((todo) => todo.id != id).toList();
    emit(TodoLoaded(todos: updatedTodos));
  }

  void clearCompleted() {
    final currentState = state;
    List<TodoItem> currentTodos = [];
    
    if (currentState is TodoInitial) {
      currentTodos = currentState.todos;
    } else if (currentState is TodoLoaded) {
      currentTodos = currentState.todos;
    }
    
    final updatedTodos = currentTodos.where((todo) => !todo.isCompleted).toList();
    emit(TodoLoaded(todos: updatedTodos));
  }
}

class CubitScreen extends StatelessWidget {
  const CubitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(create: (_) => TodoCubit()),
      ],
      child: const CubitDemoHome(),
    );
  }
}

class CubitDemoHome extends StatelessWidget {
  const CubitDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cubit Demo'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Counter Cubit', icon: Icon(Icons.add)),
              Tab(text: 'Todo Cubit', icon: Icon(Icons.checklist)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CounterCubitTab(),
            TodoCubitTab(),
          ],
        ),
      ),
    );
  }
}

class CounterCubitTab extends StatelessWidget {
  const CounterCubitTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Cubit Counter Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          BlocBuilder<CounterCubit, int>(
            builder: (context, count) {
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
                onPressed: () => context.read<CounterCubit>().decrement(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Decrement'),
              ),
              ElevatedButton(
                onPressed: () => context.read<CounterCubit>().reset(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () => context.read<CounterCubit>().increment(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Increment'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Set value langsung',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              final intValue = int.tryParse(value);
              if (intValue != null) {
                context.read<CounterCubit>().setValue(intValue);
              }
            },
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Cubit vs BLOC:\n'
                '• Cubit lebih sederhana (no events)\n'
                '• Langsung emit state baru\n'
                '• Cocok untuk state management sederhana\n'
                '• Boilerplate code lebih sedikit\n'
                '• Performa lebih baik untuk kasus simple',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoCubitTab extends StatelessWidget {
  const TodoCubitTab({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Todo List dengan Cubit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Tambah todo baru',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<TodoCubit>().addTodo(value);
                      controller.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    context.read<TodoCubit>().addTodo(controller.text);
                    controller.clear();
                  }
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<TodoCubit, TodoState>(
            builder: (context, state) {
              List<TodoItem> todos = [];
              
              if (state is TodoInitial) {
                todos = state.todos;
              } else if (state is TodoLoaded) {
                todos = state.todos;
              }
              
              final completedCount = todos.where((todo) => todo.isCompleted).length;
              
              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total: ${todos.length}'),
                          Text('Selesai: $completedCount'),
                          ElevatedButton(
                            onPressed: completedCount > 0
                                ? () => context.read<TodoCubit>().clearCompleted()
                                : null,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                            child: const Text('Hapus Selesai'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                List<TodoItem> todos = [];
                
                if (state is TodoInitial) {
                  todos = state.todos;
                } else if (state is TodoLoaded) {
                  todos = state.todos;
                }
                
                if (todos.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada todo.\nTambahkan todo baru di atas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Card(
                      child: CheckboxListTile(
                        value: todo.isCompleted,
                        onChanged: (_) => context.read<TodoCubit>().toggleTodo(todo.id),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isCompleted 
                                ? TextDecoration.lineThrough 
                                : TextDecoration.none,
                            color: todo.isCompleted ? Colors.grey : null,
                          ),
                        ),
                        secondary: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<TodoCubit>().removeTodo(todo.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
