class Entry {
  late double rating;

  late int day;

  late String description;

  Entry(this.rating, this.day, this.description);

  double getRating() {
    return rating;
  }

  int getDay() {
    return day;
  }

  String getDesc() {
    return description;
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'day': day,
      'desc': description,
    };
  }

  static Entry fromMap(Map map) {
    return Entry(
      map['rating'],
      map['day'],
      map['desc'],
    );
  }
}
