import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/service/auth_service_provider.dart';

class SignUpView extends StatefulWidget {
  static const path = '/sign_up';
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _authProvider = TaskAppAuthServiceProvider();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up for a free account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 18,
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
                onPressed: () {
                  _authProvider.signUp(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim());
                  Navigator.pushNamed(context, '/sign_in');
                },
                child: const Text('Sign Up'))
          ],
        ),
      ),
    );
  }
}
