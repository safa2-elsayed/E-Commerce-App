import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool rememberMe = false;

  void toggleRememberMe(bool value) {
    rememberMe = value;
    emit(AuthRememberMeChanged(rememberMe));
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthFailure("Please fill all fields"));
      return;
    }

    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setBool("rememberMe", true);
        await prefs.setString("savedEmail", email);
      } else {
        await prefs.remove("rememberMe");
        await prefs.remove("savedEmail");
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? 'Login failed';
      emit(AuthFailure(errorMessage));
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setBool("rememberMe", true);
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Sign up failed';
      emit(AuthFailure(message));
    } catch (e) {
      emit(AuthFailure('Sign up failed: ${e.toString()}'));
    }
  }

  Future<void> loadRememberMe(TextEditingController emailController) async {
    final prefs = await SharedPreferences.getInstance();
    final savedRemember = prefs.getBool("rememberMe") ?? false;
    final savedEmail = prefs.getString("savedEmail") ?? '';

    rememberMe = savedRemember;
    if (savedRemember) {
      emailController.text = savedEmail;
    }

    emit(AuthRememberMeChanged(rememberMe));
  }
}
