import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_app/components/search_bar/search_bar.dart';
import 'package:one_app/components/webview/attractions/attractions.dart';
import 'package:one_app/dao/search_dao.dart';
import 'package:one_app/model/home/search/search_model.dart';
import 'package:one_app/pages/speak_page/speak_page.dart';
import 'package:one_app/utils/utils.dart';

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String placeholder;

  const SearchPage(
      {Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.placeholder})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel result;
  String keyword;

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Column(
          children: <Widget>[
            _renderAppBar(),
            Expanded(flex: 1,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int position) {
                  return _itembuild(position);
                },
                itemCount: result?.data?.length ?? 0,),)
          ],
        ),)
    );
  }


  _renderAppBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0x66000000), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              speakClick: _jumpToSpeak,
              placeholder: widget.placeholder,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        ),
      ],
    );
  }

  _onTextChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        result = null;
      });
      return;
    }
    String url = widget.searchUrl + text;

    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model.keyword == keyword) {
        setState(() {
          result = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Widget _itembuild(int position) {
    if (result == null || result.data == null) return null;
    SearchItem item = result.data[position];
    return Util.wrapTap(Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(1),
            child: Image(
              width: 26,
              height: 26,
              image: AssetImage(_typeImage(item.type)),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                width: 300,
                child: _title(item),
              ),
              Container(
                width: 300,
                margin: EdgeInsets.only(top: 5),
                child: _subTitle(item),
              ),
            ],
          ),
        ],
      ),
    ), () {
      Navigator.push(context, CupertinoPageRoute(
          builder: (context) => AttractWebView(url: item.url, title: '详情',)));
    });
  }

  _typeImage(String type) {
    if (type == null) {
      return 'images/search/type_travelgroup.png';
    }
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/search/type_$path.png';
  }

  _title(SearchItem item) {
    if (item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, result.keyword));
    spans.add(TextSpan(
        text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
        style: TextStyle(
            fontSize: 12,
            color: Colors.grey
        )),);
    return RichText(
      text: TextSpan(
          children: spans
      ),
    );
  }

  _subTitle(SearchItem item) {
    if (item == null) return null;
    return RichText(
      text: TextSpan(
          children: [
            TextSpan(
              text: item.price??'',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
            TextSpan(
              text: ' ' + (item.star??''),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ]
      ),
    );
  }

  Iterable<TextSpan> _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 14, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 14, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  void _jumpToSpeak() {
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => SpeakPage()));
  }
}