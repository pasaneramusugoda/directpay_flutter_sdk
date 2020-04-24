import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mpgs_sdk/controllers/api_controller.dart';
import 'package:flutter_mpgs_sdk/controllers/check_3ds_webview.dart';
import 'package:flutter_mpgs_sdk/controllers/parameters.dart';
import 'package:flutter_mpgs_sdk/styles/card_styles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'flutter_mpgs.dart';

class CardAddForm extends StatefulWidget {
  static String accessToken;
  final Color backgroundColor, textColor, buttonColor, buttonTextColor;

  static init(String accessToken) {
    CardAddForm.accessToken = accessToken;
  }

  CardAddForm(
      {this.backgroundColor,
      this.textColor,
      this.buttonColor,
      this.buttonTextColor});
  createState() => _CardAddForm();
}

class _CardAddForm extends State<CardAddForm> {
  String session, reference;
  int state = ScreenState.ADD_CARD_WIDGET;
  String errorMessage, errorTitle, otpText = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController mmController = TextEditingController();
  TextEditingController yyController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  bool processing = false;

  var maskFormatter = new MaskTextInputFormatter(
      mask: '####-####-####-####', filter: {"#": RegExp(r'[0-9]')});
  var dateFormatter =
      new MaskTextInputFormatter(mask: '##', filter: {"#": RegExp(r'[0-9]')});
  var cvvFormatter =
      new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    nicknameController.text = "Test";
    nameController.text = "Deeptha";
    numberController.text = "5473-5001-6000-1018";
    mmController.text = "10";
    yyController.text = "22";
    cvvController.text = "123";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: widget.backgroundColor,
            padding: EdgeInsets.all(10),
            child: _buildUI()));
  }

  _buildUI() {
    switch (this.state) {
      case ScreenState.OTP_WIDGET:
        return _otpUI();
      case ScreenState.SUCCESS_WIDGET:
        return _successUI();
      default:
        return _addUI();
    }
  }

  _setScreen(int state) {
    setState(() {
      this.state = state;
    });
  }

  _otpUI() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(this.otpText),
          SizedBox(height: 10),
          TextFormField(
            controller: otpController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: defaultTextStyle(widget.textColor),
            decoration: InputDecoration(hintText: "0.0"),
          ),
          _errorContainer(),
          SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                color: widget.buttonColor,
                onPressed: this.processing ? null : _verify,
                child: this.processing
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: widget.buttonTextColor,
                        ))
                    : Text(
                        "Verify",
                        style: TextStyle(color: widget.buttonTextColor),
                      ),
              ))
        ]);
  }

  _verify() async {
    final completed = await this._verifyCard(reference, otpController.text);
    if (completed) {
      this._sendAddCardRequest();
    }
  }

