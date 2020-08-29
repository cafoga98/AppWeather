import 'dart:async';
import 'dart:io';
import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:time/time.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';
import 'package:unipilotoconmutacion/Model/data_weather.dart';
import 'package:unipilotoconmutacion/Services/pdf_generator.dart';
import 'package:unipilotoconmutacion/Services/persister.dart' as global;
import 'package:unipilotoconmutacion/Services/service_unipiloto.dart';
class MasDetalles extends StatefulWidget {
  @override
  _MasDetallesState createState() => _MasDetallesState();
}

class _MasDetallesState extends State<MasDetalles> {

  PDFgen creator = new PDFgen();
  bool GeerateOrNoGenerate = false;
  final api = new ServiceUniPiloto();
  var formatDate = new DateFormat('yyyy-MM-dd');
  List<List<dynamic>> ListTable = new List<List<dynamic>>();
  SwiperController swiperController = new SwiperController();
  String Title = 'Temperatura';
  static List ListDateGraphics = new List();
  static List ListNumberGraphics = new List();
  String ChartData;

  Future<String> GeneratePdfForReport({Key key, @required ListDataPDF}) async {
    print("LLEGO A GENERAR EL PDF");
    if(ListDataPDF != null){
      print("ESTA GENERANDO EL PDF...");
      Future<dynamic> future = creator.generateDocument(PdfPageFormat.a4, ListDataPDF);  // Result of foo() as a future.
      future.then((filePdf) async {
        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/reporte_climatico.pdf");
        global.DateFrom ='0000-00-00';
        await file.writeAsBytes(filePdf);
        var resulbool = await FlutterShareFile.shareImage(directory.path, "reporte_climatico.pdf");
        if(resulbool == true){
          setState(() {
            print("PDF GENERADO CORRECTAMENTE...");
            global.ProgressPDF = false;
          });
        }
        setState(() {
          global.StartOrStop = true;
          global.DateFrom = '0000-00-00';
          global.DateTo = '0000-00-00';
          ListDataPDF.clear();
        });
        return "ok";
      }).catchError((e){
        return "bad";
      });
    }else{
      print("ERROR AL GENERAR EL PDF...");
    }
  }

