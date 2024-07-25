import 'package:appv2/pages/addJob.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarPage extends StatefulWidget {
  const CarPage({super.key, required this.id});
  final int id;
  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  List<dynamic> cars = [];
  List<Map<String, dynamic>> jobs = [];
  @override
  void initState() {
    super.initState();
    getCarsFromApi();
    getJobsFromApi();
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

  Future<void> getJobsFromApi() async {
    try {
      var res = await http.get(
        Uri.parse("http://localhost:3002/job/${widget.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 201) {
        setState(() {
          final decode = jsonDecode(res.body);
          jobs = List<Map<String, dynamic>>.from(decode);
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  Future<void> refresh() async {
    await getJobsFromApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19376D),
      appBar: AppBar(
        title: const Text(
          "My Car",
          style: TextStyle(color: Color(0xFFA5D7E8)),
        ),
        backgroundColor: const Color(0xFF19376D),
      ),
      body: cars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  "Numar inmatriculare:${cars[0]['nPlate']}",
                  style: const TextStyle(color: Color(0xFFA5D7E8)),
                ),
                Text(
                  "Serie sasiu/VIN:${cars[0]['VIN']}",
                  style: const TextStyle(color: Color(0xFFA5D7E8)),
                ),
                jobs.isEmpty
                    ? const Center(child: Text("No jobs found"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: const Color(0xFF576CBC),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Task: ${jobs[index]['tasks']}',
                                    style: const TextStyle(
                                        color: Color(0xFFA5D7E8)),
                                  ),
                                  Text(
                                    'Status: ${jobs[index]['status']}',
                                    style: const TextStyle(
                                        color: Color(0xFFA5D7E8)),
                                  ),
                                  Text(
                                    'Date: ${jobs[index]['date'].toString().split('T')[0]}',
                                    style: const TextStyle(
                                        color: Color(0xFFA5D7E8)),
                                  ),
                                  Text(
                                    'Piese schimbate: ${jobs[index]['piese']}',
                                    style: const TextStyle(
                                        color: Color(0xFFA5D7E8)),
                                  ),
                                  Text(
                                    'Feedback : ${jobs[index]['feedback']}',
                                    style: const TextStyle(
                                        color: Color(0xFFA5D7E8)),
                                  ),
                                  Text(
                                    'Deadline : ${jobs[index]['deadline']}',
                                    style: const TextStyle(
                                        color: Color(0xFFA5D7E8)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddJob(id: cars[0]['id'])),
          ).then((value) => {refresh()});
        },
        tooltip: 'Add Job',
        child: const Icon(Icons.add),
      ),
    );
  }
}
