# 🐾 Pet Shop App - Full Stack Mobile Application

Modern, full-stack pet shop uygulaması. Flutter ile geliştirilmiş mobil uygulama ve Node.js/Express.js ile geliştirilmiş RESTful API backend'i içeren kapsamlı bir proje.

## 📱 Proje Hakkında

Pet Shop App, evcil hayvan satış platformu için geliştirilmiş tam kapsamlı bir mobil uygulamadır. Kullanıcılar evcil hayvanları görüntüleyebilir, favorilere ekleyebilir, detaylı bilgileri inceleyebilir ve profil yönetimi yapabilir. Admin paneli ile yöneticiler evcil hayvan yönetimi yapabilir.

### 🎯 Proje Özellikleri

- ✅ **Kullanıcı Yönetimi**: Kayıt, giriş, profil yönetimi
- ✅ **Sosyal Giriş**: Google ve Facebook ile giriş desteği
- ✅ **Evcil Hayvan Listeleme**: Kategori bazlı filtreleme ve arama
- ✅ **Favori Sistemi**: Favorilere ekleme/çıkarma ve listeleme
- ✅ **Detaylı Bilgi**: Evcil hayvan detay sayfaları (sağlık durumu, sahip bilgileri)
- ✅ **Admin Paneli**: Evcil hayvan ekleme, düzenleme, silme
- ✅ **Çoklu Dil Desteği**: Türkçe ve İngilizce
- ✅ **Responsive Tasarım**: Farklı ekran boyutlarına uyumlu
- ✅ **Clean Architecture**: Modüler ve ölçeklenebilir kod yapısı

## 🏗️ Proje Yapısı

```
pet_shop_app/
├── pet_shop_mobile/          # Flutter mobil uygulama
│   ├── lib/
│   │   ├── core/            # Temel yapılar (DI, routing, constants)
│   │   ├── feature/         # Özellik bazlı modüller
│   │   └── l10n/            # Lokalizasyon dosyaları
│   └── assets/              # Görseller ve çeviri dosyaları
│
└── pet_shop_backend/         # Node.js/Express.js backend
    ├── src/
    │   ├── controllers/     # İş mantığı kontrolcüleri
    │   ├── routes/          # API route tanımları
    │   ├── middleware/      # Auth, error handling middleware
    │   ├── config/          # Firebase, env konfigürasyonları
    │   └── utils/           # Yardımcı fonksiyonlar
    └── scripts/             # Seed ve admin scriptleri
```

## 🛠️ Teknolojiler

### 📱 Frontend (Mobile)
- **Flutter** - Cross-platform mobil framework
- **Dart** - Programlama dili
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

## 📸 Ekran Görüntüleri

<!-- Ekran görüntüleri buraya eklenecek -->
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

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler

- Flutter SDK (>=3.8.0)
- Dart SDK (>=3.8.0)
- Node.js (>=18.0.0)
- npm veya yarn
- Firebase projesi ve service account key

### Backend Kurulumu

```bash
cd pet_shop_backend
npm install
```

`.env` dosyası oluşturun:
```env
PORT=5001
NODE_ENV=development
GOOGLE_APPLICATION_CREDENTIALS=config/firebase-service-account-key.json
FIREBASE_WEB_API_KEY=your_firebase_web_api_key
```

Backend'i başlatın:
```bash
npm run dev
```

### Mobile Kurulumu

```bash
cd pet_shop_mobile
flutter pub get
```

`.env` dosyası oluşturun:
```env
API_BASE_URL=http://localhost:5001
```

Uygulamayı çalıştırın:
```bash
flutter run
```

Detaylı kurulum talimatları için:
- [Mobile README](pet_shop_mobile/README.md)
- [Backend README](pet_shop_backend/README.md)

## 🏛️ Mimari

### Clean Architecture

Proje Clean Architecture prensiplerine göre yapılandırılmıştır:

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

BLoC (Business Logic Component) pattern kullanılarak state management yapılmıştır:
- **Cubit**: Basit state yönetimi için
- **Equatable**: State karşılaştırmaları için
- **BlocProvider**: Dependency injection için

### Dependency Injection

GetIt service locator kullanılarak dependency injection yapılmıştır:
- Singleton pattern için `registerLazySingleton`
- Factory pattern için `registerFactory`

## 🔐 Güvenlik

- Firebase Authentication ile güvenli kullanıcı yönetimi
- JWT token tabanlı authentication
- Role-based access control (Admin/User)
- Helmet ile güvenlik header'ları
- CORS yapılandırması
- Environment variables ile hassas bilgi yönetimi
- `.gitignore` ile hassas dosyaların korunması

## 📚 API Dokümantasyonu

Backend API endpoint'leri:

### Authentication
- `POST /api/auth/register` - Kullanıcı kaydı
- `POST /api/auth/login` - Kullanıcı girişi
- `POST /api/auth/google` - Google ile giriş
- `POST /api/auth/facebook` - Facebook ile giriş
- `GET /api/auth/me` - Kullanıcı bilgileri
- `POST /api/auth/logout` - Çıkış

### Pets
- `GET /api/pets` - Tüm evcil hayvanları listele
- `GET /api/pets/:id` - Evcil hayvan detayı
- `GET /api/pets/category/:category` - Kategoriye göre listele

### Favorites
- `GET /api/favorites` - Favorileri listele
- `POST /api/favorites` - Favori ekle
- `DELETE /api/favorites/:id` - Favori sil

### Admin
- `GET /api/admin/check` - Admin kontrolü
- `POST /api/admin/pets` - Evcil hayvan ekle
- `PUT /api/admin/pets/:id` - Evcil hayvan güncelle
- `DELETE /api/admin/pets/:id` - Evcil hayvan sil

Postman collection: `pet_shop_backend/Pet_Shop_API.postman_collection.json`

## 🌍 Lokalizasyon

Uygulama çoklu dil desteği sunar:
- 🇹🇷 Türkçe
- 🇬🇧 İngilizce

Lokalizasyon dosyaları: `pet_shop_mobile/assets/l10n/`

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

## 🧪 Test

```bash
# Backend testleri
cd pet_shop_backend
npm test

# Mobile testleri
cd pet_shop_mobile
flutter test
```

## 📝 Lisans

Bu proje eğitim ve portfolyo amaçlı geliştirilmiştir.

## 👨‍💻 Geliştirici

**Dogan Senturk**

- Portfolio: [GitHub Profil](https://github.com/yourusername)
- LinkedIn: [LinkedIn Profil](https://linkedin.com/in/yourusername)
- Email: your.email@example.com

## 🙏 Teşekkürler

Bu projede kullanılan tüm açık kaynak kütüphanelere teşekkürler.

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!

