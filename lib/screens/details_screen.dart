import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/display_screen.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/screens/upload_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:ev_simulator/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailScreen extends StatefulWidget {
  User? user;
  DetailScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController addressController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String dropdownvalue = '12';
  List<String> items = [
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18'
  ];

  void saveToFirebase() {
    FirebaseFirestore.instance
        .collection("userInfo")
        .doc(widget.user!.uid)
        .set({
      "name": nameController.text,
      "age": dropdownvalue,
      "preference": preference,
      "goal": goal,
      "isExam": switchValue,
      "hideWords": addressController.text
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('data added successfully')));
    }).then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) => UploadScreen(
                      user: widget.user,
                    ))));
  }

  List<String> prefList = ["solving problems", "taking quizzes", "reading"];
  String preference = "";

  List<String> goalList = [
    "improve grades",
    "understand a specific topic",
    "complete assignments faster"
  ];
  String goal = "";
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello ${widget.user!.displayName.toString()}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(
                height: 18,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter Student's name :",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a name';
                        }
                        return null;
                      }),
                      controller: nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xff0063F5))),
                        hintText: 'student name',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    // select Age
                    Row(
                      children: [
                        const Text("Select your age : ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.white)),
                        DropdownButton(
                          value: dropdownvalue,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          style: const TextStyle(color: Colors.amber),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    // How do you like to practice

                    const Text("How do you like to practice :",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(
                      height: 3,
                    ),
                    Wrap(
                      children: prefList.map((item) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              preference = item;
                            });
                          },
                          child: Container(
                              height: 50,
                              width: item.toString().length > 14
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 3,
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: preference == item
                                      ? Colors.amber
                                      : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              )),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    // goals
                    const Text("What are your goals :",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(
                      height: 3,
                    ),
                    Wrap(
                      children: goalList.map((item) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              goal = item;
                            });
                          },
                          child: Container(
                              width: item.toString().length > 14
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 3,
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: goal == item
                                      ? Colors.amber
                                      : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              )),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    // Ask for exam

                    const Text("Do you have any upcoming exams :",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(
                      height: 3,
                    ),
                    Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Colors.amber,
                        value: switchValue,
                        onChanged: (val) {
                          setState(() {
                            switchValue = !switchValue;
                          });
                        }),
                    const SizedBox(
                      height: 18,
                    ),
                    // hide words
                    const Text("Are there any words you would like to hide?",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      maxLines: 3,
                      controller: addressController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xff0063F5))),
                        hintText:
                            'enter comma (,) sperated words. eg: death, fire, ect',
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    GestureDetector(
                        onTap: (() {
                          if (_formKey.currentState!.validate()) {
                            saveToFirebase();
                          }
                        }),
                        child: const CustomButton(
                          btnName: "Continue",
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
