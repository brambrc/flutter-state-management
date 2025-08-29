import 'dart:async';
import 'package:flutter/material.dart';

class StreamsScreen extends StatelessWidget {
  const StreamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Streams Demo'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Basic Stream', icon: Icon(Icons.stream)),
              Tab(text: 'Timer Stream', icon: Icon(Icons.timer)),
              Tab(text: 'Chat Stream', icon: Icon(Icons.chat)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BasicStreamTab(),
            TimerStreamTab(),
            ChatStreamTab(),
          ],
        ),
      ),
    );
  }
}

// Demo 1: Basic Stream dengan StreamController
class BasicStreamTab extends StatefulWidget {
  const BasicStreamTab({super.key});

  @override
  State<BasicStreamTab> createState() => _BasicStreamTabState();
}

class _BasicStreamTabState extends State<BasicStreamTab> {
  final StreamController<String> _streamController = StreamController<String>();
  final TextEditingController _messageController = TextEditingController();
  
  @override
  void dispose() {
    _streamController.close();
    _messageController.dispose();
    super.dispose();
  }
  
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _streamController.add(_messageController.text);
      _messageController.clear();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Basic Stream dengan StreamController',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Masukkan pesan',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Kirim'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Output Stream:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: StreamBuilder<String>(
                        stream: _streamController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text(
                                'Tidak ada data.\nKirim pesan untuk melihat output stream.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                          
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.teal.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latest Message:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  snapshot.data ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Received at: ${DateTime.now().toString().substring(11, 19)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Streams memungkinkan:\n'
                '• Komunikasi asynchronous antar komponen\n'
                '• Otomatis update UI saat ada data baru\n'
                '• Mengurangi penggunaan setState()\n'
                '• Cocok untuk real-time data (API, WebSockets)\n'
                '• Single listener atau multiple listener',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Demo 2: Timer Stream
class TimerStreamTab extends StatefulWidget {
  const TimerStreamTab({super.key});

  @override
  State<TimerStreamTab> createState() => _TimerStreamTabState();
}

class _TimerStreamTabState extends State<TimerStreamTab> {
  StreamController<int>? _timerController;
  Timer? _timer;
  bool _isRunning = false;
  int _seconds = 0;
  
  @override
  void dispose() {
    _timerController?.close();
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    if (_isRunning) return;
    
    setState(() {
      _isRunning = true;
      _seconds = 0;
    });
    
    _timerController = StreamController<int>();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      _timerController?.add(_seconds);
    });
  }
  
  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
    _timerController?.close();
  }
  
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Timer Stream Demo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _timerController != null
              ? StreamBuilder<int>(
                  stream: _timerController!.stream,
                  builder: (context, snapshot) {
                    final seconds = snapshot.data ?? 0;
                    final minutes = seconds ~/ 60;
                    final remainingSeconds = seconds % 60;
                    
                    return Text(
                      '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    );
                  },
                )
              : Text(
                  '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? null : _startTimer,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: _isRunning ? _stopTimer : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Stop'),
              ),
              ElevatedButton(
                onPressed: _resetTimer,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Timer Stream mendemonstrasikan:\n'
                '• Penggunaan Timer.periodic untuk generate data\n'
                '• StreamBuilder untuk listen dan display data\n'
                '• Auto-update UI setiap detik\n'
                '• Proper disposal untuk avoid memory leaks',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Demo 3: Chat-like Stream
class ChatStreamTab extends StatefulWidget {
  const ChatStreamTab({super.key});

  @override
  State<ChatStreamTab> createState() => _ChatStreamTabState();
}

class _ChatStreamTabState extends State<ChatStreamTab> {
  final StreamController<ChatMessage> _chatController = StreamController<ChatMessage>.broadcast();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  
  @override
  void dispose() {
    _chatController.close();
    _messageController.dispose();
    super.dispose();
  }
  
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = ChatMessage(
        text: _messageController.text,
        timestamp: DateTime.now(),
        isUser: true,
      );
      
      _chatController.add(message);
      _messageController.clear();
      
      // Simulate bot response after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        final botResponse = ChatMessage(
          text: 'Echo: ${message.text}',
          timestamp: DateTime.now(),
          isUser: false,
        );
        _chatController.add(botResponse);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Chat Stream Demo (Broadcast)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<ChatMessage>(
              stream: _chatController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _messages.add(snapshot.data!);
                }
                
                if (_messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada pesan.\nKirim pesan untuk memulai chat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: message.isUser 
                              ? Colors.teal.shade100
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: message.isUser 
                                ? Colors.teal.shade300
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.isUser ? 'You' : 'Bot',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: message.isUser 
                                    ? Colors.teal.shade700
                                    : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(message.text),
                            const SizedBox(height: 4),
                            Text(
                              '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Ketik pesan...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Text('Kirim'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Broadcast Stream memungkinkan multiple listeners mendengar data yang sama secara bersamaan.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Message Model
class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool isUser;
  
  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isUser,
  });
}
