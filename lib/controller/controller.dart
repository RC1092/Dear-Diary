import 'dart:io';
import 'dart:convert';
import 'package:dear_diary/logpage.dart';
import 'package:dear_diary/model.dart/entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class controller {
  final user = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final noti = FirebaseMessaging.instance;
  late Reference imgDB;
  late CollectionReference logDB;

  controller() {
    logDB = FirebaseFirestore.instance
        .collection('UserLogs')
        .doc(user)
        .collection('Logs');
    logDB.orderBy("day", descending: true);
    imgDB = FirebaseStorage.instance.ref().child('images/$user');
    initNotification();
  }

  Future<void> initNotification() async {
    await noti.requestPermission();
    var fcm = noti.getToken();
    
  }

  Future<bool> addLog(
      String description, int date, double rating, List<String>? photo) async {
    Entry entry = Entry(rating, date, description);

    var doc = await logDB.doc(date.toString()).get();
    List<String> imgAdd = [];

    if (doc.exists) {
      return false;
    } else {
      if (photo != null) {
        for (int i = 0; i < photo.length; i++) {
          try {
            await imgDB
                .child('$date/${basename(photo[i])}')
                .putFile(File(photo[i]));
            imgAdd.add('$date/${basename(photo[i])}');
          } catch (e) {
            imgAdd.add(photo[i]);
          }
        }
      }
      Map<String, dynamic> map = entry.toMap();
      map['img'] = imgAdd;
      logDB.doc(date.toString()).set(map);
      return true;
    }
  }

  Future<void> deleteImage(String date, String path, List<String> paths) async {
    try {
      await imgDB.child(path).delete();

      var log = await logDB.doc(date).update({'img': paths});
    } catch (e) {}
  }

  Future<List<dynamic>> getPhotoURLs(String key) async {
    var map = await logDB
        .doc(key)
        .get()
        .then((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);
    return map['img'].cast<String>();
  }

  Future<bool> updateLog(
      String description, int date, double rating, List<String>? photo) async {
    try {
      await removeLog(date.toString());
      await addLog(description, date, rating, photo);

      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<Entry?> getEntry(String key) async {
    return Entry.fromMap(await logDB
        .doc(key)
        .get()
        .then((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>));
  }

  Future<List<Entry>> getAllEntry() async {
    QuerySnapshot allLogs = await logDB.orderBy("day", descending: true).get();
    return allLogs.docs
        .map((e) => Entry.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> removeLog(String key) async {
    await logDB.doc(key).delete();

    try {
      await imgDB.child(key).delete();
    } catch (e) {
      return;
    }
  }

  Future<List<Image>> getImage(int key) async {
    var imagesDat = await logDB
        .doc('$key')
        .get()
        .then((value) => value.data() as Map<String, dynamic>);

    if (imagesDat == null || imagesDat['img'] == null) {
      return [const Image(image: AssetImage('lib/assets/default.jpg'))];
    }

    List? images = imagesDat['img'];

    List<Image>? imagLst = [];
    for (int i = 0; i < images!.length; i++) {
      try {
        var imgsrc = await imgDB.child(images[i].toString()).getData();
        imagLst?.add(Image.memory(imgsrc!));
      } on Exception catch (e) {}
    }
    ;

    if (imagLst.isEmpty) {
      imagLst = [const Image(image: AssetImage('lib/assets/default.jpg'))];
    }
    return imagLst;
  }

  Future<Map<String, dynamic>> getProfile() async {
    Map<String, dynamic> data = <String, dynamic>{};
    List<Entry> entries = await getAllEntry();
    data['Last'] = entries[0].getDay();
    data['First'] = entries[entries.length - 1].getDay();
    int curr = int.parse(entries[0].getDay().toString().substring(0, 4));
    entries.removeWhere((element) =>
        int.parse(element.getDay().toString().substring(0, 4)) != curr);

    Map<int, double> average = <int, double>{};
    for (int i = 1; i <= 12; i++) {
      double averageRating = 0;
      List<Entry> listKeys = entries.where((element) {
        return int.parse(element.getDay().toString().substring(4, 6)) == i;
      }).toList();
      for (var element in listKeys) {
        averageRating += element.getRating();
      }
      averageRating = averageRating / listKeys.length;
      if (averageRating.isNaN) {
        average[i] = 0;
      } else {
        average[i] = averageRating;
      }
    }

    data['averages'] = average;
    return data;
  }
}
