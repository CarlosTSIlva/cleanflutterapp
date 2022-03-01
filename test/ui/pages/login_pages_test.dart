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
  StreamController<String> passwordErrorController;
  StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();

    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(
        home: LoginPage(
      presenter: presenter,
    ));

    await tester.pumpWidget(loginPage);
  }

  tearDown((() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
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

  testWidgets(
    'Shold present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add(null);

      await tester.pump();
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel("Email"), matching: find.byType(Text));

      expect(emailTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Shold present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      emailErrorController.add('');

      await tester.pump();
      final emailTextChildren = find.descendant(
          of: find.bySemanticsLabel("Email"), matching: find.byType(Text));

      expect(emailTextChildren, findsOneWidget);
    },
  );

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);
    passwordErrorController.add('any error');

    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets(
    'Shold present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      passwordErrorController.add(null);

      await tester.pump();
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));

      expect(passwordTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Shold present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      passwordErrorController.add('');

      await tester.pump();
      final passwordTextChildren = find.descendant(
          of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));

      expect(passwordTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Shold enable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);
      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Shold enable button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);
      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
    },
  );
}
