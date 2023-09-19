import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAFTtWKFMSftL6FbYEodciF7LUMzs_jC6w';
  final storage = const FlutterSecureStorage();
//Si teronamos algo, es un error si no, todo bien
  Future<String?> createUser(String email, String password) async {
    //Con un metodo POST se deve enviar un mapa
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signUp',
      {'key': _firebaseToken},
    );

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('idToken')) {
      //usando Storage para guardar el token de respuesta
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    //Con un metodo POST se deve enviar un mapa
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(
      _baseUrl,
      '/v1/accounts:signInWithPassword',
      {'key': _firebaseToken},
    );

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      //Guardando token token en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logOut() async {
    await storage.delete(key: 'token');
    return;
  }
}
