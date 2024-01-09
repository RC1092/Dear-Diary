import 'package:dear_diary/authPage.dart';

import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const init());
}

class init extends StatelessWidget {
  const init({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: authPage(),
    );
  }
}
