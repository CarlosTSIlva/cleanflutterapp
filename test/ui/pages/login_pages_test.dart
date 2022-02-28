import 'package:cleanflutterapp/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Shold load with correct initial state',
    (WidgetTester tester) async {
      const loginPage = MaterialApp(home: LoginPage());

      await tester.pumpWidget(loginPage);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(emailTextChildren, findsOneWidget,
          reason:
              "when a textFormField has only one text child, means it has no errorsm since one of the childs is always the label text.");

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordTextChildren, findsOneWidget,
          reason:
              "when a textFormField has only one text child, means it has no errorsm since one of the childs is always the label text.");

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
    },
  );
}
