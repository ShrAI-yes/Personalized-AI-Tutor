import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/display_screen.dart';
import 'package:ev_simulator/screens/details_screen.dart';
import 'package:ev_simulator/screens/info_screen.dart';
import 'package:ev_simulator/screens/upload_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/bg.png",
              height: 400,
              width: 400,
            ),
            RichText(
                text: TextSpan(
                    text: "welcome to",
                    style: Styles.body.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                    children: const [
                  TextSpan(
                    text: " TutorEase",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  )
                ])),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (() {
                Authentication.signInWithGoogle(context: context).then(
                  (value) async {
                    if (value != null) {
                      var collection =
                          FirebaseFirestore.instance.collection('userInfo');
                      var docSnapshot = await collection.doc(value.uid).get();
                      if (docSnapshot.exists) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => UploadScreen(
                                    user: value,
                                  )),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => DetailScreen(
                                    user: value,
                                  )),
                        );
                      }
                    }
                  },
                );
              }),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50,
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(50)),
                  child: Image.asset(
                    "assets/google.png",
                    height: 40,
                    width: double.infinity,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
