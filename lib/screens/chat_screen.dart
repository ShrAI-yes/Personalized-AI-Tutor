import 'dart:convert';

import 'package:ev_simulator/comman.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/models/chat_message.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class ChatScreen extends StatefulWidget {
  String url;
  ChatScreen({super.key, required this.url});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "Hello, How can I help you?", messageType: "receiver"),
  ];
  bool isLoading = false;
  final TextEditingController msg = TextEditingController();
  void addToMessage() {
    setState(() {
      messages
          .add(ChatMessage(messageContent: msg.text, messageType: "sender"));
      isLoading = true;
    });
    askQuestionServer();
    msg.clear();
  }

  askQuestionServer() async {
    String baseUrl = '${BACKEND_URL}/res';

    String fullUrl = '$baseUrl?url=${widget.url}&&q=${msg.text}';

    http.get(Uri.parse(fullUrl)).then((response) {
      var body = jsonDecode(response.body);

      setState(() {
        messages.add(
            ChatMessage(messageContent: body["answer"], messageType: "sender"));
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
        backgroundColor: bgColor,
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
        body: Stack(children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white12,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white, // Set your desired text color here
                        fontSize: 16, // You can also change font size
                      ),
                      controller: msg,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      addToMessage();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.amber,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType == "receiver"
                          ? Colors.amber
                          : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      messages[index].messageContent,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          )
        ]));
  }
}
