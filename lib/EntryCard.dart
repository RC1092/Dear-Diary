import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'model.dart/entry.dart';

class EntryCard extends StatelessWidget {
  Entry? entry;
  final Function(int key) updateFunction;
  EntryCard(this.entry, this.updateFunction);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 229, 180),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 35,
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        DateFormat.yMd().format(entry!.getDay()).toString(),
                        style: const TextStyle(
                          fontSize: 25,
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
                      width: 170,
                      child: RatingBarIndicator(
                        rating: entry!.getRating(),
                        itemCount: 5,
                        itemSize: 30,
                        itemBuilder: (context, _) => const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 241, 80, 121),
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                    ),
                    IconButton(
                        onPressed: () => updateFunction(int.parse(
                            DateFormat('yyyyMMdd').format(entry!.getDay()))),
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ),
              SizedBox(
                height: 180,
                child: Row(children: [
                  SizedBox(
                    width: 100,
                    height: 150,
                    child: entry!.getPhoto(),
                  ),
                  Container(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    width: 250,
                    height: 150,
                    padding: const EdgeInsets.all(5),
                    child: Text(entry!.getDesc(),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 87, 87, 87),
                            fontFamily: 'Satisfy',
                            fontSize: 18)),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
