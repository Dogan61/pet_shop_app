import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';

void main() {
  group('AppBars Widget Tests', () {
    testWidgets('BackAppBar displays title correctly', (WidgetTester tester) async {
      const title = 'Test Title';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const BackAppBar(title: title),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('BackAppBar has back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: const BackAppBar(title: 'Test'),
          ),
        ),
      );

      final backButton = find.byIcon(Icons.arrow_back);
      expect(backButton, findsOneWidget);
    });

    testWidgets('EmptyAppBar renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: EmptyAppBar(),
          ),
        ),
      );

      // EmptyAppBar should render without errors
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}

