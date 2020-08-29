import 'dart:io';
import 'dart:ui';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter/material.dart';


class ListImages extends StatelessWidget {
  var image;
  List<Widget>  elemento = new List<Widget>();
  var Graphic = '''
                              {
                                xAxis: {
                                  type: 'category',
                                  data: ['2010-01-01', '2020-01-06', '2020-01-07', '2020-01-08', '2020-01-09', '2020-01-10', '2020-01-11']
                                },
                                yAxis: {
                                  type: 'value'
                                },
                                series: [{
                                  data: [32, 28, 27, 27, 28, 28, 27],
                                  type: 'line'
                                }]
                              }
                            ''';
  ListImages(this.image);

  @override
  Widget build(BuildContext context) {

    print("------Generando Grafica-------");
    print(image);

      final elemento = Container(
        key: UniqueKey(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Echarts(
          option: image,
          captureAllGestures: true,
        ),
        width: 300,
        height: 250,
      );
    print('------------FIN-------------');
    return elemento;
  }
}
