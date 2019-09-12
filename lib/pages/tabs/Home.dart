import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/ScreenAdaper.dart';
import '../../config/Config.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key}): super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  List _focusData = [];
  List _hotProductList = [];
  List _bestProductList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();
  }

  //获取轮播图数据
  _getFocusData() async {
    var api = '${Config.domain}api/focus';
    var result = await Dio().get(api);
    var focusList = FocusModel.fromJson(result.data);
    setState((){
      this._focusData = focusList.result;
    });
  }

  //获取猜你喜欢的数据
  _getHotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }

  //获取热门推荐的数据
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }

  //轮播图：
  //flutter run -d all 链接多个设备的命令:
  Widget _swiperWidger() {
//    List<Map> imgList = [
//      {'url': 'https://www.itying.com/images/flutter/slide01.jpg'},
//      {'url': 'https://www.itying.com/images/flutter/slide02.jpg'},
//      {'url': 'https://www.itying.com/images/flutter/slide03.jpg'}
//    ];
    if(this._focusData.length >0){
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic = this._focusData[index].pic;
              pic = Config.domain + pic.replaceAll('\\', '/');
              return Image.network(
                pic,
                fit: BoxFit.fill,
              );
            },
            itemCount: this._focusData.length,
            pagination: SwiperPagination(),
            control: SwiperControl(),
            autoplay: true,
          ),
        ),
      );
    } else {
      return Text('加载中...');
    }


  }

  //标题
  Widget _titleWidget(value){
    return Container(
      height: ScreenAdaper.height(46),
      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.red,
            width: ScreenAdaper.width(10)
          ),
        ),
      ),
      child: Text(value, style: TextStyle(color: Colors.black54)),
    );
  }

  //热门商品
  Widget _hotProductListWidget() {
    if(this._hotProductList.length >0){
      return Container(
        height: ScreenAdaper.height(240),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        //width: double.infinity, //宽度自适应
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            String sPic = this._hotProductList[index].sPic;
            sPic = Config.domain + sPic.replaceAll('\\', '/');
            return Column(
              children: <Widget>[
                Container(
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(21)),
                  child: Image.network(sPic, fit:BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  height: ScreenAdaper.height(44),
                  child: Text(
                    '￥${this._hotProductList[index].price}',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          },
          itemCount: 9,
        ),
      );
    }else{
      return Text('暂无热门推荐数据');
    }

  }

  Widget _recProductItemListWidget() {
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(ScreenAdaper.width(20)),
      width: itemWidth,
      decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Image.network(
                "https://www.itying.com/images/flutter/list1.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
            child: Text(
              '2019秋季大促2019秋季大促2019秋季大促2019秋季大促2019秋季大促2019秋季大促',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '123',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '123',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        decoration: TextDecoration.lineThrough
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _recProductListWidget() {
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: this._bestProductList.map((value){
          String sPic = value.sPic;
          sPic = Config.domain + sPic.replaceAll('\\', '/');
          return Container(
            padding: EdgeInsets.all(ScreenAdaper.width(20)),
            width: itemWidth,
            decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1)),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(sPic, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(10)),
                  child: Text(
                    value.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${value.price}',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '￥${value.oldPrice}',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return ListView(
      children: <Widget>[
        _swiperWidger(),
        SizedBox(height: ScreenAdaper.height(20),),

        _titleWidget('猜你喜欢'),
        _hotProductListWidget(),
        SizedBox(height: ScreenAdaper.height(20),),

        _titleWidget('热门推荐'),
        _recProductListWidget(),
      ]
    );
  }

}