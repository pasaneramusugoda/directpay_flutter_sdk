import 'dart:io';

import '../flutter_mpgs.dart';



class StaticEntry{
  static String accessToken;
  static String merchantId;
  static String iosLicense, androidLicense;

  static String STAGE = Env.DEV; //DEV or PROD
  static bool IS_DEV = true; //use to enable logs
}

class Env {
  static const String DEV = "dev";
  static const String PROD = "prod";
}

class Parameters {
  static const String VERSION = "0.0.1";
  static  String REGION =
      StaticEntry.STAGE == Env.PROD ? Region.ASIA_PACIFIC : Region.MTF;
  static String BASE_URL = StaticEntry.STAGE == Env.DEV
      ? "https://dev.directpay.lk/v1/mpg/api/sdk/"
      : "https://prod.directpay.lk/v1/mpg/api/sdk/";
}

class APIRoutes {
  static  String GET_SESSION = Parameters.BASE_URL + "session";
  static  String ADD_CARD = Parameters.BASE_URL + "cardAdd";
  static  String ONE_TIME_PAYMENT = Parameters.BASE_URL + "oneTimePayment";
  static  String CHECK_3DS = Parameters.BASE_URL + "check3ds";
  static  String CARD_OTP_VERIFY = Parameters.BASE_URL + "otpVerify";
}

enum ScreenState {OTP_WIDGET,SUCCESS_WIDGET,ADD_CARD_WIDGET,FAILED_WIDGET}

//class ScreenState {
//  static const int OTP_WIDGET = 2;
//  static const int SUCCESS_WIDGET = 4;
//  static const int ADD_CARD_WIDGET = 1;
//  static const int INITIAL_WIDGET = 0;
//  static const int FAILED_WIDGET = 3;
//}

class GatewayResponse {
  static const String AUTHENTICATION_SUCCESSFUL = "AUTHENTICATION_SUCCESSFUL";
  static const String AUTHENTICATION_ATTEMPTED = "AUTHENTICATION_ATTEMPTED";
  static const String REDIRECT_SCHEMA = "https";
  static const String ACS_RESULT = "acsResult";
  static const String REDIRECT_HOST = "prod.directpay.lk";
}

getPlatform() {
  if (Platform.isIOS) {
    return "IOS";
  } else if (Platform.isAndroid) {
    return "Android";
  } else {
    return "NA";
  }
}
