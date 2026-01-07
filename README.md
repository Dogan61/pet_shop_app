# 🐾 Pet Shop App - Full Stack Mobile Application

Modern, full-stack pet shop application. A comprehensive project including a mobile application developed with Flutter and a RESTful API backend developed with Node.js/Express.js.

## 📱 About the Project

Pet Shop App is a comprehensive mobile application developed for a pet sales platform. Users can view pets, add them to favorites, examine detailed information, and manage their profiles. Administrators can manage pets through the admin panel.

### 🎯 Project Features

- ✅ **User Management**: Registration, login, profile management
- ✅ **Social Login**: Google and Facebook login support
- ✅ **Pet Listing**: Category-based filtering and search
- ✅ **Favorites System**: Add/remove favorites and listing
- ✅ **Detailed Information**: Pet detail pages (health status, owner information)
- ✅ **Admin Panel**: Add, edit, delete pets
- ✅ **Multi-language Support**: Turkish and English
- ✅ **Responsive Design**: Compatible with different screen sizes
- ✅ **Clean Architecture**: Modular and scalable code structure
- ✅ **Test Coverage**: Unit and widget tests
- ✅ **Code Quality**: Constants usage, separation of concerns
- ✅ **Backend Helpers**: Centralized error handling and response management

## 🏗️ Project Structure

```
pet_shop_app/
├── pet_shop_mobile/          # Flutter mobile application
│   ├── lib/
│   │   ├── core/            # Core structures (DI, routing, constants)
│   │   ├── feature/         # Feature-based modules
│   │   └── l10n/            # Localization files
│   └── assets/              # Images and translation files
│
└── pet_shop_backend/         # Node.js/Express.js backend
    ├── src/
    │   ├── controllers/     # Business logic controllers
    │   ├── routes/          # API route definitions
    │   ├── middleware/      # Auth, error handling middleware
    │   ├── config/          # Firebase, env configurations
    │   └── utils/           # Helper functions
    │       ├── userHelper.js      # User profile helper functions
    │       ├── responseHelper.js  # Standardized API responses
    │       ├── errorHelper.js     # Centralized error handling
    │       └── firestoreHelper.js # Firestore utility functions
    └── scripts/             # Seed and admin scripts
```

## 🛠️ Technologies

### 📱 Frontend (Mobile)
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **BLoC/Cubit** - State management
- **GoRouter** - Declarative routing
- **Dio** - HTTP client
- **GetIt** - Dependency injection
- **Equatable** - Value equality
- **JSON Serializable** - JSON serialization
- **Flutter ScreenUtil** - Responsive design
- **Google Sign In** - Google authentication
- **Facebook Auth** - Facebook authentication

### 🔧 Backend
- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **Firebase Admin SDK** - Server-side Firebase operations
- **Firebase Firestore** - NoSQL database
- **Firebase Authentication** - User authentication
- **Axios** - HTTP client
- **Helmet** - Security headers
- **CORS** - Cross-origin resource sharing
- **Morgan** - HTTP request logger
- **Compression** - Response compression

## 📸 Screenshots

<!-- Screenshots will be added here -->
<!-- 
### Giriş Ekranı
![Login Screen](screenshots/login.png)

### Ana Sayfa
![Home Screen](screenshots/home.png)

### Favoriler
![Favorites Screen](screenshots/favorites.png)

### Profil
![Profile Screen](screenshots/profile.png)

### Evcil Hayvan Detayı
![Pet Detail Screen](screenshots/pet-detail.png)

### Admin Paneli
![Admin Dashboard](screenshots/admin-dashboard.png)
-->

## 🚀 Installation and Running

### Requirements

- Flutter SDK (>=3.8.0)
- Dart SDK (>=3.8.0)
- Node.js (>=18.0.0)
- npm or yarn
- Firebase project and service account key

### Backend Installation

```bash
cd pet_shop_backend
npm install
```

