import 'dart:convert';
import 'package:ev_simulator/comman.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  String url;
  SummaryScreen({super.key, required this.url});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool isLoading = false;
  String summary = "";

  askQuestionServer() async {
    String baseUrl = '${BACKEND_URL}/summary';

    String fullUrl = '$baseUrl?url=${widget.url}';

    setState(() {
      isLoading = true;
    });

    http.get(Uri.parse(fullUrl)).then((response) {
      print("inside");
      print(response.body);
      var body = jsonDecode(response.body);
      print("body");
      print(body);
      setState(() {
        summary = body["answer"];
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    askQuestionServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgLight,
        appBar: AppBar(
          backgroundColor: bgLight,
          leading: Container(),
          centerTitle: true,
          title: const Text(
            "TutorEase",
            style: TextStyle(
                color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Authentication.signOut(context: context).then((value) =>
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const LoginScreen()))));
              },
              icon: const Icon(
                Icons.logout,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.amber,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Summary :",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            summary,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }
}
