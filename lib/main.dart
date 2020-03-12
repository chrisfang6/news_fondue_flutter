import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const _platform = const MethodChannel('news.fondue.flutter/detail');

//  var _rootUrl;
//  var _currentUrl;
  var _firstValidPageLoaded = false;

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
    flutterWebviewPlugin.onStateChanged
        .listen((WebViewStateChanged state) async {
      debugPrint("# state changed to ${state.type}");
      switch (state.type) {
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          debugPrint("# start loading ${state.url}");
          break;
        case WebViewState.finishLoad:
          debugPrint("# finish load ${state.url}");
//          _currentUrl = state.url;
          if (state.url == "about:blank") {
            if (!_firstValidPageLoaded) {
              debugPrint("# Update detail");
              _updateNewsDetail(flutterWebviewPlugin);
            } else {
              try {
                await _platform.invokeMethod('goBack');
              } on PlatformException catch (e) {
                debugPrint("# Failed to go back: '${e.message}'.");
              }
            }
          } else {
//            _rootUrl = _rootUrl ?? state.url;
            _firstValidPageLoaded = true;
          }
          break;
        case WebViewState.abortLoad:
          break;
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
      routes: {
        "/": (_) => _webviewScaffold
        /**
         * Don't need to intercept back action any more.
         * The first about:blank page shadows the back action.
         */
//            WillPopScope(
//              onWillPop: () async {
//                bool canPop = _rootUrl != _currentUrl;
//                debugPrint("# can pop: $canPop");
//                debugPrint("# can pop root: $_rootUrl");
//                debugPrint("# can pop current: $_currentUrl");
//                if (canPop) {
//                  return Navigator.of(context).pop(true);
//                } else {
//                  try {
//                    return await _platform.invokeMethod('goBack');
//                  } on PlatformException catch (e) {
//                    debugPrint("# Failed to go back: '${e.message}'.");
//                    return false;
//                  }
//                }
//              },
//              child: _webviewScaffold,
//            )
      },
    );
  }

  Future<void> _updateNewsDetail(
      FlutterWebviewPlugin flutterWebviewPlugin) async {
    try {
      final String result = await _platform.invokeMethod('getDetail');
      Map<String, dynamic> detail = jsonDecode(result);
      debugPrint("# url: ${detail["url"]}");
      debugPrint("# title: ${detail["title"]}");
      flutterWebviewPlugin.reloadUrl(detail['url']);
    } on PlatformException catch (e) {
      debugPrint("# Failed to get detail: '${e.message}'.");
    }
  }
}
