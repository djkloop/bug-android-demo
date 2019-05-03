import 'package:flutter/cupertino.dart';
import 'package:one_app/navigator/tab_navigator.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: TabNavigator(),
    );
  }
}