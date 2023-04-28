import 'package:flutter/material.dart';

enum ModoLogin { Registrar, Login }

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _estaLogando = false;
  ModoLogin _modoLogin = ModoLogin.Login;
  Map<String, String> _dadosLogin = {
    'email': '',
    'password': '',
  };

  void _auternarModoLogin() {
    setState(() {
      if (_eLogin()) {
        _modoLogin = ModoLogin.Registrar;
      } else {
        _modoLogin = ModoLogin.Login;
      }
    });
  }

  void _submit() {
    setState(() => _estaLogando = true);
  }

  bool _eLogin() => _modoLogin == ModoLogin.Login;
  bool _eRegistro() => _modoLogin == ModoLogin.Registrar;

  @override
  Widget build(BuildContext context) {
    final tamanhoTela = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.only(top: 30),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: tamanhoTela.width * 0.75,
        height: _eLogin() ? 340 : 400,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'E-mail', icon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _dadosLogin['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informar um e-mail valido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Senha', icon: Icon(Icons.key)),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) =>
                    _dadosLogin['passeord'] == password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informar senha minimo 5 caracteres';
                  }
                  return null;
                },
              ),
              if (_eRegistro())
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Confirmar Senha', icon: Icon(Icons.key)),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password != _passwordController.text) {
                      return 'Senha informadas não conferem...';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              if (_estaLogando)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _eLogin() ? 'ENTRAR' : 'REGISTRAR',
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _auternarModoLogin,
                child: Text(
                  _eLogin() ? 'DESEJA REGISTRAR' : 'JÁ POSSUI CONTA?',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}