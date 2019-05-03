import 'package:flutter/cupertino.dart';

// 加载进度条组件
class Loading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;

  const Loading(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover
        ? !isLoading ? child : _loadingView
        : Stack(
            children: <Widget>[child, isLoading ? _loadingView : null],
          );
  }

  Widget get _loadingView {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(),
          Text("正在加载...")
        ],
      ),
    );
  }
}
