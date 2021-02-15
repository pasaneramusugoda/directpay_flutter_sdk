import 'package:flutter/material.dart';
import 'package:flutter_mpgs_sdk/directpay_card_view.dart';
import 'package:flutter_mpgs_sdk/support.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  void onCloseCardForm() {
    // Triggered when CardAddForm is closed
    print("Closed");
  }

  void onErrorCardForm(String error,String description){
    print(error);
  }

  void onCompleteCardForm(
      String status,
      String transactionId,
      String description) {
    print("Status:" + status);
    print("Transaction ID:" + transactionId);
    print("Description:" + description);
  }


  @override
  void initState() {
    // Replace with your merchant id here
    DirectPayCardInput.init("DP00001",Environment.SANDBOX);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('DirectPay Plugin Example'),
            actions: [
              Padding(padding: EdgeInsets.all(3),
              child: DropdownButton(
                  icon: Icon(Icons.menu),
                  items: [
                    DropdownMenuItem(child: Text("Pay"),value: "pay",),
                    DropdownMenuItem(child: Text("Add"),value: "add",),
                    DropdownMenuItem(child: Text("Close"),value: "close",),
                  ], onChanged: (value){
                CardAction _cardAction; // Card Action type ONE TIME PAYMENT , CARD ADD
                CardData _cardData; // Card Data model
                switch(value){
                  case "pay":
                    _cardAction = CardAction.ONE_TIME_PAYMENT;
                    _cardData = CardData.pay(
                        amount: 11.99,
                        currency: PayCurrency.LKR,
                        reference:
                        "zxywvu123456" //Unique value for identify the card holder.
                    );
                    DirectPayCardInput.start(_cardAction,_cardData);
                    break;
                  case "add":
                    _cardAction = CardAction.CARD_ADD;
                    _cardData = CardData.add(
                        currency: PayCurrency.LKR,
                        reference:
                        "abcdef123456" //Unique value from merchant.
                    );
                    DirectPayCardInput.start(_cardAction,_cardData);
                    break;
                  case "close":
                    DirectPayCardInput.close();
                    break;
                }
              }),)
            ],
          ),
          body: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: DirectPayCardInput(
                    onCloseCardForm: onCloseCardForm,
                    onCompleteResponse: onCompleteCardForm,
                    onErrorCardForm:onErrorCardForm
                  ),
                )

                ),
    );
  }
}
