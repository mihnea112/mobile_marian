import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.id});
  final int id;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  List<Map<String, dynamic>> cars = [];
  @override
  void initState() {
    super.initState();
    getCarsFromApi();
  }

  Future<void> getCarsFromApi() async {
    try {
      var res = await http.get(
          Uri.parse("http://localhost:3002/jobs/${widget.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (res.statusCode == 201) {
        setState(() {
          final decode = jsonDecode(res.body);
          cars = List<Map<String, dynamic>>.from(decode);
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
          "Job # ",
          style: TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
    );
  }
}
