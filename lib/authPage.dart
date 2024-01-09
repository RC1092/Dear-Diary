import 'package:dear_diary/logpage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as UIAuth;

class authPage extends StatelessWidget {
  const authPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return UIAuth.SignInScreen(providers: [
              UIAuth.EmailAuthProvider(),
            ]);
          }

          return const LogPage();
        });
  }
}
