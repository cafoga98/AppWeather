import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(new Duration(seconds: 4), () {
      debugPrint("Print after 4 seconds");
      Navigator.pushNamed(context, '/menu');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/img/gifpiloto.gif"), fit: BoxFit.cover)
            ),
            child: Center(
                child: Container(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 1.0,
                      direction: Axis.horizontal,
                      children: <Widget>[

                        Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width/1,
                              height: 120,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage("assets/img/piloto.png"))
                              ),
                            ),
                        ),

                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: CircularPercentIndicator(
                              radius: 50.0,
                              animation: true,
                              animationDuration: 3310,
                              lineWidth: 4.0,
                              percent: 1,
                              center: new Text(
                                "",
                                style:
                                new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: Colors.white,
                              progressColor: Colors.red,
                            ),
                          )
                        ),
                      ],
                    )
                )
            )
        )

    );
  }
}

