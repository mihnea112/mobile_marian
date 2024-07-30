import 'package:appv2/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appv2/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  TextEditingController adressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController telefonController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<Map<String, dynamic>?> attemptLogIn() async {
    var regBody = {
      "name": nameController.text,
      "adresa": adressController.text,
      "telefon": telefonController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };
    var res = await http.post(
        Uri.parse("https://marian-app-api.vercel.app/register"),
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
            "Register",
            style: TextStyle(color: Color(0xFFA5D7E8)),
          ),
          backgroundColor: const Color(0xFF19376D),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nume si Prenume',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextField(
                controller: adressController,
                decoration: const InputDecoration(
                  labelText: 'Adresa',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextField(
                controller: telefonController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextField(
                controller: passwordCController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextButton(
                  onPressed: () async {
                    var jwt = await attemptLogIn();
                    if (jwt != null) {
                      storage.write(key: "token", value: jwt['token']);
                      ref
                          .read(indexBottomNavbarProvider.notifier)
                          .update((state) => 0);
                      ref.read(roleProvider.notifier).update((state) => 0);
                      Navigator.pop(context);
                    } else {
                      // ignore: use_build_context_synchronously
                      displayDialog(context, "An Error Occurred",
                          "No account was found matching that username and password");
                    }
                  },
                  child: const Text("Register")),
            ])));
  }
}
