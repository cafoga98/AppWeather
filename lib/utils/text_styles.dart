import 'package:flutter/material.dart';

 TextStyle defaultStyle({double fontSize, Color color, FontWeight fontWeight}){
   return TextStyle(
     fontWeight: fontWeight != null ? fontWeight : FontWeight.w700,
     color: color != null ? color : Colors.white,
     fontSize: fontSize != null ? fontSize : 14
   );
 }



