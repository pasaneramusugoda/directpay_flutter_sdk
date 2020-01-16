package com.paymedia.flutter_mpgs_sdk;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import  lk.directpay.flutter_mpgs.MPGS.Gateway;
import lk.directpay.flutter_mpgs.MPGS.GatewayCallback;
import lk.directpay.flutter_mpgs.MPGS.GatewayMap;
/** FlutterMpgsSdkPlugin */
public class FlutterMpgsSdkPlugin implements FlutterPlugin, MethodCallHandler {
  private Activity activity;
  private Gateway gateway;
  private String apiVersion;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_mpgs_sdk");
    channel.setMethodCallHandler(new FlutterMpgsSdkPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_mpgs_sdk");
    channel.setMethodCallHandler(new FlutterMpgsSdkPlugin());
  }
  private Gateway.Region getRegion(String region) {
    switch (region) {
      case "ap-":
        return Gateway.Region.ASIA_PACIFIC;
      case "eu-":
        return Gateway.Region.EUROPE;
      case "na-":
        return Gateway.Region.NORTH_AMERICA;
      default:
        return Gateway.Region.MTF;
    }
  }
  @Override
  public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
    if (methodCall.method.equals("init")) {
      gateway = new lk.directpay.flutter_mpgs.MPGS.Gateway();
      this.apiVersion = methodCall.argument("apiVersion");
      String gatewayId = methodCall.argument("gatewayId");
      String region = methodCall.argument("region");

      gateway.setMerchantId(gatewayId);
      gateway.setRegion(getRegion(region));

      result.success(true);
    } else if (methodCall.method.equals("updateSession")) {
      if (gateway == null) {
        result.error("Error", "Not initialized!", null);
      }

      final String sessionId = methodCall.argument("sessionId");
      final String cardHolder = methodCall.argument("cardHolder");
      final String cardNumber = methodCall.argument("cardNumber");
      final String year = methodCall.argument("year");
      final String month = methodCall.argument("month");
      final String cvv = methodCall.argument("cvv");

      Log.i("MPGS", "onMethodCall: updateSession " + this.apiVersion + ", sessionId:" + sessionId);
      GatewayMap request = new GatewayMap();

      request.set("sourceOfFunds.provided.card.nameOnCard", cardHolder);
      request.set("sourceOfFunds.provided.card.number", cardNumber);
      request.set("sourceOfFunds.provided.card.securityCode", cvv);
      request.set("sourceOfFunds.provided.card.expiry.month", month);
      request.set("sourceOfFunds.provided.card.expiry.year", year);

      gateway.updateSession(sessionId, this.apiVersion, request, new GatewayCallback() {

        @Override
        public void onSuccess(final GatewayMap response) {
          gateway = null;
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.success(true);
            }
          });
        }

        @Override
        public void onError(final Throwable throwable) {
          gateway = null;
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.error("Error while updating session!", throwable.getMessage(), null);
            }
          });
        }

      });
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
