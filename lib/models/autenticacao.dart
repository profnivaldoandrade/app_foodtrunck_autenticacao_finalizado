import 'dart:async';
import 'dart:convert';
import 'package:app_foodtrunck/execoes/execoes_autenticacao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Autenticacao with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expToken;
  Timer? _logoutTimer;

  bool get estaAutenticado {
    final estaAutenticado = _expToken?.isAfter(DateTime.now()) ?? false;
    return _token != null && estaAutenticado;
  }

  String? get token {
    return estaAutenticado ? _token : null;
  }

  String? get email {
    return estaAutenticado ? _email : null;
  }

  String? get userId {
    return estaAutenticado ? _userId : null;
  }

  Future<void> _autenticacao(
      String email, String password, String urlFragmento) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragmento?key=AIzaSyCF805VMvrJu6SRVawzsCZ7txe60k3RRRg';
    final resposta = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(resposta.body);

    if (body['error'] != null) {
      throw ExecoesAutenticacao(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expToken = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> registrar(String email, String password) async {
    return _autenticacao(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _autenticacao(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expToken = null;
    _limparLogoutTimer();
    notifyListeners();
  }
  void _limparLogoutTimer(){
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }
  void _autoLogout(){
    _limparLogoutTimer();
    final duracaoSessao = _expToken?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: duracaoSessao ?? 0 ), logout);
  }
}
