import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/components/webview/attractions/attractions.dart';
import 'package:one_app/model/home/common_model.dart';

class ActivitiesNav extends StatelessWidget {
  final List<CommonModel> subNavlist;

  const ActivitiesNav({Key key, @required this.subNavlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (subNavlist == null) return null;
    List<Widget> items = [];
    subNavlist.forEach((model) {
      items.add(_item(context, model));
    });
    // 计算出每一行展示的数量
    int separate = (subNavlist.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate, subNavlist.length),
          ),
        ),
      ],
    );
  }

  Widget _item(BuildContext ctx, CommonModel model) {
    return Expanded(
      flex: 1,
      child: _wrapGesture(
        ctx,
        Column(
          children: <Widget>[
            Image.network(
              model.icon,
              width: 18,
              height: 18,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                model.title,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        model,
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => AttractWebView(
                  url: model.url,
                  title: model.title,
                  statusBarColor: model.statusBarColor,
                  hideAppBar: model.hideAppBar,
                ),
          ),
        );
      },
      child: widget,
    );
  }
}
