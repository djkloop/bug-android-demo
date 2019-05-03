import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:one_app/components/activities_nav/activities_nav.dart';
import 'package:one_app/components/grid_nav/grid_nav.dart';
import 'package:one_app/components/loading/loading.dart';

// import 'package:one_app/components/grid_nav/grid_nav.dart';
import 'package:one_app/components/local_nav/local_nav.dart';
import 'package:one_app/components/sales_nav/sales_nav.dart';
import 'package:one_app/components/search_bar/search_bar.dart';
import 'package:one_app/components/webview/attractions/attractions.dart';
import 'package:one_app/dao/home_dao.dart';
import 'package:one_app/model/home/common_model.dart';
import 'package:one_app/model/home/grid_nav_model.dart';
import 'package:one_app/model/home/home_model.dart';
import 'package:one_app/model/home/sales_box_model.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/taurus_header.dart';
import 'package:flutter_easyrefresh/taurus_footer.dart';
import 'package:one_app/pages/search_page/search_page.dart';
import 'package:one_app/pages/speak_page/speak_page.dart';
import 'package:one_app/utils/utils.dart';

// 最大滚动距离
const APPBAR_SCROLL_OFFSET = 100;
const search_bar_default_text = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<String> _imageUrls = [
  //   "https://dimg04.c-ctrip.com/images/zg0l13000000uf4qtAB08.png",
  //   "https://dimg04.c-ctrip.com/images/zg0p13000000tzgthE0E3.png",
  //   "https://dimg04.c-ctrip.com/images/zg0s13000000udr6jAC7F.png",
  //   "https://dimg04.c-ctrip.com/images/zg0v12000000tg0ld06E0.png",
  //   "https://dimg04.c-ctrip.com/images/zg0f13000000uf0lg23DF.png",
  // ];

  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesNavList;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }

    setState(() {
      appBarAlpha = alpha;
    });
  }

  GlobalKey<EasyRefreshState> _easyRefreshKey =
  new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
  new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
  new GlobalKey<RefreshFooterState>();

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesNavList = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Loading(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  // 判断值监听第一个child元素 && 排除非滚动元素触发事件
                  if (scrollNotification is ScrollNotification &&
                      scrollNotification.depth == 0) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: Container(
                  child: EasyRefresh(
                    key: _easyRefreshKey,
                    refreshHeader: TaurusHeader(
                      key: _headerKey,
                    ),
                    refreshFooter: TaurusFooter(
                      key: _footerKey,
                    ),
                    child: _renderListView,
                    onRefresh: _handleRefresh,
                  ),
                ),
              ),
            ),
            _renderAppBar
          ],
        ),
      ),
    );
  }

  // 渲染顶部appbar
  Widget get _renderAppBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Util.colorUtil('000000'),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: search_bar_default_text,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0.5,
              )
            ],
          ),
        ),
      ],
    );
  }


//  Opacity(
//  opacity: appBarAlpha,
//  child: Container(
//  height: 80,
//  decoration: BoxDecoration(
//  color: CupertinoColors.white,
//  ),
//  child: Center(
//  child: Padding(
//  padding: EdgeInsets.only(
//  top: 20,
//  ),
//  child: Text("首页"),
//  ),
//  ),
//  ),
//  );

  // 渲染列表
  Widget get _renderListView {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            _renderBanner,
            Positioned(
              bottom: -35,
              left: 0,
              right: 0,
              child: LocalNav(
                localNavList: localNavList,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: 45,
            left: 15,
            right: 15,
          ),
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
            ],
          ),
          child: GridNav(
            gridNavModel: gridNavModel,
          ),
        ),
        ActivitiesNav(
          subNavlist: subNavList,
        ),
        SalesNav(salesNavList: salesNavList),
      ],
    );
  }

  // 渲染轮播图
  Widget get _renderBanner {
    return Container(
      height: 180,
      child: Swiper(
        pagination: SwiperPagination(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 100, right: 20),
          builder: DotSwiperPaginationBuilder(
            activeColor: CupertinoColors.white,
            color: CupertinoColors.inactiveGray,
          ),
        ),
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, idx) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (ctx) {
                  CommonModel model = bannerList[idx];
                  return AttractWebView(
                    url: model.url,
                    title: model.title,
                    statusBarColor: model.statusBarColor,
                    hideAppBar: model.hideAppBar,
                  );
                }),
              );
            },
            child: FadeInImage.assetNetwork(
              image: bannerList[idx].icon,
              placeholder: 'images/icons/loading.gif',
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  void _jumpToSearch() {
    // 把第二个参数设置为true 让它进入最远的widget这里应该是...
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => SearchPage(placeholder: search_bar_default_text)));
  }

  void _jumpToSpeak() {
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => SpeakPage()));
  }
}
