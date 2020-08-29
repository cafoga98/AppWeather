import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unipilotoconmutacion/Model/data_weather.dart';

class ServiceUniPiloto {

  Future<List<DataWeather>> getWeather({Key key, @required FechaInit, @required HoraInit, @required FechaEnd, @required HoraEnd}) async {
    try {
      print("https://accesstoclass.com/appmoviltemporalidad/$FechaInit/$HoraInit/$FechaEnd/$HoraEnd");
      var response = await http.get(
          Uri.encodeFull("https://accesstoclass.com/appmoviltemporalidad/$FechaInit/$HoraInit/$FechaEnd/$HoraEnd"),
          headers: {HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer '});

      if(response.statusCode == 200){
        print("Todo Salio bien");
        List<dynamic> dataMap = json.decode(response.body);
        List<DataWeather> weatherList = new List<DataWeather>();

        dataMap.forEach((data){
          weatherList.add(new DataWeather.map(data));
        });

        return weatherList;
      }else{
        print("Hay un Problema en la Red");
        return null;
      }
      /*switch (response.statusCode) {
        case 200:

        case 400:
          throw new Exception(
              "Datos incorrectos. Por favor verifique su username y password");
        case 404:
          throw new Exception(
              "No se pudo conectar con el servidor. Contacte al área técnica");
        case 401:
          throw new Exception(
              "Acceso denegado para la petición");
      }*/
    } on Exception catch (e) {
      throw e;
    }
  }
}