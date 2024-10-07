import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/details_screen.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutScreen extends StatelessWidget {
  User? user;
  SignOutScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void signOutFunction() {
      Authentication.signOut(context: context)
          .then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => LoginScreen()),
              ));
    }

    void deleteFromStore(user) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (ctx) => DetailScreen(user: user)),
      );
      FirebaseFirestore.instance.collection("userInfo").doc(user!.uid).delete();
    }

    return GestureDetector(
      onTap: (() => signOutFunction()),
      child: const CustomButton(
        btnName: "SignOut",
        height: 50,
        width: 120,
      ),
    );
  }
}
