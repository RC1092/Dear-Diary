import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/logpage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl/intl.dart';

class EntryPage extends StatelessWidget {
  final Function back;

  const EntryPage(this.back);

  Widget build(BuildContext context) {
    var text = TextEditingController();
    var formkey = GlobalKey<FormState>();
    var cont = controller();
    List<String>? photo;
    double rating = 1;
    DateTime date = DateTime.now();
    return Hero(
      tag: 'tag',
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.4),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 150, 8, 75),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 229, 180),
                borderRadius: BorderRadius.circular(20)),
            height: 450,
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 130,
                      child: TextFormField(
                        maxLines: 3,
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
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: RatingBar.builder(
                          minRating: 1,
                          initialRating: 1,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.favorite),
                          onRatingUpdate: (newRating) => {rating = newRating}),
                    ),
                    SizedBox(
                      height: 60,
                      width: 300,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        itemExtent: 40,
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
                      width: 500,
                      child: FormBuilderImagePicker(
                        name: 'photo',
                        previewHeight: 150,
                        previewWidth: 90,
                        placeholderWidget: Container(
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.blueGrey),
                            child: const Icon(Icons.upload)),
                        maxImages: 3,
                        imageQuality: 25,
                        previewAutoSizeWidth: false,
                        decoration: const InputDecoration(
                            labelText: '  Pick Photo (Max : 3)',
                            labelStyle: TextStyle(fontSize: 20)),
                        onChanged: (value) {
                          if (value!.isEmpty) {
                            photo = null;
                          } else {
                            photo =
                                value.map((e) => e.path.toString()).toList();
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          const Spacer(
                            flex: 1,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                if (photo != null && photo!.length > 3) {
                                  photo = photo!.sublist(0, 3);
                                }
                                await cont.addLog(
                                    text.text,
                                    int.parse(
                                        DateFormat('yyyyMMdd').format(date)),
                                    rating,
                                    photo);

                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            const LogPage()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 247, 70, 70),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15)),
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
