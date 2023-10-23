import 'package:dear_diary/EntryPage.dart';
import 'package:dear_diary/logpage.dart';
import 'package:dear_diary/model.dart/entry.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EntryAdapter());
  var db = await Hive.openBox<Entry>('Logs');


  runApp(init());
}

class init extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogPage(),
    );
  }
}
