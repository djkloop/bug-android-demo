import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/components/webview/attractions/attractions.dart';
import 'package:one_app/model/home/common_model.dart';

/// * 顶部的webview入口组件* ///
class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({Key key, @required this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
      decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            new BoxShadow(
              blurRadius: 8.0,
              color: Color.fromARGB(20, 0, 0, 0),
            ),
            new BoxShadow(
              blurRadius: 8.0,
              color: Color.fromARGB(20, 0, 0, 0),
            ),
            new BoxShadow(
              blurRadius: 8.0,
              color: Color.fromARGB(20, 0, 0, 0),
            ),
            new BoxShadow(
              blurRadius: 8.0,
              color: Color.fromARGB(20, 0, 0, 0),
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _item(BuildContext ctx, CommonModel model) {
    return GestureDetector(
      onTap: () {
        // 点击跳转webview
        // AttractWebView
        Navigator.push(
          ctx,
           CupertinoPageRoute(
             builder: (ctx) => AttractWebView(url: model.url, statusBarColor: model.statusBarColor,hideAppBar: model.hideAppBar,)
           )
        );
      },
      child: Column(
        children: <Widget>[
          Image.network(
            model.icon,
            width: 32,
            height: 32,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
