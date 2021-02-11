import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mpgs_sdk/controllers/api_controller.dart';
import 'package:flutter_mpgs_sdk/controllers/check_3ds_webview.dart';
import 'package:flutter_mpgs_sdk/controllers/parameters.dart';
import 'package:flutter_mpgs_sdk/credit_card_input_form/constants/constanst.dart';
import 'package:flutter_mpgs_sdk/styles/card_styles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'component/custom_round_button.dart';
import 'credit_card_input_form/credit_card_input_form.dart';
import 'credit_card_input_form/model/card_info.dart';
import 'flutter_mpgs.dart';
import 'support.dart';


class CardAddForm extends StatefulWidget {

  final directPayOnCloseHandler onCloseCardForm; // Triggers when card form is closed
  final directPayOnErrorHandler onErrorCardForm; // Triggers when card form has errors
  final directPayOnCompleteHandler
      onTransactionCompleteResponse; // Triggers when transaction reaches end of cycle
  final CardAction action;
  final CardData payment;
  CardAddForm(
      {this.onCloseCardForm,
      this.onTransactionCompleteResponse,
      this.onErrorCardForm,this.payment,this.action});


  createState() => _CardAddForm();
}

class _CardAddForm extends State<CardAddForm> {
  CardInfo _cardInfo;
  String _session, _reference;
  bool _processing = false;

  ScreenState _screenState = ScreenState.ADD_CARD_WIDGET;
  String _errorMessage, _errorTitle, _otpText = "";


  void close() {
    widget.onCloseCardForm();
  }

  // final _otpFormKey = GlobalKey<FormState>();



  final Map<String, String> customCaptions = {
    'PREV': 'Prev',
    'NEXT': 'Next',
    'DONE': 'Done',
    'CARD_NUMBER': 'Card Number',
    'CARDHOLDER_NAME': 'Cardholder Name',
    'VALID_THRU': 'Valid Thru',
    'SECURITY_CODE_CVC': 'Security Code (CVC)',
    'NAME_SURNAME': 'Name Surname',
    'MM_YY': 'MM/YY',
    'RESET': 'Retry',
  };

