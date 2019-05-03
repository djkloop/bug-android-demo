import 'package:flutter/cupertino.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text("个人中心页面"),
      ),
    );
  }
}