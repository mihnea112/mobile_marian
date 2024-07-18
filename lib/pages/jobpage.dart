import 'dart:async';

import 'package:appv2/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>['Waiting', 'In Progress', 'Done'];

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.id});
  final int id;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  List<dynamic> cars = [];
  List<Map<String, dynamic>> job = [];
  List<Map<String, dynamic>> inspections = [];
  int carId = 0;
  String dropdownValue = '';
  @override
  void initState() {
    super.initState();
    getData();
    getCarsFromApi();
  }

  void getData() async {
    await getJobFromApi();
    dropdownValue = job[0]['status'];
    await getInspectionsFromApi();
  }

  Future<void> getJobFromApi() async {
    try {
      var res = await http.get(
          Uri.parse("http://localhost:3002/jobs/${widget.id}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (res.statusCode == 201) {
        setState(() {
          final decode = jsonDecode(res.body);
          job = List<Map<String, dynamic>>.from(decode);
          carId = decode[0]['carId'];
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  Future<void> getCarsFromApi() async {
    try {
      var res = await http.get(
        Uri.parse("http://localhost:3002/car/${widget.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 201) {
        setState(() {
          final decode = jsonDecode(res.body);
          cars = decode as List<dynamic>;
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  Future<void> getInspectionsFromApi() async {
    try {
      var res = await http.get(
          Uri.parse("http://localhost:3002/inspect/$carId"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (res.statusCode == 201) {
        setState(() {
          final decode = jsonDecode(res.body);
          inspections = List<Map<String, dynamic>>.from(decode);
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  Future<void> updateStatus(String? value) async {
    String? token = await storage.read(key: "token");
    var regBody = {
      "id": job[0]['id'],
      "token": token,
      "status": value,
      "nPlate": cars[0]['nPlate'],
      "uId": cars[0]['userId']
    };
    var res = await http.post(Uri.parse("http://localhost:3002/status"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));
    if (res.statusCode == 201) {
      setState(() {
        final decode = jsonDecode(res.body);
        job = List<Map<String, dynamic>>.from(decode);
      });
    }
  }

  Future<bool> updateInspection(int value, int id) async {
    String? token = await storage.read(key: "token");
    var regBody = {
      "id": id,
      "val": value,
      "token": token,
    };
    var res = await http.post(Uri.parse("http://localhost:3002/inspection"),
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
        title: Text(
          "Job #${widget.id}",
          style: const TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
      body: Column(
        children: [
          cars.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Numar inmatriculare: ${cars[0]['nPlate']}',
                        style: const TextStyle(color: Color(0xFFA5D7E8)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Serie sasiu/Vin: ${cars[0]['VIN']}',
                        style: const TextStyle(color: Color(0xFFA5D7E8)),
                      ),
                    )
                  ],
                ),
          job.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Task: ${job[0]['tasks']}',
                        style: const TextStyle(color: Color(0xFFA5D7E8)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: DropdownMenu<String>(
                        helperText: "Status",
                        textStyle: TextStyle(color: Color(0xFFA5D7E8)),
                        initialSelection: job[0]['status'],
                        dropdownMenuEntries:
                            list.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                        onSelected: (String? value) {
                          updateStatus(value);
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
          inspections.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: inspections.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: const Color(0xFF576CBC),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        child: Slider(
                          value: inspections[index]['val'].toDouble(),
                          max: 2,
                          divisions: 2,
                          label: inspections[index]['val'].round().toString(),
                          onChanged: (double value) async {
                            bool res = await updateInspection(
                                value.toInt(), inspections[index]['id']);
                            if (res == true) {
                              setState(() {
                                inspections[index]['val'] = value.toInt();
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
