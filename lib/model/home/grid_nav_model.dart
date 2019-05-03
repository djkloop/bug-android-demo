import 'package:one_app/model/home/common_model.dart';

// 首页网格卡片
class GridNavModel {
  final GridNavItemModel hotel;
  final GridNavItemModel flight;
  final GridNavItemModel travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    return json != null
        ? GridNavModel(
            hotel: GridNavItemModel.fromJson(json['hotel']),
            flight: GridNavItemModel.fromJson(json['flight']),
            travel: GridNavItemModel.fromJson(json['travel']),
          )
        : null;
  }
}

// GridNavItem
class GridNavItemModel {
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItemModel({
    this.item1,
    this.item2,
    this.item3,
    this.item4,
    this.startColor,
    this.endColor,
    this.mainItem,
  });
  factory GridNavItemModel.fromJson(Map<String, dynamic> json) {
    return GridNavItemModel(
      item1: CommonModel.fromJson(json['item1']),
      item2: CommonModel.fromJson(json['item2']),
      item3: CommonModel.fromJson(json['item3']),
      item4: CommonModel.fromJson(json['item4']),
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem: CommonModel.fromJson(json['mainItem']),
    );
  }
}
