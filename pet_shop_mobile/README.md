# 🐾 Pet Shop Mobile App

Flutter mobile application for Pet Shop with clean architecture, state management, and Firebase backend integration.

## 📋 Table of Contents

- [Technologies](#-technologies)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [State Management](#-state-management)
- [Localization](#-localization)
- [Building](#-building)

## 🛠 Technologies

### Core Technologies
- **Flutter** (SDK >=3.8.0) - Cross-platform mobile framework
- **Dart** (>=3.8.0) - Programming language

### State Management
- **flutter_bloc** (^8.1.3) - BLoC pattern implementation
- **equatable** (^2.0.5) - Value equality for models and states

### Dependency Injection
- **get_it** (^7.2.0) - Service locator for dependency injection

### Networking
- **dio** (^5.0.0) - HTTP client for API calls

### Routing
- **go_router** (^14.0.0) - Declarative routing for Flutter

### Localization
- **intl** (^0.20.2) - Internationalization support
- **flutter_localizations** - Flutter localization support

### UI Utilities
- **flutter_screenutil** (^5.9.3) - Screen adaptation utilities

### Code Generation
- **json_serializable** (^6.8.0) - JSON serialization code generation
- **json_annotation** (^4.8.0) - JSON annotation support
- **build_runner** (^2.4.0) - Code generation runner
- **envied** (^1.0.0) - Environment variable management

### Development Tools
- **very_good_analysis** (^8.0.0) - Linting rules
- **flutter_lints** (^5.0.0) - Additional linting rules

### Testing
- **bloc_test** (^9.1.5) - BLoC/Cubit testing utilities
- **mocktail** (^1.0.0) - Mock objects for testing

## 🚀 Features

- ✅ Clean Architecture pattern
- ✅ BLoC/Cubit state management
- ✅ RESTful API integration
- ✅ User authentication (Login/Register)
- ✅ Pet listing with pagination
- ✅ Category filtering
- ✅ Favorites management
- ✅ User profile management
- ✅ Admin panel (Pet CRUD operations)
- ✅ Multi-language support (English/Turkish)
- ✅ Responsive UI design
- ✅ Dark theme support
- ✅ Error handling
- ✅ Loading states
- ✅ Form validation
- ✅ Social login (Google & Facebook) - Fully integrated
- ✅ Persistent authentication
- ✅ Test coverage (Unit & Widget tests)
- ✅ Constants management (Centralized constants for colors, spacing, etc.)
- ✅ Separation of concerns (Controllers, Mixins, Views)

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.8.0 or higher)
- **Dart SDK** (3.8.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development on macOS)
- **Backend API** running (see [Backend README](../pet_shop_backend/README.md))

### Verify Installation

```bash
flutter doctor
```

Ensure all checks pass before proceeding.

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pet_shop_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

5. **Configure environment**
   - See [Configuration](#-configuration) section

## ⚙️ Configuration

### Environment Variables

The app uses `envied` for environment variable management. Configure API base URL:

1. **Check `lib/core/config/app_config.dart`**
   - Update API base URL if needed
   - Default: `http://10.0.2.2:5001` (Android Emulator)
   - For iOS Simulator: `http://localhost:5001`
   - For physical device: Use your computer's IP address

2. **Regenerate config**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Backend Connection

Ensure the backend API is running:
- Default port: `5001`
- Health check: `http://localhost:5001/health`

## 🏃 Running the Application

### Development Mode

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode with hot reload
flutter run --debug

# Run in release mode
flutter run --release
```

### Platform-Specific

```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios

# Web
flutter run -d chrome
```

### Hot Reload

Press `r` in the terminal to hot reload, or `R` for hot restart.

## 🎨 Code Quality & Best Practices

### Constants Management

Tüm sabit değerler (colors, spacing, font sizes, etc.) merkezi constants dosyalarında yönetilir:

- `core/constants/admin_constants.dart` - Admin sayfaları için constants
- `core/constants/app_dimensions.dart` - Responsive dimensions ve spacing
- `core/constants/home_constants.dart` - Home sayfası constants
- `core/constants/login_constants.dart` - Login/Register constants
- Diğer feature-specific constants dosyaları

**Kullanım Örneği:**
```dart
// ❌ Kötü: Hardcoded değer
Container(
  padding: EdgeInsets.all(16),
  color: Colors.blue,
)

// ✅ İyi: Constants kullanımı
Container(
  padding: AppDimensionsPadding.allMedium(context),
  color: AdminConstants.primaryColor,
)
```

### Separation of Concerns

Kod organizasyonu için net ayrımlar:

- **Views**: Sadece UI rendering
- **Controllers**: Form state ve business logic
- **Mixins**: Reusable logic (navigation, state handling)
- **BLoC/Cubit**: State management
- **Repositories**: Data layer abstraction

**Örnek Yapı:**
```
feature/admin/pets/
├── admin_pet_form_view.dart      # UI only
├── controllers/
│   └── admin_pet_form_controller.dart  # Form logic
└── mixins/
    └── admin_pets_list_mixin.dart     # Reusable logic
```

## 📁 Project Structure

```
pet_shop_mobile/
├── lib/
│   ├── core/
│   │   ├── config/              # App configuration (API URLs, etc.)
│   │   ├── constants/           # App-wide constants
│   │   ├── controller/          # UI controllers (legacy)
│   │   ├── data/
│   │   │   ├── datasources/    # API data sources
│   │   │   ├── helpers/        # API helpers
│   │   │   └── repositories/   # Repository implementations
│   │   ├── di/                 # Dependency injection
│   │   ├── models/             # Core models
│   │   ├── router/             # Navigation/routing
│   │   ├── theme/              # App theming
│   │   ├── validation/         # Form validators
│   │   └── widgets/            # Reusable widgets
│   ├── feature/
│   │   ├── admin/              # Admin features
│   │   │   ├── bloc/          # Admin state management
│   │   │   ├── dashboard/     # Admin dashboard
│   │   │   │   └── mixins/    # Dashboard logic mixins
│   │   │   └── pets/          # Admin pet management
│   │   │       ├── controllers/ # Pet form controllers
│   │   │       └── mixins/      # Pet list logic mixins
│   │   ├── auth/              # Authentication
│   │   │   ├── bloc/          # Auth state management
│   │   │   └── models/        # Auth models
│   │   ├── favorite/          # Favorites feature
│   │   │   ├── bloc/          # Favorite state management
│   │   │   └── models/        # Favorite models
│   │   ├── favorites/         # Favorites UI
│   │   ├── home/              # Home screen
│   │   ├── login/             # Login/Register UI
│   │   ├── pet/               # Pet feature
│   │   │   ├── bloc/          # Pet state management
│   │   │   └── models/        # Pet models
│   │   ├── profile/           # Profile screen
│   │   └── user/              # User feature
│   │       └── bloc/          # User state management
│   ├── l10n/                  # Generated localization files
│   └── main.dart              # App entry point
├── test/                      # Test files
│   ├── unit/                  # Unit tests
│   │   └── bloc/             # BLoC/Cubit tests
│   ├── widgets/              # Widget tests
│   └── README.md             # Test documentation
├── assets/
│   ├── images/                # App images
│   └── l10n/                  # Localization files (.arb)
├── android/                   # Android-specific files
├── ios/                       # iOS-specific files
├── pubspec.yaml               # Dependencies
└── README.md                  # This file
```

## 🏗 Architecture

The app follows **Clean Architecture** principles:

### Layers

1. **Presentation Layer** (`feature/`)
   - UI components (Views)
   - State management (BLoC/Cubit)
   - Controllers and Mixins

2. **Domain Layer** (implicit)
   - Business logic
   - Models
   - Use cases (handled by repositories)

3. **Data Layer** (`core/data/`)
   - Data sources (API)
   - Repository implementations
   - Models (with JSON serialization)

### Dependency Flow

```
UI → BLoC/Cubit → Repository → DataSource → API
```

### Key Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Testability**: Easy to test each layer independently

## 📊 State Management

The app uses **BLoC/Cubit** pattern for state management:

### State Classes
- Extend `Equatable` for value equality
- Immutable state objects
- Clear state transitions

### Example Structure

```dart
// State
abstract class PetState extends Equatable {
  const PetState();
}

class PetInitial extends PetState {}
class PetLoading extends PetState {}
class PetLoaded extends PetState {
  final List<PetModel> pets;
  const PetLoaded(this.pets);
}
class PetError extends PetState {
  final String message;
  const PetError(this.message);
}

// Cubit
class PetCubit extends Cubit<PetState> {
  final PetRepository repository;
  
  PetCubit({required this.repository}) : super(PetInitial());
  
  Future<void> getAllPets() async {
    emit(PetLoading());
    try {
      final pets = await repository.getAllPets();
      emit(PetLoaded(pets));
    } catch (e) {
      emit(PetError(e.toString()));
    }
  }
}
```

## 🌍 Localization

The app supports multiple languages:

### Supported Languages
- English (en)
- Turkish (tr)

### Adding New Translations

1. Edit `assets/l10n/app_en.arb` and `assets/l10n/app_tr.arb`
2. Run: `flutter gen-l10n`
3. Use in code: `AppLocalizations.of(context)!.yourKey`

### Example

```dart
Text(AppLocalizations.of(context)!.welcome)
```

## 🎨 Theming

The app uses Material Design 3 with custom theming:

- Light theme (default)
- Dark theme support
- Custom color schemes
- Responsive typography
- Consistent spacing

## 🔨 Building

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

## 🧪 Testing

### Test Yapısı

Proje kapsamlı test yapısına sahiptir:

- **Unit Testler**: BLoC/Cubit testleri (`test/unit/bloc/`)
- **Widget Testleri**: UI component testleri (`test/widgets/`)
- **Test Coverage**: Coverage raporu oluşturma

### Test Çalıştırma

```bash
# Tüm testleri çalıştır
flutter test

# Belirli bir test dosyası
flutter test test/unit/bloc/auth_cubit_test.dart

# Widget testleri
flutter test test/widgets/

# Coverage raporu
flutter test --coverage
```

### Test Paketleri

- **bloc_test**: BLoC/Cubit testleri için özel test utilities
- **mocktail**: Mock objeler oluşturma için

### Test Örnekleri

**BLoC Test Örneği:**
```dart
blocTest<AuthCubit, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login succeeds',
  build: () {
    when(() => mockRepository.login(loginRequest)).thenAnswer(...);
    return authCubit;
  },
  act: (cubit) => cubit.login(loginRequest),
  expect: () => [
    const AuthLoading(),
    const AuthAuthenticated(user: user, token: 'test_token'),
  ],
);
```

**Widget Test Örneği:**
```dart
testWidgets('BackAppBar displays title correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: const BackAppBar(title: 'Test Title'),
      ),
    ),
  );
  expect(find.text('Test Title'), findsOneWidget);
});
```

Detaylı test dokümantasyonu için: `test/README.md`

## 📱 Screens

### User Screens
- **Login** - User authentication
- **Register** - New user registration
- **Home** - Pet listing with filters
- **Pet Detail** - Pet information and favorite toggle
- **Favorites** - User's favorite pets
- **Profile** - User profile and settings

### Admin Screens
- **Admin Login** - Admin authentication
- **Admin Dashboard** - Admin overview
- **Pet List** - Manage pets (CRUD)
- **Pet Form** - Create/Edit pets

## 🔐 Authentication Flow

### Email/Password Authentication
1. User logs in via `/login` or registers via `/register`
2. `AuthCubit` handles authentication
3. Token stored in `AuthAuthenticated` state
4. Protected routes check authentication
5. Token sent in API requests via `Authorization` header

### Social Authentication
- **Google Login** - ✅ Fully integrated with backend
- **Facebook Login** - ✅ Fully integrated with backend

**Note:** Social login is fully functional. Users can sign in with Google or Facebook accounts.

## 📡 API Integration

### Data Flow

1. **UI** triggers action (e.g., button tap)
2. **Cubit** receives event
3. **Repository** called with parameters
4. **DataSource** makes HTTP request
5. **Response** parsed and returned
6. **State** updated with data
7. **UI** rebuilds with new state

### Error Handling

- Network errors caught in DataSource
- Parsed and converted to user-friendly messages
- Displayed via SnackBar or error state

## 🐛 Troubleshooting

### Build Errors

```bash
# Clean build
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Localization Not Working

```bash
flutter gen-l10n
```

### API Connection Issues

- Check backend is running
- Verify API base URL in `app_config.dart`
- For Android Emulator: Use `10.0.2.2:5001`
- For iOS Simulator: Use `localhost:5001`
- For physical device: Use your computer's IP

### Code Generation Issues

```bash
# Delete generated files and regenerate
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📄 License

ISC

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## 📞 Support

For issues and questions, please open an issue on GitHub.