  @override
  void initState() {
    print("Card Form Initialized");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: IgnorePointer(
            ignoring: _processing,
            child: Container(
                color: Colors.transparent,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [_buildUI(), _poweredBy()],
                  ),
                ))),
      );

  }

  _buildUI() {
    switch (this._screenState) {
      case ScreenState.ADD_CARD_WIDGET:
        return _addUI();
      // case ScreenState.OTP_WIDGET:
      //   return _otpUI();
      case ScreenState.SUCCESS_WIDGET:
        return _successUI();
      case ScreenState.FAILED_WIDGET:
        return _failedUI();
      default:
        return _initialUI();
    }
  }

  _setScreen(ScreenState state) {
    setState(() {
      this._screenState = state;
    });
  }

  _addUI() {
    return Container(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CreditCardInputForm(
            showResetButton: true,
            onStateChange: (InputState currentState, CardInfo cardInfo) {
              print(currentState);
              print(cardInfo);
              _cardInfo = null;
              if (currentState == InputState.NUMBER) {
                setState(() {
                  _errorMessage = null;
                  _errorTitle = null;
                  _processing = false;
                });
              } else if (currentState == InputState.DONE && !_processing) {
                _cardInfo = cardInfo;
                _continue(cardInfo.name, cardInfo.cardNumber, cardInfo.validate,
                    cardInfo.cvv);
              }
            },
            customCaptions: customCaptions,
            frontCardDecoration: CustomStyles.cardDecoration,
            backCardDecoration: CustomStyles.cardDecoration,
            nextButtonDecoration: CustomStyles.buttonStyle,
            prevButtonDecoration: CustomStyles.buttonStyle,
            resetButtonDecoration: CustomStyles.buttonStyle,
            prevButtonTextStyle: CustomStyles.buttonTextStyle,
            nextButtonTextStyle: CustomStyles.buttonTextStyle,
            resetButtonTextStyle: CustomStyles.buttonTextStyle,
            processing: _processing,
            hasError: this._errorMessage != null,
          ),
          _errorContainer(),
        ]),
      ),
    );


  }

  // _otpUI() {
  //   return Form(
  //     key: _otpFormKey,
  //     child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(this.otpText),
  //           SizedBox(height: 10),
  //           TextFormField(
  //             controller: otpController,
  //             keyboardType: TextInputType.numberWithOptions(decimal: true),
  //             style: defaultTextStyle(widget.textColor),
  //             decoration: InputDecoration(hintText: "0.0"),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return "Invalid amount.";
  //               }
  //               return null;
  //             },
  //           ),
  //           _errorContainer(),
  //           SizedBox(height: 10),
  //           SizedBox(
  //               width: double.infinity,
  //               height: 50,
  //               child: RaisedButton(
  //                 color: widget.buttonColor,
  //                 onPressed: this.processing ? null : _verify,
  //                 child: this.processing
  //                     ? SizedBox(
  //                         height: 30,
  //                         width: 30,
  //                         child: CircularProgressIndicator(
  //                           backgroundColor: widget.progressIndicatorColor,
  //                         ))
  //                     : Text(
  //                         "Verify",
  //                         style: widget.buttonTextStyle,
  //                       ),
  //               )),
  //           SizedBox(height: 10),
  //           SizedBox(
  //               width: double.infinity,
  //               child: FlatButton(
  //                 color: widget.buttonColor,
  //                 onPressed: this.processing
  //                     ? null
  //                     : () {
  //                         _setScreen(ScreenState.ADD_CARD_WIDGET);
  //                       },
  //                 child: Text(
  //                   "Back",
  //                   style: TextStyle(color: widget.backButtonTextColor),
  //                 ),
  //               ))
  //         ]),
  //   );
  // }

  _verify() async {
    // _setErrorMessage(null);
    // FocusScope.of(context).requestFocus(new FocusNode());
    // if (!_otpFormKey.currentState.validate()) {
    //   return;
    // }
    // final completed = await this._verifyCard(reference, otpController.text);
    // if (completed) {
    //   this._triggerPostAction(null);
    // }
  }

  _poweredBy() {
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          this._errorMessage != null || this._errorTitle != null
              ? CustomRoundButton(
                  decoration: CustomStyles.buttonRedStyle,
                  textStyle: CustomStyles.buttonTextStyle,
                  onTap: this._processing
                      ? null
                      : () {
                          this.close();
                        },
                  buttonTitle: "Cancel",
                )
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 30,
                      child: Image.asset(
                        "packages/flutter_mpgs_sdk/assets/images/master.png",
                        fit: BoxFit.scaleDown,
                      )),
                  SizedBox(width: 10),
                  SizedBox(
                      height: 25,
                      child: Image.asset(
                        "packages/flutter_mpgs_sdk/assets/images/visa.png",
                        fit: BoxFit.scaleDown,
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Powered by"),
                  SizedBox(width: 5),
                  SizedBox(
                      height: 15,
                      child: Image.asset(
                        "packages/flutter_mpgs_sdk/assets/images/directpay_full.png",
                        fit: BoxFit.scaleDown,
                      )),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  _errorContainer() {
    widget.onErrorCardForm(this._errorTitle,this._errorMessage);
    return this._errorMessage != null
        ? Container(
            width: double.infinity,
            color: Colors.red[100],
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _errorTitle != null
                    ? Text(_errorTitle,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold))
                    : Container(),
                Text(_errorMessage, style: TextStyle(color: Colors.red))
              ],
            ),
          )
        : Container();
  }

  _continue(String name, String cardNumber, String date, String cvv) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    _setErrorMessage(null);
    // if (!_addFormKey.currentState.validate()) {
    //   return;
    // }
    String number = cardNumber.replaceAll(' ', '');
    String mm = date.split('/')[0];
    String yy = date.split('/')[1];

    _session = await this._getSession();
    print("session: " + _session);
    if (_session != null) {
      _setProcessing(true);
      try {
        await FlutterMpgsSdk.updateSession(
            sessionId: _session,
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

      params["merchantId"] = StaticEntry.merchantId;
      params["_sessionId"] = _session;
      params["amount"] = 5;

      await fetch(context, APIRoutes.CHECK_3DS, params, success: (data) async {
        final type = data["type"];
        print(type);
        switch (type) {
          case "OTP":
            this._reference = data["reference"];
            _setScreen(ScreenState.OTP_WIDGET);
            setState(() {
              this._otpText = data["message"];
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
    print("RESULT:");
    print(result);
    if (result.containsKey("response")) {
      final response = result["response"];
      final secure3ds = response["3DSecure"];
      final gatewayCode = secure3ds["gatewayCode"] as String;
      if (gatewayCode == GatewayResponse.AUTHENTICATION_SUCCESSFUL ||
          gatewayCode == GatewayResponse.AUTHENTICATION_ATTEMPTED) {
        if (result.containsKey("3DSecureId")) {
          final secure3dsId = result["3DSecureId"];
          this._triggerPostAction(secure3dsId);
        } else {
          this._setErrorMessage("3DS authentication process error!");
        }
      } else {
        this._setErrorMessage("3DS authentication failed!");
      }
    } else {
      print("NOT CONTAINING THE RESPONSE");
    }
  }

  _initialUI() {
    if (_processing) {
      return Column(
        children: <Widget>[
          SizedBox(
              width: double.infinity,
              height: 50,
              child: CircularProgressIndicator()),
        ],
      );
    } else {
      _setScreen(ScreenState.ADD_CARD_WIDGET);
      return Container();
    }
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
            "Successful !",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green[400], fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CustomRoundButton(
            decoration: CustomStyles.buttonStyle,
            textStyle: CustomStyles.buttonTextStyle,
            onTap: this._processing
                ? null
                : () {
                    close();
                  },
            buttonTitle: "OK",
          )
        ],
      ),
      padding: EdgeInsets.only(top: 60, bottom: 60),
    );
  }

  _failedUI() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
              height: 30,
              child: Image.asset(
                "packages/flutter_mpgs_sdk/assets/images/cancel.png",
                fit: BoxFit.scaleDown,
              )),
          SizedBox(height: 10),
          Text(
            "Unsuccessful",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.red[400], fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CustomRoundButton(
            decoration: CustomStyles.buttonStyle,
            textStyle: CustomStyles.buttonTextStyle,
            onTap: this._processing
                ? null
                : () {
                    close();
                  },
            buttonTitle: "OK",
          )
        ],
      ),
      padding: EdgeInsets.only(top: 60, bottom: 60),
    );
  }

  _triggerPostAction(secure3ds) {
    switch (widget.action) {
      case CardAction.CARD_ADD:
        this._sendAddCardRequest();
        break;
      case CardAction.ONE_TIME_PAYMENT:
        this._sendOneTimePaymentRequest(secure3ds);
        break;
    }
  }

  _sendAddCardRequest() {
    _setProcessing(true);
    final Map params = Map();

    params["session"] = _session;
    params["cardNickname"] = widget.payment.cardNickName;
    params["currency"] = widget.payment.currency.toString().split('.')[1];
    params["email"] = widget.payment.email;
    params["mobile"] = widget.payment.mobile;
    params["reference"] = widget.payment.reference;
    params["customerName"] = widget.payment.customerName;
    params["description"] = widget.payment.description;

    fetch(context, APIRoutes.ADD_CARD, params, success: (data) {
      try {
        if (data.containsKey("status")) {
          String status = data["status"];
          widget.onTransactionCompleteResponse(status, "", "");

          if (status == "SUCCESS") {
            setState(() {
              _setScreen(ScreenState.SUCCESS_WIDGET);
            });
          } else {
            setState(() {
              _setScreen(ScreenState.FAILED_WIDGET);
            });
          }
        } else {
          throw new Exception("Card Add Process Error");
        }
      } catch (e) {
        print(e);
        setState(() {
          _setScreen(ScreenState.FAILED_WIDGET);
        });
      }
    }, failed: (code, title, message) {
      _setErrorMessage(message, title: title);
    }, completed: () {
      _setProcessing(false);
    });
  }

  _sendOneTimePaymentRequest(secure3ds) {
    _setProcessing(true);
    final Map params = Map();

    params["session"] = _session;
    params["mpg3dsId"] = secure3ds;

    params["amount"] = widget.payment.amount.toString();
    params["currency"] = widget.payment.currency.toString().split('.')[1];
    params["email"] = widget.payment.email;
    params["mobile"] = widget.payment.mobile;
    params["reference"] = widget.payment.reference;
    params["customerName"] = widget.payment.customerName;
    params["description"] = widget.payment.description;

    fetch(context, APIRoutes.ONE_TIME_PAYMENT, params, success: (data) {
      try {
        if (data.containsKey("status")) {
          String status = data["status"];
          String transactionId = data.containsKey("transactionId")
              ? data["transactionId"].toString()
              : "";
          String description =
              data.containsKey("description") ? data["description"] : "";
          String dateTime =
              data.containsKey("dateTime") ? data["dateTime"] : "";
          String reference =
              data.containsKey("reference") ? data["reference"] : "";
          String amount = data.containsKey("amount") ? data["amount"] : "";
          String currency =
              data.containsKey("currency") ? data["currency"] : "";
          String card = data.containsKey("card") ? data["card"]["number"] : "";
          widget.onTransactionCompleteResponse(status, transactionId,
              description);

          if (status == "SUCCESS") {
            setState(() {
              _setScreen(ScreenState.SUCCESS_WIDGET);
            });
          } else if (status == "FAILED") {
            setState(() {
              _setScreen(ScreenState.FAILED_WIDGET);
            });
          } else {
            setState(() {
              _setScreen(ScreenState.FAILED_WIDGET);
            });
          }
        } else {
          throw new Exception("Transaction Process Error");
        }
      } catch (e) {
        print(e);
        setState(() {
          _setScreen(ScreenState.FAILED_WIDGET);
        });
      }
    }, failed: (code, title, message) {
      _setErrorMessage(message, title: title);
    }, completed: () {
      _setProcessing(false);
    });
  }

  _setProcessing(bool processing) {
    setState(() {
      this._processing = processing;
    });
  }

  _setErrorMessage(String message, {String title}) {
    setState(() {
      this._errorTitle = title;
      this._errorMessage = message;
    });
  }

  Future<String> _getSession() async {
    String session;
    _setProcessing(true);

    await fetch(context, APIRoutes.GET_SESSION, null, success: (data) {
      final apiVersion = data["apiVersion"];
      final gatewayId = data["merchant"]["gid"];

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
          this._otpText = message;
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
