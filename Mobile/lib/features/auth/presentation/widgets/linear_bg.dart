import 'package:flutter/material.dart';

class AuthLinearBg extends StatelessWidget {
  const AuthLinearBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFAB36C),
            Color(0x80FAC619),
            Color(0x40F2DC8C),
            Color(0x00EAF1FF),
          ],
          stops: [0.0, 0.51, 0.78, 0.96],
        ),
      ),
    );
  }
}
