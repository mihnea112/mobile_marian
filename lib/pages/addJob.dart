// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appv2/main.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key, required this.id});
  final int id;
  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  TextEditingController taskController = TextEditingController();
  Future<bool> addJob(String task) async {
    String? token = await storage.read(key: "token");
    var regBody = {"token": token, "carId": widget.id, "tasks": task};
    var res = await http.post(
        Uri.parse("https://marian-app-api.vercel.app/jobs/add"),
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
          "Add Job",
          style: TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Descrie sarcina...',
                labelStyle: TextStyle(color: Color(0xFFA5D7E8)),
              ),
              style: const TextStyle(color: Color(0xFFA5D7E8)),
            ),
            TextButton(
                onPressed: () async {
                  var task = taskController.text;
                  bool res = await addJob(task);
                  if (res) {
                    Navigator.pop(context);
                  } else {
                    displayDialog(context, "Nu merge");
                  }
                },
                child: const Text("Add Job")),
          ],
        ),
      ),
    );
  }
}
