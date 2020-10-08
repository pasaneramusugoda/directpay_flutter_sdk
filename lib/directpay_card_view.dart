import 'package:flutter/material.dart';

import 'card_add_form.dart';
import 'controllers/parameters.dart';
import 'support.dart';

class DirectPayCardInput extends StatefulWidget{

  final directPayOnCloseHandler onCloseCardForm; // Triggers when card form is closed
  final directPayOnErrorHandler onErrorCardForm; // Triggers when card form has errors
  final directPayOnCompleteHandler
  onCompleteResponse; // Triggers when transaction reaches end of cycle

  DirectPayCardInput({this.onCloseCardForm,
    this.onCompleteResponse,
    this.onErrorCardForm});

  static init(String merchantId, Environment environment,
      {bool debug = false}) {
    StaticEntry.merchantId = merchantId;
    switch (environment) {
      case Environment.LIVE:
        StaticEntry.STAGE = Env.PROD;
        break;
      case Environment.SANDBOX:
        StaticEntry.STAGE = Env.DEV;
        break;
    }
    StaticEntry.IS_DEV = debug;
  }

  static var _dpCardView = _DirectPayCardState();

  static start(CardAction action, CardData payment) {
    _dpCardView.start(action, payment);
  }

  static close() {
    _dpCardView.close();
  }

  @override
  createState() => _dpCardView;

}

class _DirectPayCardState extends State<DirectPayCardInput>{

  bool _visible = false;
  CardAction _action;
  CardData _payment;

  start(CardAction action, CardData payment) {
    if(_visible){
      setState(() {
        close();
      });
    }
    setState(() {
      _action = action;
      _payment = payment;
      _visible = true;
    });
  }

  close() {
    setState(() {
      _visible = false;
      _action = null;
      _payment = null;
    });
    widget.onCloseCardForm();
  }

  @override
  Widget build(BuildContext context) {
    if(_visible){
      return CardAddForm(onCloseCardForm: close,onErrorCardForm: widget.onErrorCardForm,onTransactionCompleteResponse: widget.onCompleteResponse,payment: _payment,action: _action,);
    }else{
      return Container();
    }
  }

}


