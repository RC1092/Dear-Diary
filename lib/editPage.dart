import 'package:dear_diary/controller/controller.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:intl/intl.dart';

import 'logpage.dart';
import 'model.dart/entry.dart';

class editPage extends StatefulWidget {
  final Entry? entry;
  editPage(this.entry);
  @override
  State<editPage> createState() => editState(entry);
}

class editState extends State<editPage> {
  final cont = controller();
  final Entry? entry;
  editState(this.entry);
  void deleteImage(String path, List<String> newPath) {
    cont.deleteImage(entry!.getDay().toString(), path, newPath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var text = TextEditingController(text: entry!.getDesc());
    var formkey = GlobalKey<FormState>();
    var cont = controller();
    List<String>? photo = null;
    List<Widget>? savPhoto = null;

    double rating = entry!.getRating();
    int date = entry!.getDay();
    return FutureBuilder(
        future: Future.wait([
          cont.getImage(entry!.getDay()),
          cont.getPhotoURLs(date.toString())
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Icon(Icons.edit),
            );
          }
          savPhoto = snapshot.data![0].cast<Widget>();
          List<String> photoURls = snapshot.data![1] as List<String>;
          print(photoURls);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Change Entry"),
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
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: RatingBar.builder(
                          minRating: 1,
                          initialRating: entry!.getRating(),
                          itemBuilder: (context, _) =>
                              const Icon(Icons.favorite),
                          onRatingUpdate: (newRating) => {rating = newRating}),
                    ),
                    SizedBox(
                      height: 60,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.parse(
                            '${entry!.getDay().toString().substring(0, 4)}-${entry!.getDay().toString().substring(4, 6)}-${entry!.getDay().toString().substring(6, 8)}'),
                        minimumDate: DateTime.parse("2000-01-01"),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (value) {
                          date =
                              int.parse(DateFormat('yyyyMMdd').format(value));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      width: 600,
                      child: ListView.builder(
                          itemCount: savPhoto?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int) {
                            if (savPhoto!.isEmpty) {
                              return const Image(
                                  image: AssetImage('lib/assets/default.jpg'));
                            }
                            return SizedBox(
                              height: 100,
                              width: 150,
                              child: Stack(
                                children: [
                                  savPhoto![int],
                                  Center(
                                      child: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      String path = photoURls.elementAt(int);
                                      photoURls.removeAt(int);
                                      return deleteImage(path, photoURls);
                                    },
                                  ))
                                ],
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 150,
                      width: 100,
                      child: FormBuilderImagePicker(
                        name: 'photo',
                        maxImages: 5,
                        imageQuality: 20,
                        previewAutoSizeWidth: true,
                        decoration:
                            const InputDecoration(labelText: 'Pick Photo'),
                        onSaved: (value) {
                          if (value!.isEmpty) {
                            photo = null;
                          } else {
                            photo =
                                value.map((e) => e.path.toString()).toList();
                          }
                        },
                        onReset: () {
                          photo = null;
                        },
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
                      child: ElevatedButton(
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              if (photo == null || photo!.isEmpty) {
                                photo = photoURls;
                              } else {
                                photo?.addAll(photoURls);
                              }
                              if (photo!.length > 3) {
                                photo = photo!.sublist(0, 3);
                              }
                              ;
                              await cont.updateLog(
                                  text.text, date, rating, photo);

                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          const LogPage()));
                            }
                          },
                          child: const Text('Submit')),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
