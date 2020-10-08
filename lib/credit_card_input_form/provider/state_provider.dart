import 'package:flutter/material.dart';
import '../constants/constanst.dart';

class StateProvider with ChangeNotifier {
  var _currentState = InputState.NUMBER;

  final _states = [
    InputState.NUMBER,
    InputState.NAME,
    InputState.VALIDATE,
    InputState.CVV,
    InputState.DONE
  ];

  var currentIndex = 0;

  void moveNextState() {
    try{
      if (currentIndex < _states.length - 1) {
        currentIndex++;
        _currentState = _states[currentIndex];
        notifyListeners();
      }
    }catch(e){

    }

  }

  void moveFirstState() {
    try{
      currentIndex = 0;
      _currentState = _states[currentIndex];
      notifyListeners();
    }catch(e){

    }

  }

  void movePrevState() {
    try{
      if (currentIndex > 0) {
        currentIndex--;
        _currentState = _states[currentIndex];
        notifyListeners();
      }
    }catch(e){

    }

  }

  InputState getCurrentState() {
    return _currentState;
  }
}
