import 'package:dear_diary/controller/controller.dart';
import 'package:dear_diary/customeDec.dart';
import 'package:dear_diary/editPage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'model.dart/entry.dart';

class pdfCard extends StatelessWidget {
  final cont = controller();
  final Entry? entry;
  final ScreenshotController control ;

  pdfCard(this.entry,this.control, {super.key});

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: control,
      child: Scaffold(
        body: FutureBuilder(
            future: cont.getImage(entry!.getDay()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Icon(Icons.menu_book_sharp));
              }
              return Container(
                padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 10),
                color: Colors.black,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 229, 180),
                      borderRadius: BorderRadius.all(Radius.elliptical(20, 14))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text(
                                '${entry!.getDay().toString().substring(0, 4)}-${entry!.getDay().toString().substring(4, 6)}-${entry!.getDay().toString().substring(6, 8)}',
                                style: const TextStyle(
                                  fontSize: 23,
                                  color: Color.fromARGB(255, 87, 87, 87),
                                  fontFamily: 'Caveat',
                                ),
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            SizedBox(
                              height: 35,
                              width: 125,
                              child: RatingBarIndicator(
                                rating: entry!.getRating(),
                                itemCount: 5,
                                itemSize: 25,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.favorite,
                                  color: Color.fromARGB(255, 241, 80, 121),
                                ),
                              ),
                            ),
                            Container(
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 180,
                        child: Row(children: [
                          SizedBox(
                            width: 100,
                            height: 150,
                            child: SwipableStack(
                              builder: (context, swipeProperty) {
                                return snapshot.data![
                                    swipeProperty.index % snapshot.data!.length];
                              },
                              detectableSwipeDirections: const {
                                SwipeDirection.left,
                                SwipeDirection.right
                              },
                            ),
                          ),
                          Container(
                            width: 10,
                          ),
                          Container(
                            width: 240,
                            height: 150,
                            padding: const EdgeInsets.all(5),
                            child: CustomPaint(
                              painter: customDec(150, 240),
                              child: SingleChildScrollView(
                                child: Text(entry!.getDesc(),
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 87, 87, 87),
                                        fontFamily: 'Satisfy',
                                        fontSize: 18)),
                              ),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
