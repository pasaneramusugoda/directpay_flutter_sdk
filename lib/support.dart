import 'package:flutter/material.dart';

enum PayCurrency {LKR,USD}
enum CardAction { CARD_ADD, ONE_TIME_PAYMENT }
enum Environment { LIVE, SANDBOX }

typedef directPayOnCompleteHandler = void Function(String status, String transactionId, String description);
typedef directPayOnErrorHandler = void Function(String error,String description);
typedef directPayOnCloseHandler = void Function();

class Card {

  String number;
  String cvv;
  int mm;
  int yy;
  String cardName;

  Card({this.number, this.cvv, this.mm, this.yy, this.cardName});

  @override
  String toString() {
    return this.number;
  }
}

class CardData{
  double amount;
  final PayCurrency currency;
  final String email,mobile,reference,customerName,description,cardNickName;

  CardData.pay({
    @required this.currency,
    @required this.amount,
    @required this.reference,
    this.cardNickName,
    this.email,
    this.mobile,
    this.customerName,
    this.description
  });

  CardData.add({
    @required this.currency,
    @required this.reference,
    this.cardNickName,
    this.email,
    this.mobile,
    this.customerName,
    this.description
  });


}