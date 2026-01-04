# 🐾 Pet Shop Backend API

Node.js Express.js backend API for Pet Shop mobile application with Firebase Firestore and Firebase Authentication.

## 📋 Table of Contents

- [Technologies](#-technologies)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [Project Structure](#-project-structure)
- [API Endpoints](#-api-endpoints)
- [Firebase Setup](#-firebase-setup)
- [Scripts](#-scripts)
- [Security](#-security)
- [Testing](#-testing)

## 🛠 Technologies

### Core Technologies
- **Node.js** - JavaScript runtime environment
- **Express.js** (v4.18.2) - Web application framework
- **Firebase Admin SDK** (v12.0.0) - Server-side Firebase operations
- **Firebase Firestore** - NoSQL cloud database
- **Firebase Authentication** - User authentication service

### Key Dependencies
- **axios** (v1.13.2) - HTTP client for REST API calls
- **dotenv** (v16.3.1) - Environment variable management
- **cors** (v2.8.5) - Cross-Origin Resource Sharing
- **helmet** (v7.0.0) - Security headers middleware
- **morgan** (v1.10.0) - HTTP request logger
- **compression** (v1.7.4) - Response compression
- **express-validator** (v7.0.1) - Input validation

### Development Dependencies
- **nodemon** (v3.0.1) - Auto-restart on file changes
- **jest** (v29.6.2) - Testing framework

## 🚀 Features

- ✅ RESTful API with Express.js
- ✅ Firebase Firestore for database operations
- ✅ Firebase Authentication for user management
- ✅ JWT token-based authentication
- ✅ Role-based access control (Admin/User)
- ✅ Security middleware (Helmet, CORS)
- ✅ Request logging (Morgan)
- ✅ Error handling middleware
- ✅ Response compression
- ✅ Input validation
- ✅ Pagination support
- ✅ Category filtering
- ✅ Favorites management
- ✅ Admin panel support
- ✅ Social login UI (Google & Facebook buttons - UI ready, backend integration pending)

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18.0.0 or higher)
- **npm** (v9.0.0 or higher) or **yarn**
- **Firebase Project** with Firestore and Authentication enabled
- **Firebase Service Account Key** (JSON file)

## 🔧 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pet_shop_backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env  # If .env.example exists
   # Or create .env file manually
   ```

4. **Configure Firebase**
   - See [Firebase Setup Guide](./README_FIREBASE_SETUP.md) for detailed instructions
   - Download Firebase Service Account Key from Firebase Console
   - Place it in `src/config/` directory
   - Update `.env` file with Firebase credentials

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
# Server Configuration
NODE_ENV=development
PORT=5001
CLIENT_URL=http://localhost:3000

# Firebase Configuration

# Service account key file path (Required)
# Download from Firebase Console > Project Settings > Service Accounts
# Place the JSON file in src/config/ directory
GOOGLE_APPLICATION_CREDENTIALS=./src/config/firebase-service-account-key.json

# Firebase Web API Key (Required for login password verification)
# Get from Firebase Console > Project Settings > General > Web API Key
FIREBASE_WEB_API_KEY=your-web-api-key-here
```

### Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or select existing one
   - Enable Firestore Database
   - Enable Authentication (Email/Password provider)

2. **Get Service Account Key**
   - Firebase Console → Project Settings → Service Accounts
   - Click "Generate new private key"
   - Download JSON file
   - Place in `src/config/` directory
   - Update `.env` file: `GOOGLE_APPLICATION_CREDENTIALS=./src/config/your-key-file.json`

3. **Get Web API Key**
   - Firebase Console → Project Settings → General
   - Copy "Web API Key"
   - Add to `.env` file as `FIREBASE_WEB_API_KEY`

**Note:** This project uses **Method 1 (Service Account Key File)** for Firebase authentication. The alternative method using environment variables is not currently configured.


## 🏃 Running the Application

### Development Mode

```bash
npm run dev
```

This will start the server with `nodemon` for auto-reloading on file changes.

### Production Mode

```bash
npm start
```

The server will start on the port specified in `.env` (default: 5001)

### Verify Installation

```bash
curl http://localhost:5001/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Server is running"
}
```

## 📁 Project Structure

```
pet_shop_backend/
├── src/
│   ├── config/
│   │   ├── firebase.js          # Firebase Admin SDK initialization
│   │   └── env.js               # Environment variable validation
│   ├── controllers/
│   │   ├── adminController.js   # Admin operations
│   │   ├── authController.js    # Authentication (login, register, logout)
│   │   ├── favoriteController.js # Favorites management
│   │   ├── petController.js     # Pet CRUD operations
│   │   └── userController.js    # User profile management
│   ├── middleware/
│   │   ├── admin.js             # Admin role verification
│   │   ├── auth.js              # JWT token verification
│   │   └── errorHandler.js      # Global error handler
│   ├── routes/
│   │   ├── adminRoutes.js       # Admin routes
│   │   ├── authRoutes.js        # Authentication routes
│   │   ├── favoriteRoutes.js    # Favorites routes
│   │   ├── petRoutes.js         # Pet routes
│   │   └── userRoutes.js        # User routes
│   ├── utils/
│   │   └── firestoreHelper.js   # Firestore utility functions
│   └── app.js                   # Express app configuration
├── scripts/
│   ├── seedPets.js              # Seed demo pet data
│   └── setAdmin.js              # Set admin role for user
├── server.js                    # Server entry point
├── package.json                 # Dependencies and scripts
├── .env                         # Environment variables (gitignored)
├── .gitignore                   # Git ignore rules
├── README.md                    # This file
└── Pet_Shop_API.postman_collection.json  # Postman collection
```

## 📚 API Endpoints

### Health Check
- `GET /health` - Server status

### Authentication

#### Email/Password Authentication
- `POST /api/auth/register` - Register new user
  ```json
  {
    "fullName": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `POST /api/auth/login` - Login user
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```

- `GET /api/auth/me` - Get current user (Protected)
  - Requires: `Authorization: Bearer <token>`

- `POST /api/auth/logout` - Logout user (Protected)
  - Requires: `Authorization: Bearer <token>`

#### Social Authentication
- **Google Login** - UI ready, backend integration pending
- **Facebook Login** - UI ready, backend integration pending

**Note:** Social login buttons are present in the mobile app UI, but backend endpoints are not yet implemented. Currently only email/password authentication is fully functional.

### Pets
- `GET /api/pets` - Get all pets (with pagination)
  - Query params: `page`, `limit`, `category`
  - Example: `/api/pets?page=1&limit=10&category=dogs`

- `GET /api/pets/:id` - Get pet by ID

- `GET /api/pets/category/:category` - Get pets by category
  - Categories: `all`, `dogs`, `cats`, `birds`, `rabbits`, `fish`

- `POST /api/pets` - Create pet (Protected - Admin)
  - Requires: `Authorization: Bearer <admin-token>`

- `PUT /api/pets/:id` - Update pet (Protected - Admin)
  - Requires: `Authorization: Bearer <admin-token>`

- `DELETE /api/pets/:id` - Delete pet (Protected - Admin)
  - Requires: `Authorization: Bearer <admin-token>`

### Favorites
- `GET /api/favorites` - Get user favorites (Protected)
  - Requires: `Authorization: Bearer <token>`

- `POST /api/favorites` - Add favorite (Protected)
  - Body: `{ "petId": "pet-id-here" }`
  - Requires: `Authorization: Bearer <token>`

- `DELETE /api/favorites/:id` - Remove favorite (Protected)
  - Requires: `Authorization: Bearer <token>`

### Users
- `GET /api/users/profile` - Get user profile (Protected)
  - Requires: `Authorization: Bearer <token>`

- `PUT /api/users/profile` - Update user profile (Protected)
  - Requires: `Authorization: Bearer <token>`

### Admin
- `POST /api/admin/set-admin` - Set user as admin (Protected - Admin)
  - Body: `{ "email": "user@example.com" }`
  - Requires: `Authorization: Bearer <admin-token>`

## 🔥 Firebase Setup

See [README_FIREBASE_SETUP.md](./README_FIREBASE_SETUP.md) for detailed Firebase configuration instructions.

## 📜 Scripts

### Development
```bash
npm run dev          # Start development server with nodemon
```

### Production
```bash
npm start            # Start production server
```

### Utilities
```bash
npm run set-admin    # Set admin role for a user
npm run seed:pets    # Seed demo pet data to Firestore
```

### Testing
```bash
npm test             # Run tests (when implemented)
```

## 🔐 Security

- **Helmet** - Sets various HTTP headers for security
- **CORS** - Configures Cross-Origin Resource Sharing
- **Firebase Authentication** - Secure user authentication
- **JWT Tokens** - Token-based authentication
- **Role-based Access Control** - Admin/User role separation
- **Input Validation** - express-validator for request validation
- **Error Handling** - Centralized error handling middleware

## 🧪 Testing

### Postman Collection

Import `Pet_Shop_API.postman_collection.json` into Postman for API testing.

### Manual Testing

1. Start the server: `npm run dev`
2. Use Postman or curl to test endpoints
3. Check server logs for request/response details

## 📝 Response Format

### Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message",
  "error": "ERROR_CODE"
}
```

## 🐛 Troubleshooting

### Firebase Initialization Error
- Check if `GOOGLE_APPLICATION_CREDENTIALS` path is correct
- Verify service account key file exists
- Check Firebase project ID matches

### Port Already in Use
- Change `PORT` in `.env` file
- Or kill the process using the port

### Authentication Errors
- Verify `FIREBASE_WEB_API_KEY` is set correctly
- Check Firebase Authentication is enabled
- Verify email/password provider is enabled

## 📄 License

ISC

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

For issues and questions, please open an issue on GitHub.
