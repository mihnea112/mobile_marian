// ignore_for_file: file_names

import 'package:appv2/main.dart';
import 'package:appv2/pages/jobpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mecanicdash extends StatefulWidget {
  const Mecanicdash({super.key});

  @override
  State<Mecanicdash> createState() => _MecanicdashState();
}

class _MecanicdashState extends State<Mecanicdash> {
  List<Map<String, dynamic>> cars = [];
  @override
  void initState() {
    super.initState();
    getCarsFromApi();
  }

  Future<void> getCarsFromApi() async {
    try {
      String? token = await storage.read(key: "token");
      Map regBody = {"token": token};
      var body = json.encode(regBody);
      var res = await http.post(
          Uri.parse("https://marian-app-api.vercel.app/mecanic/car"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
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

  Future<void> refresh() async {
    await getCarsFromApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19376D),
      appBar: AppBar(
        title: const Text(
          "Cars&Jobs",
          style: TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
      body: cars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobPage(id: cars[index]['id'])),
                    ).then((value) => {refresh()});
                  },
                  child: Container(
                    color: const Color(0xFF576CBC),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${cars[index]['jobs'].length} Job/-s',
                            style: const TextStyle(color: Color(0xFFA5D7E8)),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Numar inmatriculare: ${cars[index]['nPlate']}',
                            style: const TextStyle(color: Color(0xFFA5D7E8)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Serie sasiu/Vin: ${cars[index]['VIN']}',
                            style: const TextStyle(color: Color(0xFFA5D7E8)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
