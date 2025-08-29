import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model class for Counter
class CounterProvider extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
  
  void decrement() {
    _count--;
    notifyListeners();
  }
  
  void reset() {
    _count = 0;
    notifyListeners();
  }
}

// Model class for Shopping Cart
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.length;
  
  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  
  void addItem(String name, double price) {
    final existingIndex = _items.indexWhere((item) => item.name == name);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(name: name, price: price, quantity: 1));
    }
    notifyListeners();
  }
  
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  void updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(index);
    } else {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;
  
  CartItem({required this.name, required this.price, required this.quantity});
}

// Theme Provider
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get themeData => _isDarkMode ? ThemeData.dark() : ThemeData.light();
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.themeData,
            home: const ProviderDemoHome(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class ProviderDemoHome extends StatelessWidget {
  const ProviderDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider Demo'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Counter', icon: Icon(Icons.add)),
              Tab(text: 'Cart', icon: Icon(Icons.shopping_cart)),
              Tab(text: 'Theme', icon: Icon(Icons.palette)),
            ],
          ),
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: themeProvider.toggleTheme,
                );
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            CounterTab(),
            CartTab(),
            ThemeTab(),
          ],
        ),
      ),
    );
  }
}

class CounterTab extends StatelessWidget {
  const CounterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Provider Counter Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Consumer<CounterProvider>(
            builder: (context, counter, child) {
              return Text(
                '${counter.count}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () => context.read<CounterProvider>().decrement(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: () => context.read<CounterProvider>().reset(),
                backgroundColor: Colors.grey,
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () => context.read<CounterProvider>().increment(),
                backgroundColor: Colors.green,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Keuntungan Provider:\n'
                '• Tidak perlu setState()\n'
                '• State dapat diakses dari widget mana saja\n'
                '• Otomatis rebuild hanya widget yang membutuhkan\n'
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

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Shopping Cart dengan Provider',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<CartProvider>().addItem('Apel', 5000),
                  child: const Text('Tambah Apel (Rp 5.000)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<CartProvider>().addItem('Jeruk', 8000),
                  child: const Text('Tambah Jeruk (Rp 8.000)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<CartProvider>().addItem('Pisang', 3000),
                  child: const Text('Tambah Pisang (Rp 3.000)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.read<CartProvider>().clearCart(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Hapus Semua'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Item: ${cart.itemCount}'),
                          Text(
                            'Total: Rp ${cart.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Keranjang kosong\nTambahkan item di atas',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('Rp ${item.price.toStringAsFixed(0)} x ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => cart.updateQuantity(index, item.quantity - 1),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => cart.updateQuantity(index, item.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cart.removeItem(index),
                            ),
                          ],
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

class ThemeTab extends StatelessWidget {
  const ThemeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Theme Management dengan Provider',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        size: 64,
                        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: themeProvider.toggleTheme,
                        child: Text(themeProvider.isDarkMode ? 'Switch to Light' : 'Switch to Dark'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Provider memungkinkan:\n'
                '• Berbagi state antar widget\n'
                '• Tidak perlu pass data melalui constructor\n'
                '• Otomatis rebuild widget yang listen\n'
                '• Mudah untuk dependency injection\n'
                '• Support untuk multiple provider',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
