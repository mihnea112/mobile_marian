import 'package:appv2/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
      Map regBody = {"token": token};
      var body = json.encode(regBody);
      var res = await http.post(Uri.parse("http://localhost:3002/userdata"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
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
                decoration: const InputDecoration(labelText: 'Nume'),
              ),
              TextField(
                controller: adressController,
                decoration: const InputDecoration(labelText: 'Adresa'),
              ),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(labelText: 'Telefon'),
              ),
              TextButton(
                  onPressed: () async {}, child: const Text("Edit Data")),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        },
        tooltip: 'Logout',
        child: const Icon(Icons.login_outlined),
      ),
    );
  }
}
