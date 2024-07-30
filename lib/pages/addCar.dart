// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appv2/main.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  TextEditingController vinController = TextEditingController();

  TextEditingController nPlateController = TextEditingController();
  Future<bool> addCar(String nPlate, String vin) async {
    String? token = await storage.read(key: "token");
    var regBody = {"token": token, "nPlate": nPlate, "VIN": vin};
    var res = await http.post(
        Uri.parse("https://marian-app-api.vercel.app/car/add"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    if (res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  void displayDialog(context, title) => showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(title)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19376D),
      appBar: AppBar(
        title: const Text(
          "Add Car",
          style: TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: vinController,
              decoration: const InputDecoration(
                labelText: 'Serie Sasiu/Vin',
                labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
              ),
              style: const TextStyle(color: Color(0xFFA5D7E8)),
            ),
            TextField(
              controller: nPlateController,
              decoration: const InputDecoration(
                labelText: 'Numar inmatriculare',
                labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
              ),
              style: const TextStyle(color: Color(0xFFA5D7E8)),
            ),
            TextButton(
                onPressed: () async {
                  var vin = vinController.text;
                  var nPlate = nPlateController.text;
                  bool res = await addCar(nPlate, vin);
                  if (res) {
                    Navigator.pop(context);
                  } else {
                    displayDialog(context, "Nu merge");
                  }
                },
                child: const Text("Log In")),
          ],
        ),
      ),
    );
  }
}
