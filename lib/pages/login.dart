import 'package:appv2/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appv2/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<Map<String, dynamic>?> attemptLogIn(
      String email, String password) async {
    var regBody = {"email": email, "password": password};
    var res = await http.post(Uri.parse("http://localhost:3002/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    final parsedList = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 201) {
      return parsedList;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: const Color(0xFF19376D),
        appBar: AppBar(
          title: const Text(
            "Login",
            style: TextStyle(color: Color(0xFFA5D7E8)),
          ),
          backgroundColor: const Color(0xFF19376D),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextButton(
                  onPressed: () async {
                    var username = emailController.text;
                    var password = passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    if (jwt != null) {
                      storage.write(key: "token", value: jwt['token']);
                      ref
                          .read(indexBottomNavbarProvider.notifier)
                          .update((state) => 0);
                      ref
                          .read(roleProvider.notifier)
                          .update((state) => jwt['role']);
                    } else {
                      // ignore: use_build_context_synchronously
                      displayDialog(context, "An Error Occurred",
                          "No account was found matching that username and password");
                    }
                  },
                  child: const Text("Log In")),
            ])));
  }
}
