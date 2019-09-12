import 'package:flutter/material.dart';

import 'Home.dart';
import 'Cart.dart';
import 'Category.dart';
import 'User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs>{
  int _currentIndex = 0;
  PageController _pageController;
  List<Widget> _pageList=[
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage()
  ];

  @override
  void initState(){
    super.initState();
    this._pageController = PageController(initialPage: this._currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('jdshop'),
        ),
        // 页面状态保持第一种方法：
        // 保持所有的页面状态，使用indexedStack
        // body: IndexedStack(
        //   index: this._currentIndex,
        //   children: _pageList,
        // ),
        // IndexedStack：保此所有页面的状态：
        // AutomaticKeepAliveClientMixin：保此部分页面的状态：

        body: PageView( //this._pageList[this._currentIndex],
          controller: this._pageController,
          children: this._pageList,
          onPageChanged: (index) {
            this.setState((){
              this._currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: this._currentIndex,
            onTap: (index){
              this.setState((){
                this._currentIndex = index;
                this._pageController.jumpToPage(this._currentIndex);
              });
            },
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.red,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
              BottomNavigationBarItem(icon: Icon(Icons.category), title: Text('分类')),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), title: Text('购物车')),
              BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('我的')),
            ]
        ),
      ),
    );
  }
}