import 'package:flutter/cupertino.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text("旅拍页面"),
      ),
    );
  }
}