import 'package:ev_simulator/controller/auth_controller.dart';
import 'package:ev_simulator/screens/login_screen.dart';
import 'package:ev_simulator/styles.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
