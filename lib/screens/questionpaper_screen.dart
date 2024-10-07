import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_simulator/comman.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class QuestionPaper extends StatefulWidget {
  String url;
  final User? user;
  QuestionPaper({super.key, required this.url, this.user});

  @override
  State<QuestionPaper> createState() => _QuestionPaperState();
}

class _QuestionPaperState extends State<QuestionPaper> {
  bool isLoading = false;
  String question = "";

  askQuestionServer() async {
    String baseUrl = '${BACKEND_URL}/question-paper';

    String fullUrl = '$baseUrl?url=${widget.url}';

    setState(() {
      isLoading = true;
    });

    var snapshot = await FirebaseFirestore.instance
        .collection("userInfo")
        .doc(widget.user!.uid)
        .get();
    var userData = snapshot.data();
    print(userData);

    var res = await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode({
        "goal": userData!["goal"],
        "preference": userData!["preference"],
        "hideWords": userData["hideWords"],
        "isExam": userData["isExam"].toString(),
        "age": userData["age"]
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );

    var body = jsonDecode(res.body);

    setState(() {
      question = body["answer"];
      isLoading = false;
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
            : SingleChildScrollView(
                child: Column(
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
                              question,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
