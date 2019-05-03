class SearchModel {
  final List<SearchItem> data;
  String keyword;

  SearchModel({this.data});

  factory SearchModel.formJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItem> data = dataJson.map((i) => SearchItem.formJson(i))
        .toList();
    return SearchModel(
        data: data
    );
  }

}


class SearchItem {
  final String word;
  final String type;
  final String districtname;
  final String star;
  final String price;
  final String zonename;
  final String url;

  SearchItem(
      {this.word, this.type, this.districtname, this.star, this.price, this.zonename, this.url});


  factory SearchItem.formJson(Map<String, dynamic> json) {
    return SearchItem(
      word: json['word'],
      type: json['type'],
      districtname: json['districtname'],
      star: json['star'],
      price: json['price'],
      zonename: json['zonename'],
      url: json['url'],
    );
  }

}