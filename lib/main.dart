import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      onGenerateRoute: (settings) {
        debugPrint("# setting name: ${settings.name}");
        String url;
        String title;
        if (settings.name == "/") {
          url = "http://news.163.com/20/0311/09/F7E6SBON00019B3E.html";
          title = "title here";
        } else {
          var jsonObj = json.decode(settings.name);
          url = jsonObj["url"];
          title = jsonObj["title"];
        }
        debugPrint("# url: $url");
        debugPrint("# title: $title");
        return MaterialPageRoute(builder: (context) {
          return WebviewScaffold(
            url: url,
            appBar: new AppBar(
              title: new Text(title),
            ),
          );
        });
      },
    );
  }
}
