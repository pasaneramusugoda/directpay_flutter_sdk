import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MinimalCardInputForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MinimalCardInputState();
  }

}

class _MinimalCardInputState extends State<MinimalCardInputForm>{

  FocusNode nicknameFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController yyController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '####-####-####-####', filter: {"#": RegExp(r'[0-9]')});
  var dateFormatter =
      new MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});
  var cvvFormatter =
      new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    // return Form(
    //   key: _addFormKey,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       TextFormField(
    //         focusNode: nicknameFocus,
    //         controller: nicknameController,
    //         decoration: InputDecoration(hintText: "Nickname"),
    //         keyboardType: TextInputType.text,
    //         style: defaultTextStyle(widget.textColor),
    //         validator: (value) {
    //           if (value.isEmpty) {
    //             return "Please enter a nickname for the card.";
    //           }
    //           return null;
    //         },
    //       ),
    //       TextFormField(
    //         controller: nameController,
    //         decoration: InputDecoration(hintText: "Cardholder Name"),
    //         keyboardType: TextInputType.text,
    //         style: defaultTextStyle(widget.textColor),
    //         validator: (value) {
    //           if (value.isEmpty) {
    //             return "Please enter cardholder name.";
    //           }
    //           return null;
    //         },
    //       ),
    //       TextFormField(
    //         controller: numberController,
    //         decoration: InputDecoration(hintText: "Card Number"),
    //         keyboardType: TextInputType.number,
    //         style: defaultTextStyle(widget.textColor),
    //         inputFormatters: [maskFormatter],
    //         validator: (value) {
    //           if (value.length < 19) {
    //             return "Please valid card number.";
    //           }
    //           return null;
    //         },
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: <Widget>[
    //           SizedBox(
    //             child: TextFormField(
    //               controller: mmController,
    //               decoration: InputDecoration(hintText: "MM"),
    //               keyboardType: TextInputType.number,
    //               style: defaultTextStyle(widget.textColor),
    //               inputFormatters: [dateFormatter],
    //               validator: (value) {
    //                 if (value.isEmpty) {
    //                   return "Invalid.";
    //                 }
    //                 return null;
    //               },
    //             ),
    //             width: 50,
    //           ),
    //           SizedBox(
    //             width: 10,
    //           ),
    //           SizedBox(
    //             child: TextFormField(
    //               controller: yyController,
    //               decoration: InputDecoration(hintText: "YY"),
    //               keyboardType: TextInputType.number,
    //               style: defaultTextStyle(widget.textColor),
    //               inputFormatters: [dateFormatter],
    //               validator: (value) {
    //                 if (value.isEmpty) {
    //                   return "Invalid.";
    //                 }
    //                 return null;
    //               },
    //             ),
    //             width: 50,
    //           ),
    //         ],
    //       ),
    //       SizedBox(
    //           width: 110,
    //           child: TextFormField(
    //             controller: cvvController,
    //             decoration: InputDecoration(hintText: "CVV"),
    //             keyboardType: TextInputType.number,
    //             style: defaultTextStyle(widget.textColor),
    //             inputFormatters: [cvvFormatter],
    //             validator: (value) {
    //               if (value.length < 3) {
    //                 return "Invalid CVV";
    //               }
    //               return null;
    //             },
    //           )),
    //       _errorContainer(),
    //       SizedBox(height: 20),
    //       SizedBox(
    //           width: double.infinity,
    //           height: 50,
    //           child: RaisedButton(
    //             color: widget.buttonColor,
    //             onPressed: this.processing ? null : null,
    //             child: this.processing
    //                 ? SizedBox(
    //                 height: 30,
    //                 width: 30,
    //                 child: CircularProgressIndicator(
    //                   backgroundColor: widget.progressIndicatorColor,
    //                 ))
    //                 : Text(
    //               "Continue",
    //               style: widget.buttonTextStyle,
    //             ),
    //           )),
    //       SizedBox(height: 20),
    //       SizedBox(
    //           width: double.infinity,
    //           height: 50,
    //           child: FlatButton(
    //             color: widget.buttonColor,
    //             onPressed: this.processing
    //                 ? null
    //                 : () {
    //               close();
    //             },
    //             child: Text(
    //               "Back",
    //               style: TextStyle(color: widget.backButtonTextColor),
    //             ),
    //           )),
    //     ],
    //   ),
    // );
  }

}