import 'package:dear_diary/EntryCard.dart';
import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/entrypage.dart';
import 'package:dear_diary/model.dart/entry.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pdf;

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => LogState();
}

class LogState extends State<LogPage> {
  var cont = controller();

  void delete(int key) async {
    cont.removeLog(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var unsorted = cont.getkeys();
    final list = unsorted.toList()..sort();
    final keys = List.from(list.reversed);

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Logs")),
          backgroundColor: Colors.blueGrey,
        ),
        body: ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              if (index > 0 &&
                  (int.parse(keys.elementAt(index).toString().substring(1, 6)) <
                      int.parse(keys
                          .elementAt(index - 1)
                          .toString()
                          .substring(1, 6)))) {
                double averageRating = 0;
                List listKeys = keys
                    .where((element) =>
                        int.parse(element.toString().substring(1, 6)) ==
                        int.parse(
                            keys.elementAt(index).toString().substring(1, 6)))
                    .toList();
                for (var element in listKeys) {
                  averageRating += cont.getEntry(element)!.getRating();
                }
                averageRating = averageRating / listKeys.length;

                return Column(
                  children: [
                    SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Center(
                              child: Text(
                                "  ${DateFormat('MMMM').format(DateTime(0, int.parse(keys.elementAt(index).toString().substring(4, 6))))}  ${keys.elementAt(index).toString().substring(0, 4)}",
                                style: const TextStyle(
                                    fontFamily: 'Caveat', fontSize: 30),
                              ),
                            ),
                            Container(
                              width: 50,
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
                                  color: Color.fromARGB(255, 241, 80, 121),
                                ),
                              ),
                            )
                          ],
                        )),
                    Container(
                      height: 10,
                    ),
                    SizedBox(
                      height: 250,
                      child: EntryCard(
                          cont.getEntry(keys.elementAt(index)), delete),
                    )
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                  child: SizedBox(
                    height: 250,
                    child:
                        EntryCard(cont.getEntry(keys.elementAt(index)), delete),
                  ),
                );
              }
            }),
        floatingActionButton: OpenContainer(
          transitionDuration: const Duration(milliseconds: 400),
          closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(70))),
          closedBuilder: (BuildContext c, VoidCallback action) => Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 152, 187, 248),
            ),
            height: 70,
            width: 70,
            child: const Icon(Icons.add),
          ),
          openBuilder: (BuildContext c, VoidCallback action) => EntryPage(),
          tappable: true,
        ));
  }
}
