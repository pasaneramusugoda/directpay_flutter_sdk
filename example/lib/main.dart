import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mpgs_sdk/card_add_form.dart';
import 'package:flutter_mpgs_sdk/models/card_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showCardInput = false;
  CardAction _cardAction;
  CardData _cardData;

  void onCloseCardForm() {
    setState(() {
      _showCardInput = false;
    });
  }

  void onTransactionComplete(
      String status,
      String transactionId,
      String description,
      String dateTime,
      String reference,
      String amount,
      String currency,
      String card) {
    print("Status:" + status);
    print("Transaction ID:" + transactionId);
    print("Description:" + description);
  }

  void onCardAddComplete(String status,String description){
    print("Status:" + status);
    print("Description:" + description);
  }

  @override
  void initState() {
    // Replace with your access Token here
    CardAddForm.init("DP00001",Environment.SANDBOX);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('DirectPay Plugin Example app'),
          ),
          body: _showCardInput
              ? Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CardAddForm(
                    onCloseCardForm: onCloseCardForm,
                    onTransactionCompleteResponse: onTransactionComplete,
                    onCardAddCompleteResponse:onCardAddComplete,
                    action: _cardAction,
                    payment: _cardData,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          child: Text("Pay"),
                          onPressed: () {
                            setState(() {
                              _cardAction = CardAction.ONE_TIME_PAYMENT;
                              _cardData = CardData.add(
                                  currency: PayCurrency.LKR,
                                  reference:
                                  "zxywvu123456" //Unique value for identify the card holder.
                              );
                              _showCardInput = true;
                            });
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                          child: Text("Add Card"),
                          onPressed: () {
                            setState(() {
                              _cardAction = CardAction.CARD_ADD;
                              _cardData = CardData.pay(
                                  amount: 10.00,
                                  currency: PayCurrency.LKR,
                                  reference:
                                  "abcdef123456" //Unique value from merchant.
                              );
                              _showCardInput = true;
                            });
                          })
                    ],
                  ),
                )),
    );
  }
}