Create `.env` file:
```env
PORT=5001
NODE_ENV=development
GOOGLE_APPLICATION_CREDENTIALS=config/firebase-service-account-key.json
FIREBASE_WEB_API_KEY=your_firebase_web_api_key
```

Start the backend:
```bash
npm run dev
```

### Mobile Installation

```bash
cd pet_shop_mobile
flutter pub get
```

Create `.env` file:
```env
API_BASE_URL=http://localhost:5001
```

Run the application:
```bash
flutter run
```

For detailed installation instructions:
- [Mobile README](pet_shop_mobile/README.md)
- [Backend README](pet_shop_backend/README.md)

## 🏛️ Architecture

### Clean Architecture

The project is structured according to Clean Architecture principles:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (UI, Widgets, BLoC/Cubit)         │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Domain Layer                │
│  (Models, Repositories Interface)   │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                  │
│  (Data Sources, Repository Impl)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         External Layer              │
│  (API, Firebase, Local Storage)    │
└─────────────────────────────────────┘
```

### State Management

State management is implemented using the BLoC (Business Logic Component) pattern:
- **Cubit**: For simple state management
- **Equatable**: For state comparisons
- **BlocProvider**: For dependency injection

### Dependency Injection

Dependency injection is implemented using GetIt service locator:
- `registerLazySingleton` for singleton pattern
- `registerFactory` for factory pattern

## 🔐 Security

- Secure user management with Firebase Authentication
- JWT token-based authentication
- Role-based access control (Admin/User)
- Security headers with Helmet
- CORS configuration
- Sensitive information management with environment variables
- Protection of sensitive files with `.gitignore`

## 📚 API Documentation

Backend API endpoints:

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/google` - Google login
- `POST /api/auth/facebook` - Facebook login
- `GET /api/auth/me` - User information
- `POST /api/auth/logout` - Logout

### Pets
- `GET /api/pets` - List all pets
- `GET /api/pets/:id` - Pet details
- `GET /api/pets/category/:category` - List by category

### Favorites
- `GET /api/favorites` - List favorites
- `POST /api/favorites` - Add favorite
- `DELETE /api/favorites/:id` - Remove favorite

### Admin
- `GET /api/admin/check` - Admin check
- `POST /api/admin/pets` - Add pet
- `PUT /api/admin/pets/:id` - Update pet
- `DELETE /api/admin/pets/:id` - Delete pet

Postman collection: `pet_shop_backend/Pet_Shop_API.postman_collection.json`

## 🌍 Localization

The application supports multiple languages:
- 🇹🇷 Turkish
- 🇬🇧 English

Localization files: `pet_shop_mobile/assets/l10n/`

## 📦 Build ve Deploy

### Android
```bash
cd pet_shop_mobile
flutter build apk --release
```

### iOS
```bash
cd pet_shop_mobile
flutter build ios --release
```

## 🧪 Testing

### Mobile Tests

```bash
cd pet_shop_mobile
flutter test
```

**Test Structure:**
- ✅ Unit tests (BLoC/Cubit tests)
- ✅ Widget tests
- ✅ Test coverage report: `flutter test --coverage`

**Test Packages:**
- `bloc_test` - For BLoC/Cubit tests
- `mocktail` - For mock objects

**Test Folder Structure:**
```
test/
├── unit/              # Unit tests
│   └── bloc/         # BLoC/Cubit tests
├── widgets/          # Widget tests
└── README.md         # Test documentation
```

### Backend Tests

```bash
cd pet_shop_backend
npm test
```


## 👨‍💻 Developer

**Dogan Senturk**

- Portfolio: [GitHub Profile](https://github.com/Dogan61)
- LinkedIn: [LinkedIn Profile](https://www.linkedin.com/in/dogan-senturk/)
- Email: dogansenturk51@gmail.com

## 🙏 Acknowledgments

Thanks to all open-source libraries used in this project.

---

⭐ If you liked this project, don't forget to give it a star!

