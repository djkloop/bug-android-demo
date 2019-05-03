import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const CATCH_URLS = [
  'https://m.ctrip.com/',
  'https://dp.ctrip.com',
  'https://m.ctrip.com/html5/',
  'https://m.ctrip.com/webapp/',
  'https://m.ctrip.com/webapp/you/',
  'https://m.ctrip.com/webapp/vacations/tour/vacations',
  'https://dp.ctrip.com/webapp/vacations/',
  'https://m.ctrip.com/html5'
 ];
/// * 顶部的webview入口页面1* ///
class AttractWebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  const AttractWebView({
    Key key,
    this.url,
    this.statusBarColor,
    this.title,
    this.hideAppBar,
    this.backForbid = false,
  }) : super(key: key);

  @override
  _AttractWebViewState createState() => _AttractWebViewState();
}

class _AttractWebViewState extends State<AttractWebView> {
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    // 防止重新打开 先关闭
    webViewReference.close();
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
        print(state.url);
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {
              webViewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  bool _isToMain(String url) {
    bool contain = false;
    for(final value in CATCH_URLS) {
      if (url?.endsWith(value)??false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    // 取消监听
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorstr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorstr == 'ffffff') {
      backButtonColor = CupertinoColors.black;
    } else {
      backButtonColor = CupertinoColors.white;
    }
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          _renderAppBar(Color(int.parse('0xff' + statusBarColorstr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: false,
              withLocalStorage: true,
              hidden: true,
              withJavascript: true,
              initialChild: Container(
                color: CupertinoColors.white,
                child: Center(
                  child: Text("Wating..."),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _renderAppBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap:() {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  CupertinoIcons.back,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(
                    color: backButtonColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
