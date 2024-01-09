import 'package:dear_diary/EntryCard.dart';
import 'package:dear_diary/animRoute.dart';
import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/editPage.dart';
import 'package:dear_diary/entrypage.dart';
import 'package:animations/animations.dart';
import 'package:dear_diary/exportPage.dart';
import 'package:dear_diary/model.dart/entry.dart';
import 'package:dear_diary/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => LogState();
}

class LogState extends State<LogPage> {
  var cont = controller();
  var font = GoogleFonts.lato().toString();
  late List<Entry> entries;

  void delete(String key) async {
    await cont.removeLog(key);
    setState(() {});
  }

  void add() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: GradientText(
              "      Logs",
              colors: [const Color(0xFFFFD700), const Color(0xFFFF6600)],
              style: GoogleFonts.montserrat(fontSize: 25),
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => profile()));
                },
                icon: const Image(
                    image: AssetImage('lib/assets/profileIcon.png'))),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => exportPage(entries)));
                },
                icon: const Icon(Icons.download)),
          ],
        ),
        body: FutureBuilder(
            future: cont.getAllEntry(),
            builder: (BuildContext context, AsyncSnapshot<List<Entry>> ent) {
              if (ent.hasError) {
                return const Center(child: Text('Error Occured'));
              }
              if (ent.connectionState == ConnectionState.waiting) {
                return const Center(child: Icon(Icons.menu_book_sharp));
              }

              entries = ent.data!;
              var keys = entries.map((e) => e.getDay()).toList();

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: ListView.builder(
                    itemCount: keys.length,
                    cacheExtent: 10000,
                    itemBuilder: (context, index) {
                      if (index > 0 &&
                          (int.parse(keys[index].toString().substring(1, 6)) <
                              int.parse(keys[index - 1]
                                  .toString()
                                  .substring(1, 6)))) {
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
                              child: EntryCard(entries[index], delete),
                            )
                          ],
                        );
                      } else {
                        return Container(
                          height: 235,
                          child: EntryCard(entries[index], delete),
                        );
                      }
                    }),
              );
            }),
        floatingActionButton: FloatingActionButton(
            heroTag: 'tag',
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    EntryPage(add),
                transitionDuration: const Duration(milliseconds: 400),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return animRoute(
                      animationValues:
                          animation.drive(Tween<double>(begin: 0.0, end: 5.0)),
                      child: child);
                },
              ));
              /* Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => EntryPage(add))); */
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 152, 187, 248),
              ),
              height: 70,
              width: 70,
              child: const Icon(Icons.add),
            )));
  }
}
