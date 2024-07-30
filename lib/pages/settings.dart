import 'package:appv2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appv2/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Settings();
}

class _Settings extends ConsumerState<Settings> {
  TextEditingController nameController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserFromApi();
  }

  Future<void> getUserFromApi() async {
    try {
      String? token = await storage.read(key: "token");
      var res = await http.get(
        Uri.parse("https://marian-app-api.vercel.app/userdata?token=$token"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 201) {
        setState(() {
          final decode = jsonDecode(res.body);
          nameController.text = decode[0]['name'];
          adressController.text = decode[0]['adresa'];
          telephoneController.text = decode[0]['telefon'].toString();
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  Future<bool> updateData() async {
    String? token = await storage.read(key: "token");
    var regBody = {
      "token": token,
      "name": nameController.text,
      "adresa": adressController.text,
      "telefon": telephoneController.text,
    };
    var res = await http.post(
        Uri.parse("https://marian-app-api.vercel.app/userdata/edit"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    if (res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19376D),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nume',
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
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
                ),
                style: const TextStyle(color: Color(0xFFA5D7E8)),
              ),
              TextButton(
                  onPressed: () async {
                    bool res = await updateData();
                    if (res) {
                      await getUserFromApi();
                      setState(() {});
                    }
                  },
                  child: const Text("Edit Data")),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(roleProvider.notifier).update((state) => 5);
          ref.read(indexBottomNavbarProvider.notifier).update((state) => 0);
          storage.deleteAll();
        },
        tooltip: 'Logout',
        child: const Icon(Icons.login_outlined),
      ),
    );
  }
}
