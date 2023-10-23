import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/logpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:form_builder_image_picker/form_builder_image_picker.dart';

class EntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var text = TextEditingController();
    var formkey = GlobalKey<FormState>();
    var cont = controller();
    String? photo;
    double rating = 1;
    DateTime date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Entry"),
      ),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 200,
                child: TextFormField(
                  controller: text,
                  maxLength: 140,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Entry cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text(
                      "Enter today's summary",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: RatingBar.builder(
                    minRating: 1,
                    initialRating: 1,
                    itemBuilder: (context, _) => const Icon(Icons.favorite),
                    onRatingUpdate: (newRating) => {rating = newRating}),
              ),
              SizedBox(
                height: 60,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.parse("2000-01-01"),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (value) {
                    date = value;
                  },
                ),
              ),
              SizedBox(
                height: 150,
                width: 100,
                child: FormBuilderImagePicker(
                  name: 'photo',
                  maxImages: 1,
                  previewAutoSizeWidth: true,
                  decoration: const InputDecoration(labelText: 'Pick Photo'),
                  onChanged: (value) {
                    if (value!.isEmpty) {
                      photo = null;
                    } else {
                      photo = value[0].path;
                    }
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await cont.addLog(text.text, date, rating, photo);

                        CupertinoPageRoute(
                            builder: (context) => const LogPage());
                      }
                    },
                    child: const Text('Submit')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
