import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const platform = const MethodChannel('news.fondue.flutter/detail');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WebviewScaffold _webviewScaffold = WebviewScaffold(
      url: "about:blank",
      appBar: new AppBar(
        title: Text("Loading"),
      ),
    );

    FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      debugPrint("# state changed to ${state.type}");
      if (state.type == WebViewState.startLoad) {
        debugPrint("# start loading ${state.url}");
        if (state.url == "about:blank") {
          debugPrint("# Update detail");
          updateNewsDetail(flutterWebviewPlugin);
        }
      }
    });

    return MaterialApp(
      title: 'Flutter Module',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {"/": (_) => _webviewScaffold},
    );
  }

  Future<void> updateNewsDetail(
      FlutterWebviewPlugin flutterWebviewPlugin) async {
    try {
      final String result = await platform.invokeMethod('getDetail');
      Map<String, dynamic> detail = jsonDecode(result);
      debugPrint("# url: ${detail["url"]}");
      debugPrint("# url: ${detail["title"]}");
      flutterWebviewPlugin.reloadUrl(detail['url']);
    } on PlatformException catch (e) {
      debugPrint("# Failed to get detail: '${e.message}'.");
    }
  }
}
