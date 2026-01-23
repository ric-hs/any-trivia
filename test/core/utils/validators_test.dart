import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:endless_trivia/core/utils/validators.dart';
import 'package:endless_trivia/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('Validators', () {
    group('emailValidator', () {
      testWidgets('should return null for valid email', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) {
                expect(Validators.emailValidator(context, 'test@example.com'), null);
                expect(Validators.emailValidator(context, 'user.name@domain.co.uk'), null);
                return const Placeholder();
              },
            ),
          ),
        );
      });

      testWidgets('should return error message for empty email', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) {
                expect(Validators.emailValidator(context, ''), 'Please enter an email address');
                expect(Validators.emailValidator(context, null), 'Please enter an email address');
                return const Placeholder();
              },
            ),
          ),
        );
      });

      testWidgets('should return error message for invalid email', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) {
                expect(Validators.emailValidator(context, 'invalid-email'), 'Please enter a valid email address');
                expect(Validators.emailValidator(context, 'test@'), 'Please enter a valid email address');
                expect(Validators.emailValidator(context, '@example.com'), 'Please enter a valid email address');
                return const Placeholder();
              },
            ),
          ),
        );
      });
      
      testWidgets('should return localized error message for Spanish', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('es')],
            locale: const Locale('es'),
            home: Builder(
              builder: (context) {
                expect(Validators.emailValidator(context, ''), 'Por favor ingresa un correo');
                expect(Validators.emailValidator(context, 'invalid'), 'Por favor ingresa un correo válido');
                return const Placeholder();
              },
            ),
          ),
        );
      });
    });
  });
}
