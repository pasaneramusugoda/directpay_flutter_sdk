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
    CardAddForm.init("eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6Ijk2ZDY4ZjM4ZjgyNDFkMjFhZmMxZTM3NTNlZTE2MjNhMGZlNGIwNTAzYTIyYTk1NGQxYzliOWQ0MzQyZWI3YjM5OTBhODg3ZDYzMjU3MGQ5In0.eyJhdWQiOiI0IiwianRpIjoiOTZkNjhmMzhmODI0MWQyMWFmYzFlMzc1M2VlMTYyM2EwZmU0YjA1MDNhMjJhOTU0ZDFjOWI5ZDQzNDJlYjdiMzk5MGE4ODdkNjMyNTcwZDkiLCJpYXQiOjE1ODc1NjA1ODcsIm5iZiI6MTU4NzU2MDU4NywiZXhwIjoxNjE5MDk2NTg3LCJzdWIiOiIyNjYiLCJzY29wZXMiOlsib3JlbF9nby51c2VyIl19.n_zil_7OebDrI0UTC4muFe5Il7Bz23YLuRXq6zb2C-m1zc0crWnRa-ULU-R_wRKzjILAeDqbLsgi_dZED4TCvJxOtc2O4PWXDdAb8_Fk5rAz6hSCa0UETh6QeSTxhZiwgdzGeZzxkMLiO4WRtpf1RxCWoJvuk2M2bEQ3Q-yZLOHGWqv2o3dtl2M9rButqmDfwK5ea7czgzWijxwgUOJKhrFs8MZ2dmXERBEc7MzryxrB4rGcjp71oCfG4Gd1FrlLLTBi7DzDF_26DSSqZumYLzSG91Qyz5Ind8D_YuncN_hxPzv0Y0Jwmk_k5HArUMui1CKKEw2Y0hdvBDVYuhTZMNrVsLt5myMQ7FUZFIHy0RMoOGbrKWY7Wgn75rSWObKpzE42hMi7a_F4lgRHMVgFb3zvWWXOEoyM_yGpZj-tAfl9wjPFSUQOkq-0qXgc-YKPhlHLxcfAjqZF3D83U_YP8MOvKXMd3ZX2ysunIHoGodXATEP_A8VzTkjjtAPvJCGdIIyqutvaLcN4p0f-D870PPW4FT8OtUqyWNQmnLGH1v6i44rK-HEmmvgCnv_zZsa1GljWBXtU3SNqI9e8CzeRBRekd7tscfVUOdaToDPaC-0mgEmkhdsUG6axQnt7zzmZfKg0Ssew54z7iUQJlJFh5xBgRdx1Qu3NXl0jc5aNtLc");
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
