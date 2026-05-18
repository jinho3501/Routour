import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _message = '';
  String get message => _message;

  void setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _message = '로그인 성공';
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _message = e.message ?? '로그인 실패';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _message = '회원가입 성공';
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _message = e.message ?? '회원가입 실패';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithCredential(AuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
      _message = '로그인 성공';
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _message = e.message ?? '로그인 실패';
      notifyListeners();
      return false;
    }
  }
}