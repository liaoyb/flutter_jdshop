import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import '../../services/ScreenAdaper.dart';
import '../../config/Config.dart';
import '../../model/CateModel.dart';

class CategoryPage extends StatefulWidget{
  CategoryPage({Key key}): super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin{
  int _selectIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    _getLeftCateData();
  }

  //左侧数据
  void _getLeftCateData() async{
    var api = '${Config.domain}api/pcate';
    var result = await Dio().get(api);
    var leftCateList = CateModel.fromJson(result.data);
    setState(() {
      this._leftCateList = leftCateList.result;
    });
    _getRightCateData(leftCateList.result[0].sId);
  }

  //右侧数据
  void _getRightCateData(pid) async {
    var api = '${Config.domain}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    var rightcateList = CateModel.fromJson(result.data);
    setState(() {
      this._rightCateList = rightcateList.result;
    });
  }

  //左侧组件
  Widget _leftCateWidget(leftWidth) {
    if (this._leftCateList.length > 0){
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemCount: this._leftCateList.length,
          itemBuilder: (context, index) => Column(
            children: <Widget>[
              InkWell(
                onTap: (){
                  //setState(() {
                    _selectIndex = index;
                    this._getRightCateData(this._leftCateList[index].sId);
                  //});
                },
                child: Container(
                  width: double.infinity,
                  height: ScreenAdaper.height(56),
                  padding: EdgeInsets.only(top: ScreenAdaper.height(24)),
                  child: Text("${this._leftCateList[index].title}",
                    textAlign: TextAlign.center,),
                  color: _selectIndex == index ? Color.fromRGBO(240, 246, 246, 0.9) : Colors.white,
                ),
              ),
              Divider(height: 1,),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: leftWidth,
        height: double.infinity,
      );
    }
  }

  //右侧组件
  Widget _rightCateWidget(rightItemWidth, rightItemHeigth) {
    if (this._rightCateList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: rightItemWidth /rightItemHeigth,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: this._rightCateList.length,
            itemBuilder: (context, index){
              //处理图片
              String pic = this._rightCateList[index].pic;
              pic = Config.domain + pic.replaceAll('\\', '/');
              return Container(
                // padding: EdgeInsets.all(ScreenAdaper.width(20)),
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(pic, fit: BoxFit.cover),
                    ),
                    Container(
                      height: ScreenAdaper.height(32),
                      child: Text(this._rightCateList[index].title),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }else{
      return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          height: double.infinity,
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: Text('加载中......'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    //计算右侧GridView宽高比：
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;
    //右侧宽高=总宽度-左侧宽度-Gridview外层元素左右的Padding值-GridView中间的间距
    var rightItemWidth =
      (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    var rightItemHeigth = rightItemWidth + ScreenAdaper.height(32);

    return Row(
      children: <Widget>[
        _leftCateWidget(leftWidth),
        _rightCateWidget(rightItemWidth, rightItemHeigth),
      ],
    );
  }

}