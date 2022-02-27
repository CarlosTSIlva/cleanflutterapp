import 'package:cleanflutterapp/ui/components/components.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

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
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'email',
                      icon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                      )),
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'senha',
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                    obscureText: true,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Entrar'.toUpperCase()),
                ),
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
