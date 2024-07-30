// ignore_for_file: file_names
import 'package:appv2/main.dart';
import 'package:appv2/pages/addCar.dart';
import 'package:appv2/pages/car.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mycars extends StatefulWidget {
  const Mycars({super.key});

  @override
  State<Mycars> createState() => _MycarsState();
}

class _MycarsState extends State<Mycars> {
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
      var res =
          await http.post(Uri.parse("https://marian-app-api.vercel.app/car"),
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

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19376D),
      appBar: AppBar(
        title: const Text(
          "My Cars",
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
                          builder: (context) => CarPage(id: cars[index]['id'])),
                    );
                  },
                  child: Container(
                    color: const Color(0xFF576CBC),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Numar inmatriculare: ${cars[index]['nPlate']}',
                          style: const TextStyle(color: Color(0xFFA5D7E8)),
                        ),
                        Text(
                          'Serie sasiu/Vin: ${cars[index]['VIN']}',
                          style: const TextStyle(color: Color(0xFFA5D7E8)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCar()),
          ).then((value) => {refresh()});
        },
        tooltip: 'Add Car',
        child: const Icon(Icons.add),
      ),
    );
  }
}
