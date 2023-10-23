import 'dart:io';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
part 'entry.g.dart';

@HiveType(typeId: 1)
class Entry {
  @HiveField(0)
  late double rating;
  @HiveField(1)
  late DateTime day;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late String photoPath;

  Entry(this.rating, this.day, this.description, photo) {
    if (photo != null) {
      photoPath = photo;
    } else {
      photoPath = 'init';
    }
  }

  double getRating() {
    return rating;
  }

  DateTime getDay() {
    return day;
  }

  String getDesc() {
    return description;
  }

  Image getPhoto() {
    if (photoPath == 'init') {
      return const Image(image: AssetImage('lib/assets/default.jpg'));
    }
    return Image.file(File(photoPath));
  }
}
