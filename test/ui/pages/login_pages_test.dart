import 'dart:async';

import 'package:cleanflutterapp/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    emailErrorController = StreamController<String>();
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(
        home: LoginPage(
      presenter: presenter,
    ));

    await tester.pumpWidget(loginPage);
  }

  tearDown((() {
    emailErrorController.close();
  }));
  testWidgets(
    'Shold load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

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

  testWidgets(
    'Shold call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      final password = faker.internet.password();

      await tester.enterText(find.bySemanticsLabel('Email'), email);

      verify(presenter.validateEmail(email));

      await tester.enterText(find.bySemanticsLabel('Senha'), password);

      verify(presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Shold present error if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add('any error');

      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );
}
