import 'package:flutter/material.dart';

// Import demo screens
import 'features/setstate_demo/setstate_screen.dart';
import 'features/provider_demo/provider_screen.dart';
import 'features/bloc_demo/bloc_screen.dart';
import 'features/cubit_demo/cubit_screen.dart';
import 'features/streams_demo/streams_screen.dart';
import 'features/clean_architecture_demo/clean_arch_screen.dart';

void main() {
  runApp(const StateManagementTrainingApp());
}

class StateManagementTrainingApp extends StatelessWidget {
  const StateManagementTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter State Management Training',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter State Management Training'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih topik pembelajaran yang ingin dipelajari:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildMenuCard(
                    context,
                    'setState()',
                    'Local Widget State\nManagement',
                    Icons.widgets,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetStateScreen(),
                      ),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    'Provider',
                    'App-wide State\nManagement',
                    Icons.hub,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProviderScreen(),
                      ),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    'BLOC',
                    'Event-driven\nArchitecture',
                    Icons.architecture,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BlocScreen(),
                      ),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    'Cubit',
                    'Simplified BLOC\nPattern',
                    Icons.lightbulb,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CubitScreen(),
                      ),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    'Streams',
                    'Asynchronous Data\nFlow',
                    Icons.stream,
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StreamsScreen(),
                      ),
                    ),
                  ),
                  _buildMenuCard(
                    context,
                    'Clean Architecture',
                    'Layered Application\nDesign',
                    Icons.layers,
                    Colors.indigo,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CleanArchScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}