//todo: remove initial values
  _addUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: nicknameController,
          decoration: InputDecoration(hintText: "Nickname"),
          keyboardType: TextInputType.text,
          style: defaultTextStyle(widget.textColor),
        ),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(hintText: "Cardholder Name"),
          keyboardType: TextInputType.text,
          style: defaultTextStyle(widget.textColor),
        ),
        TextFormField(
          controller: numberController,
          decoration: InputDecoration(hintText: "Card Number"),
          keyboardType: TextInputType.number,
          style: defaultTextStyle(widget.textColor),
          inputFormatters: [maskFormatter],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              child: TextFormField(
                controller: mmController,
                decoration: InputDecoration(hintText: "MM"),
                keyboardType: TextInputType.number,
                style: defaultTextStyle(widget.textColor),
                inputFormatters: [dateFormatter],
              ),
              width: 50,
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: TextFormField(
                controller: yyController,
                decoration: InputDecoration(hintText: "YY"),
                keyboardType: TextInputType.number,
                style: defaultTextStyle(widget.textColor),
                inputFormatters: [dateFormatter],
              ),
              width: 50,
            ),
          ],
        ),
        SizedBox(
            width: 110,
            child: TextFormField(
              controller: cvvController,
              decoration: InputDecoration(hintText: "CVV"),
              keyboardType: TextInputType.number,
              style: defaultTextStyle(widget.textColor),
              inputFormatters: [cvvFormatter],
            )),
        _errorContainer(),
        SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              color: widget.buttonColor,
              onPressed: this.processing ? null : _continue,
              child: this.processing
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: widget.buttonTextColor,
                      ))
                  : Text(
                      "Continue",
                      style: TextStyle(color: widget.buttonTextColor),
                    ),
            )),
        _poweredBy()
      ],
    );
  }

  _errorContainer() {
    return this.errorMessage != null
        ? Container(
            width: double.infinity,
            color: Colors.red[100],
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                errorTitle != null
                    ? Text(errorTitle,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold))
                    : Container(),
                Text(errorMessage, style: TextStyle(color: Colors.red))
              ],
            ),
          )
        : Container();
  }

  _continue() async {
    _setErrorMessage(null);
    String name = this.nameController.text;
    String number = this.numberController.text.replaceAll('-', '');
    String mm = this.mmController.text;
    String yy = this.yyController.text;
    String cvv = this.cvvController.text;

    session = await this._getSession();
    print("session: " + session);
    if (session != null) {
      _setProcessing(true);
      try {
        await FlutterMpgsSdk.updateSession(
            sessionId: session,
            cardNumber: number,
            cardHolder: name,
            cvv: cvv,
            month: mm,
            year: yy);
      } on PlatformException catch (e) {
        _setErrorMessage(e.message, title: "Failed");
        _setProcessing(false);
      }

      final Map params = Map();

      params["merchantId"] = "";
      params["_sessionId"] = session;
      params["amount"] = 5;

      await fetch(context, APIRoutes.CHECK_3DS, params, success: (data) async {
        final type = data["type"];
        print(type);
        switch (type) {
          case "OTP":
            this.reference = data["reference"];
            _setScreen(ScreenState.OTP_WIDGET);
            setState(() {
              this.otpText = data["message"];
            });
            break;
          default:
            final html = data["html"];
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Check3DSWebView(html: html)));

            if (result != null) {
              this._complete(result as Map);
            } else {
              this._setErrorMessage("3DS authentication failed!");
            }
            break;
        }
      }, failed: (code, title, message) {
        _setErrorMessage(message, title: title);
      }, completed: () {
        _setProcessing(false);
      });
    } else {
      _setErrorMessage("Something went wrong!", title: "Failed");
    }
  }

  _complete(Map result) {
    print(result);
    if (result.containsKey("response")) {
      final response = result["response"];
      final secure3ds = response["3DSecure"];
      final gatewayCode = secure3ds["gatewayCode"] as String;
      if (gatewayCode == GatewayResponse.AUTHENTICATION_SUCCESSFUL) {
        _sendAddCardRequest();
      } else {
        this._setErrorMessage("3DS authentication failed!");
      }
    }
  }

  _poweredBy() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              height: 20,
              child: Image.asset(
                "packages/flutter_mpgs_sdk/assets/images/master.png",
                fit: BoxFit.scaleDown,
              )),
          SizedBox(width: 10),
          SizedBox(
              height: 20,
              child: Image.asset(
                "packages/flutter_mpgs_sdk/assets/images/visa.png",
                fit: BoxFit.scaleDown,
              )),
          SizedBox(width: 10),
          Text("Powered by"),
          SizedBox(width: 5),
          SizedBox(
              height: 30,
              child: Image.asset(
                "packages/flutter_mpgs_sdk/assets/images/orelpay.png",
                fit: BoxFit.scaleDown,
              )),
        ],
      ),
    );
  }

  _successUI() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
              height: 30,
              child: Image.asset(
                "packages/flutter_mpgs_sdk/assets/images/success.png",
                fit: BoxFit.scaleDown,
              )),
          SizedBox(height: 10),
          Text(
            "Successfully Added",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green[400], fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          FlatButton(
            color: widget.buttonColor,
            onPressed: this.processing ? null : _verify,
            child: this.processing
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: widget.buttonTextColor,
                    ))
                : Text(
                    "Back",
                    style: TextStyle(color: widget.buttonTextColor),
                  ),
          )
        ],
      ),
      padding: EdgeInsets.only(top: 60, bottom: 60),
    );
  }

  _sendAddCardRequest() {
    _setProcessing(true);
    final Map params = Map();

    params["session"] = session;
    params["cardNickname"] = nicknameController.text;

    fetch(context, APIRoutes.ADD_CARD, params, success: (data) {
      setState(() {
        _setScreen(ScreenState.SUCCESS_WIDGET);
      });
    }, failed: (code, title, message) {
      _setErrorMessage(message, title: title);
    }, completed: () {
      _setProcessing(false);
    });
  }

  _setProcessing(bool processing) {
    setState(() {
      this.processing = processing;
    });
  }

  _setErrorMessage(String message, {String title}) {
    setState(() {
      this.errorTitle = title;
      this.errorMessage = message;
    });
  }

  Future<String> _getSession() async {
    String session;
    _setProcessing(true);

    await fetch(context, APIRoutes.GET_SESSION, null, success: (data) {
      final apiVersion = data["apiVersion"];
      final gatewayId = data["user"]["gid"];

      FlutterMpgsSdk.init(
          gatewayId: gatewayId,
          apiVersion: apiVersion,
          region: Parameters.REGION);

      session = data["session"]["id"].toString();
    }, failed: (code, title, message) {
      _setErrorMessage(message, title: title);
    }, completed: () {
      _setProcessing(false);
    });

    return session;
  }

  Future<bool> _verifyCard(reference, otp) async {
    bool completed = false;
    _setProcessing(true);

    Map params = Map();

    params["reference"] = reference;
    params["otp"] = otp;

    await fetch(context, APIRoutes.CARD_OTP_VERIFY, params, success: (data) {
      completed = true;
    }, failed: (code, title, message) {
      if (code == "RetryVerification") {
        setState(() {
          this.otpText = message;
        });
        return;
      } else {
        _setErrorMessage(message);
      }
    }, completed: () {
      _setProcessing(false);
    });
    return completed;
  }
}
