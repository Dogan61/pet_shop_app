# Test Documentation

Bu klasör projenin test dosyalarını içerir.

## Test Yapısı

```
test/
├── unit/              # Unit testler
│   └── bloc/         # BLoC/Cubit testleri
├── widgets/          # Widget testleri
└── README.md         # Bu dosya
```

## Test Çalıştırma

### Tüm testleri çalıştır:
```bash
flutter test
```

### Belirli bir test dosyasını çalıştır:
```bash
flutter test test/unit/bloc/auth_cubit_test.dart
```

### Test coverage raporu:
```bash
flutter test --coverage
```

## Test Yazma Rehberi

### Unit Testler (BLoC/Cubit)

BLoC/Cubit testleri için `bloc_test` paketi kullanılır:

```dart
blocTest<AuthCubit, AuthState>(
  'test description',
  build: () {
    // Mock repository setup
    return cubit;
  },
  act: (cubit) => cubit.someMethod(),
  expect: () => [
    // Expected states
  ],
);
```

### Widget Testleri

Widget testleri için `flutter_test` paketi kullanılır:

```dart
testWidgets('widget description', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.text('Hello'), findsOneWidget);
});
```

## Mock Kullanımı

Mock objeler için `mocktail` paketi kullanılır:

```dart
class MockAuthRepository extends Mock implements AuthRepository {}
```

## Notlar

- Test dosyaları `_test.dart` uzantısı ile bitmelidir
- Her test dosyası bir `main()` fonksiyonu içermelidir
- `setUp()` ve `tearDown()` fonksiyonları test lifecycle'ını yönetir

