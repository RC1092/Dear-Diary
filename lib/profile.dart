import 'package:dear_diary/authPage.dart';
import 'package:dear_diary/controller/controller.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fl_chart/fl_chart.dart';

class profile extends StatelessWidget {
  final controller cont = controller();
  FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cont.getProfile(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> dataSnp) {
          if (!dataSnp.hasData) {
            return Scaffold(
              body: Container(
                child: const Center(
                  child: Image(
                    image: AssetImage('lib/assets/loading.gif'),
                  ),
                ),
              ),
            );
          }
          Map<String, dynamic>? data = dataSnp.data;
          List<FlSpot> newSpots = [
            for (int i = 1; i < data!['averages'].length; i++)
              FlSpot(i.toDouble(), data['averages'][i])
          ];

          return Scaffold(
            body: Container(
              color: Colors.black.withOpacity(0.9),
              height: 800,
              width: 500,
              child: Column(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  SizedBox(
                    height: 100,
                    width: 500,
                    child: Row(children: [
                      const Spacer(
                        flex: 1,
                      ),
                      Container(
                        width: 150,
                        height: 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFB3E0F2),
                              Color(0xFF7FABCD),
                              Color(0xFF4E7FA4)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'First Log: ${{
                              data['First']
                            }.toString().substring(1, 5)}-${{
                              data['First']
                            }.toString().substring(5, 7)}-${{
                              data['First']
                            }.toString().substring(7, 9)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 30,
                                color: Colors.grey[800]),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Container(
                        width: 150,
                        height: 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFB3E0F2),
                              Color(0xFF7FABCD),
                              Color(0xFF4E7FA4)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Text(
                              'Latest Log: ${{
                                data['Last']
                              }.toString().substring(1, 5)}-${{
                                data['Last']
                              }.toString().substring(5, 7)}-${{
                                data['Last']
                              }.toString().substring(7, 9)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Caveat',
                                fontSize: 30,
                                color: Colors.grey[800],
                              )),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      )
                    ]),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 300,
                      width: 500,
                      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepPurple.withOpacity(0.8)),
                      child: LineChart(
                          curve: Curves.fastOutSlowIn,
                          LineChartData(
                              backgroundColor: Colors.blueGrey,
                              titlesData: const FlTitlesData(
                                  topTitles: AxisTitles(
                                      axisNameSize: 40,
                                      axisNameWidget: Text(
                                        "  Monthly average rating",
                                        style: TextStyle(
                                            fontFamily: 'Caveat', fontSize: 25),
                                      )),
                                  rightTitles:
                                      AxisTitles(axisNameWidget: Text(''))),
                              minX: 1,
                              minY: 0,
                              maxX: 12,
                              maxY: 5,
                              borderData: FlBorderData(
                                  border: const Border(
                                      top: BorderSide(
                                          color: Colors.transparent, width: 0),
                                      left: BorderSide(
                                          color: Colors.transparent, width: 0),
                                      right: BorderSide(
                                          color: Colors.transparent, width: 0),
                                      bottom: BorderSide(
                                          color: Colors.deepPurple, width: 5))),
                              gridData: const FlGridData(
                                  drawHorizontalLine: true,
                                  show: true,
                                  drawVerticalLine: false),
                              lineBarsData: [
                                LineChartBarData(
                                    spots: newSpots,
                                    isCurved: true,
                                    curveSmoothness: 0.50,
                                    preventCurveOverShooting: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorTween(
                                                begin: Colors.cyan,
                                                end: Colors.blue)
                                            .lerp(0.2)!,
                                        ColorTween(
                                                begin: Colors.cyan,
                                                end: Colors.blue)
                                            .lerp(0.2)!,
                                      ],
                                    ),
                                    barWidth: 5)
                              ])),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color.fromARGB(1, 255, 127, 80),
                    ),
                    child: Center(
                      child: TextButton(
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        onPressed: () {
                          user.signOut();
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (Context) => const authPage()));
                        },
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  )
                ],
              ),
            ),
          );
        });
  }
}
