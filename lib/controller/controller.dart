import 'package:dear_diary/model.dart/entry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class controller {
  late Box<Entry> db;
  controller() {
    db = Hive.box('Logs');
  }

  Future<bool> addLog(
      String description, DateTime date, double rating, String? photo) async {
    
    if (db.containsKey(int.parse(DateFormat('yyyyMMdd').format(date)))) {
      return false;
    } else {
      await db.put(int.parse(DateFormat('yyyyMMdd').format(date)),
          Entry(rating, date, description, photo));

      return true;
    }
  }

  Iterable<dynamic> getkeys() {
    return db.keys;
  }

  Entry? getEntry(var key) {
    return db.get(key);
  }

  void removeLog(int key) async {
    await db.delete(key);
  }
}
