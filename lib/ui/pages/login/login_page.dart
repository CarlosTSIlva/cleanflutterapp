import 'package:cleanflutterapp/ui/components/components.dart';
import 'package:cleanflutterapp/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key key, this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const LoginHeader(),
          const HeadLine1(text: 'Login'),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
                child: Column(
              children: [
                StreamBuilder<String>(
                    stream: const Stream.empty() ?? presenter.emailErrorStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          errorText: snapshot.data?.isEmpty == true
                              ? null
                              : snapshot.data,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (e) => presenter.validateEmail(e),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: StreamBuilder<String>(
                      stream:
                          const Stream.empty() ?? presenter.passwordErrorStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Senha',
                              icon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true
                                  ? null
                                  : snapshot.data),
                          onChanged: (e) => presenter.validatePassword(e),
                          obscureText: true,
                        );
                      }),
                ),
                StreamBuilder<bool>(
                    stream: const Stream.empty() ?? presenter.isFormValidStream,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.data == true ? () {} : null,
                        child: Text('Entrar'.toUpperCase()),
                      );
                    }),
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person),
                    label: const Text("Criar conta"))
              ],
            )),
          )
        ]),
      ),
    );
  }
}
