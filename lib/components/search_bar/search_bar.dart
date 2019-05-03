import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/utils/utils.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

enum SearchBarType { home, normal, homeLight }
/// * 顶部的 searchBar 组件* ///
class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String placeholder;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar({Key key,
    this.enabled = true,
    this.hideLeft,
    this.searchBarType = SearchBarType.normal,
    this.placeholder,
    this.defaultText,
    this.leftButtonClick,
    this.rightButtonClick,
    this.speakClick,
    this.inputBoxClick,
    this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // 如果有默认值则设置默认值
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          Util.wrapTap(
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Text('上海', style: TextStyle(
                    color: _homeColor(),
                    fontSize: 16,
                  ),),
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Icon(
                      Ionicons.ios_arrow_down,
                      color: _homeColor(),
                      size: 22,
                    ),
                  )

                ],
              ),
            ),
            widget.leftButtonClick,
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          Util.wrapTap(
            Container(
                padding: EdgeInsets.fromLTRB(8, 3, 5, 5),
                child: Icon(MaterialCommunityIcons.chat_processing, color: _homeColor(), size: 30,)),
            widget.rightButtonClick,
          ),
        ],
      ),
    );
  }

  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          Util.wrapTap(
            Container(
              padding: EdgeInsets.only(left: 5, bottom: 3),
              child: widget?.hideLeft ?? false
                  ? null
                  : Icon(
                Ionicons.ios_arrow_back,
                color: Colors.grey,
                size: 26,
              ),
            ),
            widget.leftButtonClick,
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          Util.wrapTap(
            Container(
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                )),
            widget.rightButtonClick,
          ),
        ],
      ),
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Util.colorUtil('EDEDED');
    }
    return Container(
      height: 30,
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
            widget.searchBarType == SearchBarType.normal ? 5 : 15),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Ionicons.ios_search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Util.colorUtil('a9a9a9')
                : Colors.blueAccent,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? CupertinoTextField(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              controller: _controller,
              onChanged: _onChanged,
              placeholder: widget.placeholder ?? '',
              placeholderStyle: TextStyle(fontSize: 14, color: CupertinoColors.darkBackgroundGray),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            )
                : Util.wrapTap(Container(
              child: Text(
                widget.defaultText,
                style: TextStyle(fontSize: 14, color: Colors.grey,),
              ),
            ), widget.inputBoxClick),
          ),
          !showClear ? Util.wrapTap(Icon(CupertinoIcons.mic, size: 22,
            color: widget.searchBarType == SearchBarType.normal
                ? CupertinoColors.activeBlue
                : CupertinoColors.activeBlue,), widget.speakClick)
              : Util.wrapTap(Icon(
            CupertinoIcons.clear_circled_solid, size: 22,
            color: CupertinoColors.inactiveGray,), () {
            setState(() {
              _controller.clear();
            });
            _onChanged('');
          }),
        ],
      ),
    );
  }

  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }

    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeColor() {
    return widget.searchBarType == SearchBarType.homeLight ? CupertinoColors
        .activeBlue : CupertinoColors.white;
  }
}
