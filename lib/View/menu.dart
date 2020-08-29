import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:time/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'dart:math';
import 'package:unipilotoconmutacion/Model/data_weather.dart';
import 'package:unipilotoconmutacion/Services/service_unipiloto.dart';
import 'package:unipilotoconmutacion/View/mas_detalles.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  final api = new ServiceUniPiloto();

  //VARIABLES
  int temperaturaPrincipal = 0;
  double SizeTitle = 15;
  double SizeSubTitle = 14;
  double SizeNumberIndicator = 23;
  final DateTime now = DateTime.now();
  var formatDateAll = new DateFormat('yyyy-MM-dd');

  //HOY
  double radiacionHoy = 0;
  double temperaturaHoy = 0;
  double humedadHoy = 0;
  //AYER
  double radiacionAyer = 0;
  double temperaturaAyer = 0;
  double humedadAyer = 0;
  //LUNES
  double radiacionOtro = 0;
  double temperaturaOtro = 0;
  double humedadOtro = 0;

  String DateToday;
  String DateYesterday;
  String DateBeforeYesterday;

  @override
  void initState() {
    super.initState();
    ClimatologicalGeneratorHoy();
    //ClimatologicalGeneratorAyer();
    //ClimatologicalGeneratorOtro();
    Timer.periodic(new Duration(minutes: 1), (timer) {
      ClimatologicalGeneratorHoy();
    });
  }

  ClimatologicalGeneratorOtro() async {
    final DateTime now = DateTime.now() - Duration(days: 2);
    var formatDate = new DateFormat('yyyy-MM-dd');
    DateTime DayBefore = now - Duration(days: 1);
    String SendDayYestarday = formatDate.format(DayBefore);
    var radi = 0;
    var temp = 0;
    var hum = 0;
    var cant = 0;

    Future<List<DataWeather>> future = api.getWeather(FechaInit: SendDayYestarday, HoraInit: '00:00:00', FechaEnd: SendDayYestarday, HoraEnd: "23:59:59");  // Result of foo() as a future.
    future.then((List<DataWeather> value){
      cant = value.length;
      print("CANTIDAD DE LA LISTA DEL SERVICIO: $cant");
      value.forEach((val){
        print('''
        -----------------------------------------
        -> Radiacion: ${val.Radiacion},
        |
        -> Temperatura: ${val.Temperatura},
        |
        -> Humedad: ${val.Humedad}
        ''');
        radi = radi + double.parse(val.Radiacion).round();
        temp = temp + int.parse(val.Temperatura);
        hum = hum + int.parse(val.Humedad);
      });

      print('''
        --------------------- RESULTADO FINAL -----------------------
        -> Radiacion: ${radi},
        |
        -> Temperatura: ${temp},
        |
        -> Humedad: ${hum}
        ''');

      setState(() {
        radiacionOtro = radi/cant;
        temperaturaOtro = temp/cant;
        humedadOtro = hum/cant;
      });
    }).catchError((e) => 499);
  }

  ClimatologicalGeneratorAyer() async {
    final DateTime now = DateTime.now() - Duration(hours: 2);
    var formatDate = new DateFormat('yyyy-MM-dd');
    DateTime DayBefore = now - Duration(days: 1);
    String SendDayYestarday = formatDate.format(DayBefore);
    var radi = 0;
    var temp = 0;
    var hum = 0;
    var cant = 0;

    Future<List<DataWeather>> future = api.getWeather(FechaInit: SendDayYestarday, HoraInit: '00:00:00', FechaEnd: SendDayYestarday, HoraEnd: "23:59:59");  // Result of foo() as a future.
    future.then((List<DataWeather> value){
      cant = value.length;
      print("CANTIDAD DE LA LISTA DEL SERVICIO: $cant");
      value.forEach((val){
        print('''
        -----------------------------------------
        -> Radiacion: ${val.Radiacion},
        |
        -> Temperatura: ${val.Temperatura},
        |
        -> Humedad: ${val.Humedad}
        ''');
        radi = radi + double.parse(val.Radiacion).round();
        temp = temp + int.parse(val.Temperatura);
        hum = hum + int.parse(val.Humedad);
      });

      print('''
        --------------------- RESULTADO FINAL -----------------------
        -> Radiacion: ${radi},
        |
        -> Temperatura: ${temp},
        |
        -> Humedad: ${hum}
        ''');

      setState(() {
        radiacionAyer = radi/cant;
        temperaturaAyer = temp/cant;
        humedadAyer = hum/cant;
      });
    }).catchError((e) => 499);
  }

  ClimatologicalGeneratorHoy() async {
    final DateTime now = DateTime.now() - Duration(hours: 2);
    var formatDate = new DateFormat('yyyy-MM-dd');
    var formatHour = new DateFormat('HH:mm:ss');
    String HourEnd = formatHour.format(now);
    String HourInit = formatHour.format(now-Duration(minutes: 1));
    String SendDayToday= formatDate.format(now);
    DateToday = SendDayToday;
    var radi = 0;
    var temp = 0;
    var hum = 0;
    var cant = 0;
    Future<List<DataWeather>> future = api.getWeather(FechaInit: SendDayToday, HoraInit: HourInit, FechaEnd: SendDayToday, HoraEnd: HourEnd);  // Result of foo() as a future.
    future.then((List<DataWeather> value){
      cant = value.length;
      print("CANTIDAD DE LA LISTA DEL SERVICIO: $cant");

      value.forEach((val){
        print('''
        -----------------------------------------
        -> Radiacion: ${val.Radiacion},
        |
        -> Temperatura: ${val.Temperatura},
        |
        -> Humedad: ${val.Humedad}
        ''');
        radi = radi + double.parse(val.Radiacion).round();
        temp = temp + int.parse(val.Temperatura);
        hum = hum + int.parse(val.Humedad);
      });

      print('''
        --------------------- RESULTADO FINAL -----------------------
        -> Radiacion: ${radi},
        |
        -> Temperatura: ${temp},
        |
        -> Humedad: ${hum}
        ''');

      setState(() {
        radiacionHoy = radi/cant;
        temperaturaHoy = temp/cant;
        humedadHoy = hum/cant;
        temperaturaPrincipal = (temp/cant).round();
      });
    }).catchError((e) => 499);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/img/nubesgif.gif"), fit: BoxFit.cover)
        ),
        child: Column(
          children: <Widget>[
            Flexible(
                flex:2,
                child: Container(
                  child: Center(
                    child: Wrap(
                      runSpacing: 4.0,
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Center(
                          child: Text(' ${temperaturaPrincipal.toString()}˚', style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 110,
                              shadows: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 13,
                                    spreadRadius: 20
                                )
                              ],
                              color: Colors.white
                          ),),
                        ),

                        Center(
                          child: Text('Girardot - Cundinamarca', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 13,
                                  spreadRadius: 20
                              )
                            ],
                          ),),
                        )
                      ],
                    ),
                  ),
                )),

            Flexible(
                flex:2,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            runSpacing: 8,
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  height: MediaQuery.of(context).size.height/18,
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.all(Radius.circular(13))
                                  ),
                                  child: Center(
                                    child: Text('Mas Detalles', style: GoogleFonts.cinzel(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),),
                                  ),
                                ),
                                onTap: (){
                                  Toast.show("Bienvenido", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                  Navigator.pushNamed(context, "/detalles");
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => MasDetalles()),);
                                },
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/7,
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.all(Radius.circular(13))
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text('Hóy  ${DateToday}',
                                                  style: GoogleFonts.cinzel(
                                                      textStyle: Theme.of(context).textTheme.display1,
                                                      color: Colors.white,
                                                      fontSize: SizeTitle,
                                                      fontWeight: FontWeight.w700,
                                                      textBaseline: TextBaseline.alphabetic
                                                  ),)
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 15
                                              ),
                                              child: Center(
                                                child: Wrap(
                                                  runSpacing: 10,
                                                  alignment: WrapAlignment.center,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  direction: Axis.horizontal,
                                                  runAlignment: WrapAlignment.center,
                                                  children: <Widget>[

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                              fit:BoxFit.fitWidth,
                                                              child: Text((radiacionHoy.toInt()).toString(),
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  fontSize: SizeNumberIndicator,
                                                                  textBaseline: TextBaseline.alphabetic,
                                                                ),)
                                                          ),

                                                          FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Text('Radiación',
                                                                style: GoogleFonts.cinzel(
                                                                    fontWeight: FontWeight.w800,
                                                                    color: Colors.white,
                                                                    decoration: TextDecoration.overline
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      width: MediaQuery.of(context).size.width/20,
                                                    ),

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text((temperaturaHoy.toInt()).toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w800,
                                                                color: Colors.white,
                                                                fontSize: SizeNumberIndicator,
                                                                textBaseline: TextBaseline.alphabetic,
                                                              ),),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Text('Temperatura',
                                                              style: GoogleFonts.cinzel(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.overline
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      width: MediaQuery.of(context).size.width/20,
                                                    ),

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text((humedadHoy.toInt()).toString(), style: TextStyle(
                                                              fontWeight: FontWeight.w800,
                                                              color: Colors.white,
                                                              fontSize: SizeNumberIndicator,
                                                              textBaseline: TextBaseline.alphabetic,
                                                            ),),
                                                          ),

                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text('Humedad',
                                                              style: GoogleFonts.cinzel(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.overline
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                  )
                              ),

                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/7,
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.all(Radius.circular(13))
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text('Ayer  ${formatDateAll.format(DateTime.parse(DateToday) - Duration(days: 1))}',
                                                  style: GoogleFonts.cinzel(
                                                      textStyle: Theme.of(context).textTheme.display1,
                                                      color: Colors.white,
                                                      fontSize: SizeTitle,
                                                      fontWeight: FontWeight.w700,
                                                      textBaseline: TextBaseline.alphabetic
                                                  ),)
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 15
                                              ),
                                              child: Center(
                                                child: Wrap(
                                                  runSpacing: 10,
                                                  alignment: WrapAlignment.center,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  direction: Axis.horizontal,
                                                  runAlignment: WrapAlignment.center,
                                                  children: <Widget>[

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                              fit:BoxFit.fitWidth,
                                                              child: Text((radiacionAyer.toInt()).toString(),
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  fontSize: SizeNumberIndicator,
                                                                  textBaseline: TextBaseline.alphabetic,
                                                                ),)
                                                          ),

                                                          FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Text('Radiación',
                                                                style: GoogleFonts.cinzel(
                                                                    fontWeight: FontWeight.w800,
                                                                    color: Colors.white,
                                                                    decoration: TextDecoration.overline
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      width: MediaQuery.of(context).size.width/20,
                                                    ),

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text((temperaturaAyer.toInt()).toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w800,
                                                                color: Colors.white,
                                                                fontSize: SizeNumberIndicator,
                                                                textBaseline: TextBaseline.alphabetic,
                                                              ),),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Text('Temperatura',
                                                              style: GoogleFonts.cinzel(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.overline
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      width: MediaQuery.of(context).size.width/20,
                                                    ),

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text((humedadAyer.toInt()).toString(), style: TextStyle(
                                                              fontWeight: FontWeight.w800,
                                                              color: Colors.white,
                                                              fontSize: SizeNumberIndicator,
                                                              textBaseline: TextBaseline.alphabetic,
                                                            ),),
                                                          ),

                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text('Humedad',
                                                              style: GoogleFonts.cinzel(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.overline
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                  )
                              ),Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height/7,
                                  decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.all(Radius.circular(13))
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text('Antier  ${formatDateAll.format(DateTime.parse(DateToday) - Duration(days: 2))}',
                                                  style: GoogleFonts.cinzel(
                                                      textStyle: Theme.of(context).textTheme.display1,
                                                      color: Colors.white,
                                                      fontSize: SizeTitle,
                                                      fontWeight: FontWeight.w700,
                                                      textBaseline: TextBaseline.alphabetic
                                                  ),)
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 15
                                              ),
                                              child: Center(
                                                child: Wrap(
                                                  runSpacing: 10,
                                                  alignment: WrapAlignment.center,
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  direction: Axis.horizontal,
                                                  runAlignment: WrapAlignment.center,
                                                  children: <Widget>[

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                              fit:BoxFit.fitWidth,
                                                              child: Text((radiacionOtro.toInt()).toString(),
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  fontSize: SizeNumberIndicator,
                                                                  textBaseline: TextBaseline.alphabetic,
                                                                ),)
                                                          ),

                                                          FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Text('Radiación',
                                                                style: GoogleFonts.cinzel(
                                                                    fontWeight: FontWeight.w800,
                                                                    color: Colors.white,
                                                                    decoration: TextDecoration.overline
                                                                )),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      width: MediaQuery.of(context).size.width/20,
                                                    ),

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text((temperaturaOtro.toInt()).toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w800,
                                                                color: Colors.white,
                                                                fontSize: SizeNumberIndicator,
                                                                textBaseline: TextBaseline.alphabetic,
                                                              ),),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Text('Temperatura',
                                                              style: GoogleFonts.cinzel(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.overline
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Container(
                                                      width: MediaQuery.of(context).size.width/20,
                                                    ),

                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text((humedadOtro.toInt()).toString(), style: TextStyle(
                                                              fontWeight: FontWeight.w800,
                                                              color: Colors.white,
                                                              fontSize: SizeNumberIndicator,
                                                              textBaseline: TextBaseline.alphabetic,
                                                            ),),
                                                          ),

                                                          FittedBox(
                                                            fit:BoxFit.fitWidth,
                                                            child: Text('Humedad',
                                                              style: GoogleFonts.cinzel(
                                                                  fontWeight: FontWeight.w800,
                                                                  color: Colors.white,
                                                                  decoration: TextDecoration.overline
                                                              ),),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                  )
                              ),
                            ],
                          ),
                        )
                    )
                  ],
                )
            )
          ],
        ),
      )
    );
  }
}


