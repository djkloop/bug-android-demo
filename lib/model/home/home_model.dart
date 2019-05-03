import 'package:one_app/model/home/common_model.dart';
import 'package:one_app/model/home/config_model.dart';
import 'package:one_app/model/home/grid_nav_model.dart';
import 'package:one_app/model/home/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel({
    this.salesBox,
    this.subNavList,
    this.gridNav,
    this.localNavList,
    this.bannerList,
    this.config,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var localNavListJson = json['localNavList'] as List;
    var subNavListJson = json['subNavList'] as List;
    var bannerListJson = json['bannerList'] as List;

    List<CommonModel> localNavList =
        localNavListJson.map((item) => CommonModel.fromJson(item)).toList();

    List<CommonModel> bannerList =
        bannerListJson.map((item) => CommonModel.fromJson(item)).toList();

    List<CommonModel> subNavList =
        subNavListJson.map((item) => CommonModel.fromJson(item)).toList();

    return HomeModel(
      localNavList: localNavList,
      bannerList: bannerList,
      subNavList: subNavList,
      config: ConfigModel.fromJson(json['config']),
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }
}
