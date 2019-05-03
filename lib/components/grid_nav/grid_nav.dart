import 'package:flutter/cupertino.dart';
import 'package:one_app/components/webview/attractions/attractions.dart';
import 'package:one_app/model/home/common_model.dart';
import 'package:one_app/model/home/grid_nav_model.dart';
import 'package:flutter/material.dart';

/// * 顶部的网格入口组件* ///
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _renderGridItems(context),
      ),
    );
  }

  _renderGridItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;

    if (gridNavModel.hotel != null) {
      items.add(_renderGridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_renderGridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_renderGridNavItem(context, gridNavModel.travel, false));
    }

    return items;
  }

  _renderGridNavItem(
      BuildContext context, GridNavItemModel gridNavItem, bool isFirst) {
    List<Widget> items = [];
    items.add(_renderMainItem(context, gridNavItem.mainItem));
    items.add(_renderDoubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_renderDoubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(Expanded(
        child: item,
        flex: 1,
      ));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(width: 1, color: CupertinoColors.white)),
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  _renderDoubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topItem, true),
        ),
        Expanded(
          child: _item(context, bottomItem, false),
        ),
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool isFirst) {
    BorderSide borderSide =
        BorderSide(width: 0.8, color: CupertinoColors.white);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            bottom: isFirst ? borderSide : BorderSide.none,
          ),
        ),
        child: _wrapGesture(
          context,
          Center(
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.white,
              ),
            ),
          ),
          item,
        ),
      ),
    );
  }

  _renderMainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                model.title,
                style: TextStyle(
                  fontSize: 14,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          ],
        ),
        model);
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
