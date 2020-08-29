class DataWeather {
  int Iddata;
  String Temperatura;
  String Humedad;
  String Sonido;
  String Radiacion;
  String Fecha;

  DataWeather(this.Iddata, this.Temperatura, this.Humedad, this.Sonido,
      this.Radiacion, this.Fecha);

  DataWeather.map(Map<String, dynamic> map){
    Iddata = map["id"];
    Temperatura = map["temp"];
    Humedad = map["hume"];
    Sonido = map["soni"];
    Radiacion = map["radi"];
    Fecha = map["fecha"];
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }

}