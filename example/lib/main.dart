import 'package:flutter/material.dart';
import 'package:flutter_mpgs_sdk/card_add_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    CardAddForm.init(
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjNiNDA2ZjhmNTlkZTdmNDExY2I4MzE2MDQwYzdkOTIzOTZhMGU5ODNhZmRjZWY4NjY5YzI1YTFmOGFiNTczYjU5MWExMDZjMDFkN2YyNDY4In0.eyJhdWQiOiIxIiwianRpIjoiM2I0MDZmOGY1OWRlN2Y0MTFjYjgzMTYwNDBjN2Q5MjM5NmEwZTk4M2FmZGNlZjg2NjljMjVhMWY4YWI1NzNiNTkxYTEwNmMwMWQ3ZjI0NjgiLCJpYXQiOjE1OTY1MjE3MzAsIm5iZiI6MTU5NjUyMTczMCwiZXhwIjoxNjI4MDU3NzMwLCJzdWIiOiIxODYiLCJzY29wZXMiOlsib3JlbF9wYXkudXNlciJdfQ.Tl-0y25xU9OIijA8SKzAkA0xCWNp3eHJpD9Ff0LpzsJ2CJaJBxQpc7ohJCJzt-Ba-3AQAFpmMP-4SezsnRo2z_xorGdsnYjnKBynHzUh9zunX_w6Em-WW_FNet9-xq5zxTIKPPx5B9sRLDx-ysfqJn_LuMNFKshvB75AzyRci1qhB1-2_G0bP20WwAk8sPgz6XxA9_x4PKaHOUrIInrCtBviofo1lcDPxD9F_GuAwyxh6sL_4EogOYvgk0u8_20YX8n0_cfJ8MCg3up1aWFLxiCggm3BmBQYfJKChWNupMH87TkezBeoDjCRgaquFZ-k1EWfQcVffeocuumhrUBGqVf3f8OAqRNCW1b_pYejmu1TBYI07obdVCbcYBCjeOwINnmuc7tZQ7GkvsPX5ewvbUpTnHR3ZBw-2UglTJEkGxE3WIe1Iyieas8FHlhBsgnOLDRQA0BnIEI5R2bN89eKvk0ZrFyEpqFZq01z4KhaQe2Utq0frHpyTsVGbKAJJofd2zi0B0W0O0_ypLPnSncoSZ4BqnAKJlZdyMzVAe4732mR_21kiQ4BoHkCKkuiyng-QNJEdFVpOH0uuLqZVLkplr2SjhVUjB5qfaR9oWfKJU6oYWKKvkQ1UxvBO02Mc-XA9SQI99fjDF5uPE4mLVCTnDaFxeJotkbxyu1tOOEvCsk");
    CardAddForm.setBlinkCardLicense(
        ios:
            "sRwAAAEbY29tLnBheW1lZGlhLmZsdXR0ZXJtcGdzc2Rrb0Zmmo/7xgX58rpEcM7aOvgjjAo1TCkn4oWt12lUNJ7exKJza8ee5uaUP9+VTl6bQ+cfLgMZdx0ftWioPOCvsQcglwzhQGn+PiVNjCuzzPxR/97eYTW4Z/EXc+kl2N4vjntxh/N0Q3lUgJXzvbMot1fzEtfMJyxMOcx2N2mTLcgdoI7v64/v4Q==",
        android: "sRwAAAAdY29tLnBheW1lZGlhLmZsdXR0ZXJfbXBnc19zZGuXTEDpVPGE+034r9lUr130/82GTtzRNquQMEOY4EsxvtNtiz+Fa27U9x6PAZ5d0iO/8XRNwKxdAQoxhzFpLD868PlWqQp/hVRXRrk/WWnAdTbTgqed1IxgmunWicSaAnlIqPIPGEmAE+FTCz5imN80Cr2Qclszd9RAdH84Uir5emVfnecGNTZ0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: CardAddForm()),
    );
  }
}
