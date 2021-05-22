import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'parameters.dart';

class Check3DSWebView extends StatefulWidget {
  final String title = "Verify 3DS Authentication";
  final String html;

  Check3DSWebView({required this.html});

  @override
  State<StatefulWidget> createState() => _Check3DSWebView();
}

class _Check3DSWebView extends State<Check3DSWebView> {
  Map? parsedACSResult;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context).pop(this.parsedACSResult);
          },
        ),
        title: new Text(
          this.widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: WebView(
        onPageFinished: (url) {
          this._handleUriChange(url);
        },
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        initialUrl: Uri.dataFromString(this.widget.html, mimeType: 'text/html')
            .toString(),
        navigationDelegate: (navigation) => _handleUriChange(navigation.url),
      ),
    );
  }

  NavigationDecision _handleUriChange(String url) {
    print("URL :" + url);
    final Uri uri = Uri.parse(url);
    if (uri.isScheme(GatewayResponse.REDIRECT_SCHEMA) &&
        uri.host == GatewayResponse.REDIRECT_HOST) {
      final params = uri.queryParameters;
      params.forEach((key, value) {
        if (key == GatewayResponse.ACS_RESULT) {
          this.parsedACSResult = json.decode(value);
          Navigator.of(context).pop(this.parsedACSResult);
          return;
        }
      });
    }
    return NavigationDecision.navigate;
  }
}
