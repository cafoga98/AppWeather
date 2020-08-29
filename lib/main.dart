import 'package:flutter/material.dart';
import 'package:unipilotoconmutacion/View/splash.dart';
import 'package:unipilotoconmutacion/View/menu.dart';
import 'package:unipilotoconmutacion/View/mas_detalles.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Clima Unipiloto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings){
        var arguments = settings.arguments;
        switch  (settings.name){
          case '/':
            print('INICIALIZANDO ACTIVITY DEL SPLASH');
            return MaterialPageRoute(builder: (context) => new Splash());
          case '/menu':
            print('INICIALIZANDO ACTIVITY DEL MENU');
            return MaterialPageRoute(builder: (context) => new Menu());
          case '/detalles':
            print('INICIALIZANDO ACTIVITY DEL Mas Detalles');
            return MaterialPageRoute(builder: (context) => new MasDetalles());
            // Página de error
            return null;
          default:
          // Página de error
            return null;
        }
      },
    );
  }
}
