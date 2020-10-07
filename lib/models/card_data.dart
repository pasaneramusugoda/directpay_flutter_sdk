import 'package:flutter/cupertino.dart';

enum PayCurrency {LKR,USD}

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