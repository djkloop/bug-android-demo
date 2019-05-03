import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/pages/home_page/home_page.dart';
import 'package:one_app/pages/personal/personal_page.dart';
import 'package:one_app/pages/search_page/search_page.dart';
import 'package:one_app/pages/travel_page/travel_page.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';


class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  // 页面列表
  List<Widget> _pages = [
    HomePage(),
    SearchPage(hideLeft: true,placeholder: "选择你喜欢的东西吧",),
    TravelPage(),
    PersonalPage(),
  ];

  final _defaultColor = CupertinoColors.black;
  final _activeColor = CupertinoColors.activeBlue;
  int _currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIdx,
        onTap: _tabBarChange,
        items:  [
          _renderNavigationBar(Ionicons.ios_home, _defaultColor, Ionicons.ios_home, _activeColor, '首页'),
          _renderNavigationBar(Ionicons.ios_search, _defaultColor, Ionicons.ios_search, _activeColor, '搜索'),
          _renderNavigationBar(Ionicons.ios_car, _defaultColor, Ionicons.ios_car, _activeColor, '汽车'),
          _renderNavigationBar(Feather.user, _defaultColor, Feather.user, _activeColor, '个人'),
        ],
      ),
      tabBuilder: (context, i) {
        return CupertinoTabView(
          builder: (context) {
            return _pages[i];
          },
        );
      },
    );
  }

  BottomNavigationBarItem _renderNavigationBar(icon, Color defaultColor, activeIcon, Color activeColor, String title) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: defaultColor,
      ),
      activeIcon: Icon(
        activeIcon,
        color: activeColor,
      ),
      title: Text(title),
    );
  }

  void _tabBarChange(int value) {
    // 如果在当前页则什么都不做(后期可以做成下拉刷新)
    if(value == _currentIdx) return;
  }
}
