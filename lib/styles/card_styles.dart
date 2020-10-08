import 'package:flutter/material.dart';

defaultTextStyle(Color textColor){
  return TextStyle(color: textColor);
}

class CustomStyles{
  static var buttonStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(30.0),
    gradient: LinearGradient(
        colors: [
          const Color(0xFF0D47A1),
          const Color(0xFF1E88E5),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );

  static var buttonRedStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(30.0),
    gradient: LinearGradient(
        colors: [
          const Color(0xFFc0392b),
          const Color(0xFFe74c3c),
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );

  static var cardDecoration = BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black54, blurRadius: 15.0, offset: Offset(0, 8))
      ],
      gradient: LinearGradient(
          colors: [
            const Color(0xFF1E88E5),
            const Color(0xFF1976D2),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
      borderRadius: BorderRadius.all(Radius.circular(15)));

  static var buttonTextStyle =
  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
}