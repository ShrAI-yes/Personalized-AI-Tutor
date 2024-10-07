import 'dart:io';

import 'package:ev_simulator/comman.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/chat_screen.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/screens/questionpaper_screen.dart';
import 'package:ev_simulator/screens/summary_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class UploadScreen extends StatefulWidget {
  final User? user;
  const UploadScreen({super.key, this.user});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  FilePickerResult? result;
  bool isUploaded = false;
  UploadTask? uploadTask;

  Map<String, Function> options = {
    "Ask Questions": (context, url, user) => Navigator.push(context,
        MaterialPageRoute(builder: ((context) => ChatScreen(url: url)))),
    "Summarize Contenet": (context, url, user) => Navigator.push(context,
        MaterialPageRoute(builder: ((context) => SummaryScreen(url: url)))),
    "Take Quiz": (context, url, user) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => QuestionPaper(
                  url: url,
                  user: user,
                )))),
  };

  String chosenOption = "";
  String pdfUrl = "";
  bool isLoading = false;
  String? name;

  loadPdfOnServer(url) {
    String baseUrl = '${BACKEND_URL}/pdf';

    String fullUrl = '$baseUrl?url=$url';
    print("url " + fullUrl);
    http.get(Uri.parse(fullUrl)).then((response) {
      print(response.body);
      setState(() {
        isLoading = false;
      });
    });
  }

  uploadToFirebase(file, _path) async {
    final path = _path.toString().split('/').last;
    setState(() {
      isLoading = true;
    });
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      pdfUrl = urlDownload;
      name = path;
    });

    loadPdfOnServer(urlDownload);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(bgLight),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 40)),
                  textStyle:
                      WidgetStateProperty.all(const TextStyle(fontSize: 30))),
              onPressed: () async {
                result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );

                if (result == null) {
                  print("No file selected");
                } else {
                  setState(() {});
                  for (var element in result!.files) {
                    setState(() {
                      isUploaded = true;
                    });
                    File file = File(result!.files.single.path!);
                    await uploadToFirebase(file, result!.files.single.path!);
                    // loadPdfOnServer(
                    //     "https://firebasestorage.googleapis.com/v0/b/devignite-5823b.appspot.com/o/deen101.pdf?alt=media");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('pdf uploaded successfully')));
                  }
                }
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_upload_sharp,
                    size: 50,
                    color: Colors.amber,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Select a File to upload",
                    style: TextStyle(color: Colors.amber, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          name != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    name.toString().split("/").last,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          const Spacer(),
          isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Container(),
          Wrap(
              children: isUploaded
                  ? options.entries.map((item) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            chosenOption = item.key;
                          });

                          Future.delayed(Duration(milliseconds: 300),
                              () => item.value(context, pdfUrl, widget.user));
                        },
                        child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: item.key == chosenOption
                                    ? Colors.amber
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                item.key.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            )),
                      );
                    }).toList()
                  : []),
          const Spacer(),
        ],
      ),
    );
  }
}
