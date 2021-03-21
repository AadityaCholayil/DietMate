import 'package:dietmate/food_form.dart';
import 'package:dietmate/pages/homepage.dart';
import 'package:dietmate/pages/neeraj_temp.dart';
import 'package:dietmate/pages/profile_detail_page.dart';
import 'package:dietmate/pages/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PreloadPageController pageController = PreloadPageController(initialPage: 0);
  int pageNo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PreloadPageView(
        preloadPagesCount: 4,
        controller: pageController,
        onPageChanged: (int) {
          setState(() {
            print('Page Changes to index $int');
            pageNo = int;
          });
        },
        children: <Widget>[
          HomePage(),
          ReportPage(),
          NeerajTemp(),
          ProfilePage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        child: FittedBox(
          child: OpenContainer(
            closedColor: Theme.of(context).canvasColor,
            openColor: Theme.of(context).canvasColor,
            transitionDuration: Duration(milliseconds: 350),
            openBuilder: (context, closedContainer){
              return FoodForm();
            },
            closedShape: CircleBorder(),
            closedBuilder: (context, openContainer){
              return FloatingActionButton(
                elevation: 2,
                child: Icon(Icons.add,
                  size: 33,
                ),
                onPressed: () {
                  openContainer();
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 27),
          child: Row(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: pageNo==0?Theme.of(context).primaryColorDark:Theme.of(context).colorScheme.onSurface,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    pageNo=0;
                    pageController.animateToPage(0, duration: Duration(milliseconds: 600) , curve: Curves.ease);
                  });
                },
              ),
              SizedBox(width: 15,),
              IconButton(
                icon: Icon(
                  Icons.bar_chart,
                  color: pageNo==1?Theme.of(context).primaryColorDark:Theme.of(context).colorScheme.onSurface,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    pageNo=1;
                    pageController.animateToPage(1, duration: Duration(milliseconds: 600) , curve: Curves.ease);
                  });
                },
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.alternate_email,
                  color: pageNo==2?Theme.of(context).primaryColorDark:Theme.of(context).colorScheme.onSurface,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    pageNo=2;
                    pageController.animateToPage(2, duration: Duration(milliseconds: 600) , curve: Curves.ease);
                  });
                },
              ),
              SizedBox(width: 15,),
              IconButton(
                icon: Icon(
                  Icons.perm_identity,
                  color: pageNo==3?Theme.of(context).primaryColorDark:Theme.of(context).colorScheme.onSurface,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    pageNo=3;
                    pageController.animateToPage(3, duration: Duration(milliseconds: 600) , curve: Curves.ease);
                  });
                },
              ),
            ],
          ),
        ),
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 10,
      ),
    );
  }
}

