# Flutter State Management Training

Proyek pembelajaran komprehensif untuk state management dalam Flutter dengan berbagai pola dan arsitektur.

## 🎯 Topik Pembelajaran

### 1. **setState()** 
- Local widget state management
- Counter demo, TextField demo, Dynamic List demo
- Konsep dasar state management di Flutter

### 2. **Provider**
- App-wide state management
- ChangeNotifier pattern
- Multi-provider setup
- Shopping cart & theme management examples

### 3. **BLOC Pattern**
- Event-driven architecture
- Separation of UI and business logic  
- Stream-based data flow
- API integration with error handling

### 4. **Cubit**
- Simplified BLOC pattern
- Direct state emission
- Less boilerplate code
- Todo list management example

### 5. **Streams**
- Asynchronous data flow
- StreamController & StreamBuilder
- Single vs Broadcast streams
- Real-time data examples (timer, chat)

### 6. **Clean Architecture**
- Layered application design
- Domain, Data, dan Presentation layers
- Dependency injection
- Separation of concerns

## 🏗️ Struktur Proyek

```
lib/
├── core/                    # Core functionality
│   ├── error/              # Error handling
│   ├── network/            # Network utilities  
│   └── usecases/           # Domain use cases
├── features/               # Feature modules
│   ├── setstate_demo/      # setState() examples
│   ├── provider_demo/      # Provider examples
│   ├── bloc_demo/          # BLOC pattern examples
│   ├── cubit_demo/         # Cubit examples
│   ├── streams_demo/       # Streams examples
│   └── clean_architecture_demo/ # Clean Architecture demo
└── shared/                 # Shared components
    ├── widgets/            # Common widgets
    └── utils/              # Utility functions
```

## 🚀 Cara Menjalankan

1. **Clone atau buat project:**
   ```bash
   flutter create flutter_state_management_training
   cd flutter_state_management_training
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- **provider**: ^6.1.2 - State management dengan ChangeNotifier
- **flutter_bloc**: ^8.1.6 - BLOC dan Cubit implementation  
- **equatable**: ^2.0.5 - Value equality untuk BLOC states/events
- **http**: ^1.2.2 - HTTP client untuk API calls
- **get_it**: ^8.0.0 - Service locator untuk dependency injection

## 🎓 Konsep yang Dipelajari

### setState() vs Provider vs BLOC vs Cubit

| Aspect | setState() | Provider | BLOC | Cubit |
|--------|-----------|----------|------|-------|
| **Scope** | Widget lokal | App-wide | App-wide | App-wide |
| **Complexity** | Sangat sederhana | Sederhana | Kompleks | Sederhana |
| **Boilerplate** | Minimal | Minimal | Banyak | Sedang |
| **Testability** | Sulit | Mudah | Sangat mudah | Mudah |
| **Best for** | UI state sederhana | Shared state | Aplikasi besar | State management sederhana |

### Clean Architecture Benefits

- **Modular**: Kode terorganisir dalam layers yang terpisah
- **Testable**: Setiap layer dapat di-test secara independent  
- **Scalable**: Mudah untuk menambah fitur baru
- **Maintainable**: Kode mudah dipahami dan di-maintain

### Streams in Flutter

- **Single Subscription**: Hanya satu listener yang dapat mendengar
- **Broadcast**: Multiple listener dapat mendengar secara bersamaan
- **StreamController**: Mengatur dan mengirim data ke stream
- **StreamBuilder**: Widget yang listen dan rebuild UI otomatis

## 🔧 Design Patterns

Proyek ini mendemonstrasikan berbagai design patterns:

- **Observer Pattern**: Provider dan BLOC menggunakan pattern ini
- **Repository Pattern**: Abstraksi data access layer
- **Dependency Injection**: Menggunakan Provider dan get_it
- **Event-driven Architecture**: BLOC pattern implementation

## 📱 Fitur Demo

1. **Counter Apps**: Berbagai implementasi counter dengan state management berbeda
2. **Shopping Cart**: Manajemen keranjang belanja dengan Provider
3. **Todo List**: CRUD operations dengan Cubit
4. **API Integration**: Fetch data dari API dengan BLOC
5. **Real-time Chat**: Simulasi chat dengan Streams
6. **Theme Management**: Dark/Light theme switching

## 🎯 Learning Objectives

Setelah menyelesaikan training ini, Anda akan memahami:

- Kapan menggunakan setState() vs state management lainnya
- Cara implement Provider untuk shared state
- BLOC pattern untuk aplikasi kompleks
- Cubit untuk state management sederhana
- Streams untuk asynchronous data flow
- Clean Architecture principles
- Best practices untuk state management di Flutter

## 🤔 Common Issues & Solutions

### Force Close
- Tidak proper dispose controllers
- Memory leaks dari streams yang tidak di-close

### Application Freeze  
- Blocking operations di main thread
- Infinite rebuild loops

### Network Issues
- Tidak handle network errors dengan baik
- Tidak ada loading states

Happy learning! 🎓