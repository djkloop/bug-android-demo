import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/components/webview/attractions/attractions.dart';
import 'package:one_app/model/home/common_model.dart';
import 'package:one_app/model/home/sales_box_model.dart';

class SalesNav extends StatelessWidget {
  final SalesBoxModel salesNavList;

  const SalesNav({Key key, @required this.salesNavList}) : super(key: key);

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
      ),
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (salesNavList == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(
        context, salesNavList.bigCard1, salesNavList.bigCard2, true, false));
    items.add(_doubleItem(context, salesNavList.smallCard1,
        salesNavList.smallCard2, false, false));
    items.add(_doubleItem(context, salesNavList.smallCard3,
        salesNavList.smallCard4, false, true));

    // 计算出每一行展示的数量
    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xfff2f2f2))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(
                salesNavList.icon,
                height: 15,
                fit: BoxFit.fill,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xffff4e63), Color(0xffff6cc9)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (ctx) => AttractWebView(
                              url: salesNavList.moreUrl,
                              title: '更多活动',
                            ),
                      ),
                    );
                  },
                  child: Text("获取更多福利 >",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0, 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1, 2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2, 3),
        ),
      ],
    );
  }

  Widget _doubleItem(BuildContext ctx, CommonModel leftCard,
      CommonModel rightCard, bool isBig, bool isLast) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _item(ctx, leftCard, isBig, true, false),
        _item(ctx, rightCard,isBig, false, true),
      ],
    );
  }

  Widget _item(BuildContext ctx, CommonModel model,bool isBig,  bool isLeft, bool isLast) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return _wrapGesture(
      ctx,
      Container(
        decoration: BoxDecoration(
          border: Border(right: isLeft ? borderSide: BorderSide.none, bottom: isLast ? BorderSide.none : borderSide)
        ),
        child: Image.network(
            model.icon,
            fit: BoxFit.fill,
            width: MediaQuery.of(ctx).size.width/2 - 16,
            height: isBig ? 128 : 80,
          ),
      ),
      model,
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