  Future<String> GetDataForReport() async {
    try {
      print("LLEGO A OBTENER LOS DATOS");
      int count = 0;
      int cantidadDef = 0;
      Future<List<DataWeather>> future2 = api.getWeather(FechaInit: global.DateFrom, HoraInit: "00:00:00", FechaEnd: global.DateFrom, HoraEnd: "23:59:59");  // Result of foo() as a future.
      future2.then((List<DataWeather> value) async {
        print("SE OBTUVIERON LOS DATOS CORRECTAMENTE");
        cantidadDef = value.length;
        print("CANTIDAD DE DATOS EN EL RAGO DE FECHAS: ${value.length}");
        value.forEach((val){
          count ++;
          var Radia = double.parse(val.Radiacion).round();
          var Tempe = val.Temperatura;
          var Hum = val.Humedad;

          List<String> agregar = ['$count','${val.Fecha}', '$Radia', '$Tempe', '$Hum'];
          ListTable.add(agregar);
          //print("---> Cantidad en la Lista de la Tabla: ${ListTable.length}");
        });
        print("RETORNANDO LISTA DEL FUTURE...");
        return await GeneratePdfForReport(ListDataPDF: ListTable);
        //return ListTable;
      }).catchError((e){
        return "bad";
      });
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<List> CreateList() async {

  }

  GenerateGraphic({Key key, @required String DataType}){
    print('''
    ******************************************************
    ******************************************************
    ENTRO A LA FUNCION PARA GENERAR
      |
      |
      V
                                    ''');
    final DateTime now = DateTime.now() - Duration(hours: 2);
    var formatDate = new DateFormat('yyyy-MM-dd');
    var formatHour = new DateFormat('HH:mm:ss');
    String HourEnd = '23:59:59';
    String HourInit = '00:00:00';
    List DateSend = new List();
    List NumberSend = new List();
    String SendDayToday= formatDate.format(now);
    var cant = 0;
    int cont = 0;
    Future<List<DataWeather>> future = api.getWeather(FechaInit: SendDayToday, HoraInit: HourInit, FechaEnd: SendDayToday, HoraEnd: HourEnd);  // Result of foo() as a future.
    future.then((List<DataWeather> value){
      cant = value.length;
      print("CANTIDAD DE LA LISTA DEL SERVICIO: $cant");
      switch(DataType){
        case 'Temperatura':
          print('''
    =====================================================
    GRAFICA DE TIPO: $DataType
    ======================================================
                                    ''');
          value.forEach((val){
            cont ++;
            print("CONTADOR PARA $DataType: ${cont}");
            if(cont == 720){
              print('''
        -----------------------------------------
        -> Radiacion: ${val.Radiacion},
        |
        -> Temperatura: ${val.Temperatura},
        |
        -> Humedad: ${val.Humedad}
        ''');
              var impri = ''' '${formatHour.format(DateTime.parse(val.Fecha))}' ''';
              DateSend.add(impri);
              NumberSend.add(int.parse(val.Temperatura));
              cont = 0;
              print('''
    =====================================================
    |
    -> Convertidor ($impri)
    |
    ======================================================
                                    ''');
            }
          });
          setState(() {
            ListDateGraphics = DateSend;
            ListNumberGraphics = NumberSend;
            print('''
    =====================================================
    |
    -> ListaNumberGraphic (${ListNumberGraphics.length})= ${ListNumberGraphics.toString()}
    |
    -> ListaDateGraphic (${ListDateGraphics.length}) = ${ListDateGraphics.toString()}
    |
    ======================================================
                                    ''');
            ChartData = '''
                              {
                                xAxis: {
                                  type: 'category',
                                  data: ${ListDateGraphics.toString()}
                                },
                                yAxis: {
                                  type: 'value'
                                },
                                series: [{
                                  data: ${ListNumberGraphics.toString()},
                                  type: 'line'
                                }]
                              }
                            ''';
          });
          return null;
        case 'Radiacion':
          print('''
    =====================================================
    GRAFICA DE TIPO: $DataType
    ======================================================
                                    ''');
          value.forEach((val){
            cont ++;
            print("CONTADOR PARA $DataType: ${cont}");
            if(cont == 720){
              print('''
        -----------------------------------------
        -> Radiacion: ${val.Radiacion},
        |
        -> Temperatura: ${val.Temperatura},
        |
        -> Humedad: ${val.Humedad}
        ''');
              var impri = ''' '${formatHour.format(DateTime.parse(val.Fecha))}' ''';
              DateSend.add(impri);
              NumberSend.add(double.parse(val.Radiacion).round());
              cont = 0;
              print('''
    =====================================================
    |
    -> Convertidor ($impri)
    |
    ======================================================
                                    ''');
            }
          });
          setState(() {
            ListDateGraphics = DateSend;
            ListNumberGraphics = NumberSend;
            print('''
    =====================================================
    |
    -> ListaNumberGraphic (${ListNumberGraphics.length})= ${ListNumberGraphics.toString()}
    |
    -> ListaDateGraphic (${ListDateGraphics.length}) = ${ListDateGraphics.toString()}
    |
    ======================================================
                                    ''');
            ChartData = '''
                              {
                                xAxis: {
                                  type: 'category',
                                  data: ${ListDateGraphics.toString()}
                                },
                                yAxis: {
                                  type: 'value'
                                },
                                series: [{
                                  data: ${ListNumberGraphics.toString()},
                                  type: 'line'
                                }]
                              }
                            ''';
          });
          return null;
        case 'Humedad':
          print('''
    =====================================================
    GRAFICA DE TIPO: $DataType
    ======================================================
                                    ''');
          value.forEach((val){
            cont ++;
            print("CONTADOR PARA $DataType: ${cont}");
            if(cont == 720){
              print('''
        -----------------------------------------
        -> Radiacion: ${val.Radiacion},
        |
        -> Temperatura: ${val.Temperatura},
        |
        -> Humedad: ${val.Humedad}
        ''');
              var impri = ''' '${formatHour.format(DateTime.parse(val.Fecha))}' ''';
              DateSend.add(impri);
              NumberSend.add(int.parse(val.Humedad));
              cont = 0;
              print('''
    =====================================================
    |
    -> Convertidor ($impri)
    |
    ======================================================
                                    ''');
            }
          });
          setState(() {
            ListDateGraphics = DateSend;
            ListNumberGraphics = NumberSend;
            print('''
    =====================================================
    |
    -> ListaNumberGraphic (${ListNumberGraphics.length})= ${ListNumberGraphics.toString()}
    |
    -> ListaDateGraphic (${ListDateGraphics.length}) = ${ListDateGraphics.toString()}
    |
    ======================================================
                                    ''');
            ChartData = '''
                              {
                                xAxis: {
                                  type: 'category',
                                  data: ${ListDateGraphics.toString()}
                                },
                                yAxis: {
                                  type: 'value'
                                },
                                series: [{
                                  data: ${ListNumberGraphics.toString()},
                                  type: 'line'
                                }]
                              }
                            ''';
          });
          return null;
        default:
        // Página de erro
        print('''
        --------------------------------------------------------
        NO SE PUDO GENERAR LA GRAFICA
        ________________________________________________________
        ''');
          return null;
      };
    }).catchError((e) => 499);
  }


  List<DropdownMenuItem> DropList = [DropdownMenuItem(child: Text('Diario'), value: 1,),DropdownMenuItem(child: Text('Semanal'), value: 2,),DropdownMenuItem(child: Text('Mensual'), value: 3,)];
 var valorInit;
 var valorInit2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFC50B0B),
        width: MediaQuery.of(context).size.width,
//        decoration: BoxDecoration(
//            image: DecorationImage(
//                image: AssetImage("assets/img/generadorclima.jpg"),fit: BoxFit.fill)
//        ),
        child: Container(
          margin: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              Wrap(
                runSpacing: 9,
                direction: Axis.horizontal,
                children: <Widget>[


                  Container(
                    height: MediaQuery.of(context).size.height/12,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(
                      child: Container(
                        height: 34,
                        width: MediaQuery.of(context).size.width,

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/img/pilotonegro.png")
                            )
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height/1.9,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 10,
                        ),

                        FittedBox(
                          child: Text(Title,
                              style: GoogleFonts.cinzel(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                            left: 10
                          ),
                          key: UniqueKey(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Echarts(
                            option: ChartData,
                            captureAllGestures: true,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/2.5,
                        ),

                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        Center(
                          child: Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runAlignment: WrapAlignment.spaceEvenly,
                            spacing: 10,
                            children: <Widget>[
                              ArgonButton(
                                borderRadius: 25,
                                height: 40,
                                roundLoadingShape: false,
                                minWidth: 70,
                                width: MediaQuery.of(context).size.width/4,
                                color: Color(0xFFC50B0B),
                                child: Text("Temperatura",
                                  style: GoogleFonts.cinzel(
                                    textStyle: Theme.of(context).textTheme.display1,
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                loader: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: LoadingIndicator(indicatorType: Indicator.audioEqualizer, color: Colors.white),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                                onTap: (startLoading, stopLoading, btnState) async {
                                  startLoading();
                                  setState(() {
                                    Title = 'Temperatura';
                                    GenerateGraphic(DataType: 'Temperatura');
                                  });
                                  Timer timer = new Timer(new Duration(seconds: 2), () {
                                    print("Cargando la grafica de Temperatura...");
                                    stopLoading();
                                  });
                                },
                              ),
                              ArgonButton(
                                borderRadius: 25,
                                height: 40,
                                roundLoadingShape: false,
                                minWidth: 70,
                                width: MediaQuery.of(context).size.width/4,
                                color: Color(0xFFC50B0B),
                                child: Text("Radiación",
                                  style: GoogleFonts.cinzel(
                                    textStyle: Theme.of(context).textTheme.display1,
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                loader: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: LoadingIndicator(indicatorType: Indicator.audioEqualizer, color: Colors.white),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                                onTap: (startLoading, stopLoading, btnState) async {
                                  startLoading();
                                  setState(() {
                                    Title = 'Radiación';
                                    GenerateGraphic(DataType: 'Radiacion');
                                  });
                                  Timer timer = new Timer(new Duration(seconds: 2), () {
                                    print("Cargando la grafica de Radiación...");
                                    stopLoading();
                                  });
                                },
                              ),
                              ArgonButton(
                                borderRadius: 25,
                                height: 40,
                                roundLoadingShape: false,
                                minWidth: 70,
                                width: MediaQuery.of(context).size.width/4,
                                color: Color(0xFFC50B0B),
                                child: Text("Humedad",
                                  style: GoogleFonts.cinzel(
                                    textStyle: Theme.of(context).textTheme.display1,
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                loader: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: LoadingIndicator(indicatorType: Indicator.audioEqualizer, color: Colors.white),
                                          )
                                        ],
                                      )
                                  ),
                                ),
                                onTap: (startLoading, stopLoading, btnState) async {
                                  startLoading();
                                  setState(() {
                                    Title = 'Humedad';
                                    GenerateGraphic(DataType: 'Humedad');
                                  });
                                  Timer timer = new Timer(new Duration(seconds: 2), () {
                                    print("Cargando la grafica de Humedad...");
                                    stopLoading();
                                  });
                                },
                              )
                            ],
                          )
                        )
                      ],
                    )

                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 5,
                        right: 40,
                        left: 40
                      ),
                      child: Wrap(
                        runSpacing: 2,
                        runAlignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Generar Informe',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cinzel(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Por favor selecciona una fecha para generar tu reporte diario.',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.cinzel(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),),
                          ),

                          Container(
                            height: 15,
                          ),

                          Wrap(
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[

                              InkWell(
                                onTap: (){
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 05, 22),
                                      maxTime: DateTime(2025, 12, 30),
                                      onChanged: (date) {
                                        print('change $date');
                                      },
                                      onConfirm: (date) {
                                        print('confirm $date');
                                        setState(() {
                                          global.DateFrom = (formatDate.format(date)).toString();
                                        });
                                      },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    global.DateFrom,
                                    style: GoogleFonts.cinzel(
                                      textStyle: Theme.of(context).textTheme.display1,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 5,
                          ),

                          Container(
                            height: 15,
                          ),

                          InkWell(
                            key: UniqueKey(),
                            onTap: (){
                              if(global.DateFrom != '0000-00-00'){
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ClassicGeneralDialogWidget(
                                      titleText: 'Advertencia!',
                                      positiveText: 'Continuar',
                                      negativeText: 'Cancelar',
                                      contentText:
                                      'Esto podría tardar alrededor de 10 a 30 minutos, deseas continuar?',
                                      onNegativeClick: (){
                                        Navigator.of(context).pop();
                                      },
                                      onPositiveClick: () async {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          global.ProgressPDF = true;
                                        });
                                        Future.delayed(Duration(seconds: 1), ()async{
                                          await GetDataForReport();
                                        });
                                      },
                                    );
                                  },
                                  animationType: DialogTransitionType.size,
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(seconds: 1),
                                );
                              }else{
                                Toast.show("Escoge una fecha", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Color(0xFFC50B0B),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Center(
                                  child: global.ProgressPDF != true ? Text("Generar",
                                    style: GoogleFonts.cinzel(
                                      textStyle: Theme.of(context).textTheme.display1,
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),) : Text("Cargando...",
                                    style: GoogleFonts.cinzel(
                                      textStyle: Theme.of(context).textTheme.display1,
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),)
                              ),
                            )
                          ),

                          /*ArgonButton(
                            borderRadius: 10,
                            height: 45,
                            roundLoadingShape: false,
                            minWidth: 200,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xFFC50B0B),
                            child: Text("Generar",
                              style: GoogleFonts.cinzel(
                                textStyle: Theme.of(context).textTheme.display1,
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),),
                            loader: Container(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    *//*Container(
                                    width: 20,
                                  ),*//*
                                    Text(
                                      "Cargando...",
                                      style: GoogleFonts.cinzel(
                                        textStyle: Theme.of(context).textTheme.display1,
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    LoadingIndicator(indicatorType: Indicator.ballTrianglePath, color: Colors.white),
                                    *//*Container(
                                    width: 20,
                                  ),*//*
                                  ],
                                )
                              ),
                            ),
                            onTap: (startLoading, stopLoading, btnState) async {
                              if(global.DateFrom != '0000-00-00'){
                                startLoading();
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ClassicGeneralDialogWidget(
                                      titleText: 'Advertencia!',
                                      positiveText: 'Continuar',
                                      negativeText: 'Cancelar',
                                      contentText:
                                      'Esto podría tardar alrededor de 10 a 30 minutos, deseas continuar?',
                                      onNegativeClick: (){
                                        Navigator.of(context).pop();
                                        stopLoading();
                                      },
                                      onPositiveClick: () async {
                                        Navigator.of(context).pop();
                                        await GetDataForReport();
                                      },
                                    );
                                  },
                                  animationType: DialogTransitionType.size,
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(seconds: 1),
                                );
                              }else{
                                Toast.show("Escoge una fecha", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                              }
                            },
                          ),*/
                          Container(
                            margin: EdgeInsets.all(5),
                          ),
                        ],
                      ),
                    )
                  )
                ],
              )
            ],
          )
        )
      )
    );
  }

  @override
  void initState() {
    super.initState();
    GenerateGraphic(DataType: 'Temperatura');
  }
}
