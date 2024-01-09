import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dear_diary/EntryCard.dart';
import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/model.dart/entry.dart';
import 'package:dear_diary/pdfCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class exportPage extends StatefulWidget {
  List<Entry> entries;
  exportPage(this.entries);
  @override
  State<exportPage> createState() => exportState(entries);
}

class exportState extends State<exportPage> {
  final List<Entry> entries;

  exportState(this.entries);
  int initdate = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
  int finaldate = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
  @override
  Widget build(context) {
    var keys = entries.map((e) => e.getDay()).toList();
    List<ScreenshotController> listCont = [];
    if (initdate > finaldate) {
      keys.removeWhere((element) => element > initdate || element < finaldate);
    } else {
      keys.removeWhere((element) => element < initdate || element > finaldate);
    }

    return Scaffold(
      body: Container(
        height: 1000,
        width: 500,
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: 500,
                    child: ListView(
                      children: [
                        Container(
                          child: const Text('Select initial date'),
                        ),
                        SizedBox(
                          height: 100,
                          width: 400,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            itemExtent: 40,
                            initialDateTime: DateTime.now(),
                            minimumDate: DateTime.parse("2000-01-01"),
                            maximumDate: DateTime.now(),
                            onDateTimeChanged: (value) {
                              initdate = int.parse(
                                  DateFormat('yyyyMMdd').format(value));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 500,
                    child: ListView(
                      children: [
                        const Text('Select Final date'),
                        SizedBox(
                          height: 100,
                          width: 200,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            itemExtent: 40,
                            initialDateTime: DateTime.now(),
                            minimumDate: DateTime.parse("2000-01-01"),
                            maximumDate: DateTime.now(),
                            onDateTimeChanged: (value) {
                              finaldate = int.parse(
                                  DateFormat('yyyyMMdd').format(value));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: TextButton(
                    child: const Text('Submit changes'),
                    onPressed: () {
                      setState(() {});
                      return;
                    },
                  )),
                ],
              ),
            ),
            Container(
              height: 500,
              width: 500,
              child: ListView.builder(
                  itemCount: keys.length,
                  cacheExtent: 10000,
                  itemBuilder: (context, index) {
                    if (index > 0 &&
                        (int.parse(keys[index].toString().substring(1, 6)) <
                            int.parse(
                                keys[index - 1].toString().substring(1, 6)))) {
                      double averageRating = 0;
                      List<Entry> listKeys = entries
                          .where((element) =>
                              int.parse(element
                                  .getDay()
                                  .toString()
                                  .substring(1, 6)) ==
                              int.parse(keys
                                  .elementAt(index)
                                  .toString()
                                  .substring(1, 6)))
                          .toList();
                      for (var element in listKeys) {
                        averageRating += element.getRating();
                      }
                      averageRating = averageRating / listKeys.length;
                      var tempCont = new ScreenshotController();
                      listCont.add(tempCont);
                      return Column(
                        children: [
                          SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Center(
                                    child: GradientText(
                                      "  ${DateFormat('MMMM').format(DateTime(0, int.parse(keys.elementAt(index).toString().substring(4, 6))))}  ${keys.elementAt(index).toString().substring(0, 4)} ",
                                      colors: [
                                        const Color(0xFF56CCF2),
                                        const Color(0xFF2F80ED)
                                      ],
                                      style: const TextStyle(
                                        fontFamily: 'Caveat',
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 37,
                                  ),
                                  SizedBox(
                                    height: 35,
                                    width: 150,
                                    child: RatingBarIndicator(
                                      rating: averageRating,
                                      itemCount: 5,
                                      itemSize: 30,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.favorite,
                                        color:
                                            Color.fromARGB(255, 241, 80, 121),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Container(
                            height: 10,
                          ),
                          SizedBox(
                            height: 235,
                            child: pdfCard(entries[index], tempCont),
                          )
                        ],
                      );
                    } else {
                      var tempCont = new ScreenshotController();
                      listCont.add(tempCont);
                      return Container(
                        height: 235,
                        child: pdfCard(entries[index], tempCont),
                      );
                    }
                  }),
            ),
            TextButton(
                onPressed: () async {
                  await generatePDF(listCont);
                  Navigator.pop(context);
                },
                child: Text('Generate'))
          ],
        ),
      ),
    );
  }

  Future<void> generatePDF(List<ScreenshotController> listCont) async {
    List<pw.Widget> images = [];
    print(listCont.length);
    for (int i = 0; i < listCont.length; i++) {
      Uint8List? photDat = await listCont[i].capture();
      try {
        print(pw.Image(pw.MemoryImage(photDat!)));
        images.add(pw.Image(pw.MemoryImage(photDat!)));
      } catch (e) {}
      ;
    }
    ;

    images.map((e) => pw.Container(child: e));
    final pdf = pw.Document();
    print('linr84  $images');
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.ListView(children: images);
      },
    ));

    var dir = await getDownloadsDirectory();
    final file = File("${dir!.path}/${DateTime.now().toString()}.pdf");

    await file.writeAsBytes(await pdf.save());
    print(file.path);
  }
}
