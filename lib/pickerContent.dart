import 'package:dgg_flutter_address_picker/theme.dart';
import 'package:dgg_flutter_address_picker/utils/screen.dart';
import 'package:flutter/material.dart';

class PickerContent extends StatefulWidget {
  final BuildContext sheetContext;
  final bool isDark;
  final List startPickerData;
  final String pickerTitle;
  final bool requestFlag;
  final List pickerData;
  final int series;
  final PickerTheme pickerTheme;
  final Function pickerCallback;
  final Function networkCallback;
  PickerContent({
    Key key,
    @required this.sheetContext,
    @required this.isDark,
    this.startPickerData,
    @required this.pickerTitle,
    @required this.requestFlag,
    this.pickerData,
    this.series,
    this.pickerTheme,
    this.pickerCallback,
    this.networkCallback
  }) : super(key: key);
  @override
  _PickerContent createState() => _PickerContent();
}
class _PickerContent  extends State<PickerContent> with TickerProviderStateMixin, WidgetsBindingObserver {
  // picker原始数据
  List pickerData = [];

  // picker级数series
  int series = 0;

  // 已选中的数据
  List startPickerData = [];

  // 是否是第一次打开picker
  bool isFirstOpen=true;

  // picker的title名字
  String pickerTitle = "";

  // 回传数据集合
  List callbackData=[];

  // 是否是网络请求
  bool requestFlag = true;

  // 上一级的上下文
  BuildContext sheetContext;

  // view集合
  List swiperArr = [];

  // 是否需要触犯滚动
  bool nextSwiper=false;

  // 将要滚动到的view
  int nextSwiperindex=0;

  // 创建控制器
  TabController _tabController;
  double controllerOneIndex;
  double controllerTwoIndex;
  double controllerThreeIndex;
  ScrollController controllerOne = ScrollController();
  ScrollController controllerTwo = ScrollController();
  ScrollController controllerThree = ScrollController();

  // tab内容顶部
  List<Widget> tabBarList=<Tab>[
    Tab(
      text: "请选择"
    )
  ];

  @protected
  // bool get wantKeepAlive=>true;
  @override
  void initState() {
    super.initState();
    swiperArr=widget.pickerData;
    try{
      if(widget.startPickerData.length!=0){
        tabBarList=[];
        for(int i=0;i<widget.startPickerData.length;i++){
          if(i<widget.series){
            tabBarList.add(Tab(text: widget.startPickerData[i]));
          }
        }
        if(tabBarList.length<widget.series){
          tabBarList.add(Tab(text: "请选择"));
        }
      } 
    }catch(e){}
    if(swiperArr.length!=0){
      for(int j=0;j<swiperArr.length;j++){
        List a=swiperArr[j];
        for(int i=0;i<a.length;i++){
          if(a[i].checkFlag){
            callbackData.add(a[i]);
            switch (j) {
              case 0:
                controllerOneIndex=double.parse(i.toString());
                break;
              case 1:
                controllerTwoIndex=double.parse(i.toString());
                break;
              case 2:
                controllerThreeIndex=double.parse(i.toString());
                break;
              default:
            }
          }
        }
        
      }
    }
    _tabController=new TabController(
      vsync: this,
      length: swiperArr.length
    );
    _tabController.addListener((){
      if(_tabController.indexIsChanging){}
    });
  }
  @override
  void dispose() {
    print("已注销");
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    setScreenSize(context);
    WidgetsBinding.instance.addPostFrameCallback((callback){
      if(isFirstOpen){
        isFirstOpen=false;
        if(controllerOneIndex!=null){
          controllerOne.jumpTo(controllerOneIndex*setHeight(90.0));
        }
        if(controllerTwoIndex!=null){
          _tabController.animateTo(1,duration: Duration(milliseconds: 10));
          Future.delayed(Duration(milliseconds: 200),(){
            controllerTwo.jumpTo(controllerTwoIndex*setHeight(90.0));
          });
        }
        if(controllerThreeIndex!=null){
          _tabController.animateTo(2,duration: Duration(milliseconds: 10));
          Future.delayed(Duration(milliseconds: 200),(){
            controllerThree.jumpTo(controllerThreeIndex*setHeight(90.0));
          });
        }
      }
      if(nextSwiper){
        nextSwiper=false;
        _tabController.animateTo(nextSwiperindex);
      }else{
        return null;
      }
    });
    pickerTitle = widget.pickerTitle;
    requestFlag = widget.requestFlag;
    sheetContext = widget.sheetContext;
    pickerData = widget.pickerData;
    series=widget.series;
    startPickerData = widget.startPickerData??[];
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? Color.fromRGBO(45, 45, 46, 1) : Colors.white, 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0)
        )
      ),
      child: Column(
        children: <Widget>[
          pickerTop(context,pickerTitle),
          pickerTopTitle(context),
          Expanded(
            child:tabBarView(context),
          )
        ],
      ),
    );
  }
  // 刷新控制器
  refreshController(){
    _tabController.dispose();
    _tabController=new TabController(
      vsync: this,
      length: swiperArr.length
    );
    _tabController.addListener((){if(_tabController.indexIsChanging){}});
  }

  // picker头部操作区域
  Widget pickerTop(BuildContext context,String pickerTitle){
    return Container(
      height: 50.0,
      child: Stack(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                pickerTitle,
                style: TextStyle(color:widget.isDark ? Color.fromRGBO(224, 224, 224, 1) : Color.fromRGBO(51,51,51, 1))
                // widget.pickerTheme.titleStyle
              ),
            ),
          ),
          Positioned(
            top: 15.0,
            right: 10.0,
            child: InkWell(
              onTap: (){
                  Navigator.of(sheetContext).maybePop();
              },
              child: Container(
                width: 20.0,
                height: 20.0,
                child: Icon(
                  Icons.close,
                  color: widget.isDark ? Color.fromRGBO(224, 224, 224, 1) : Color(0xFF666666),
                  size: 20.0,
                )
              ),
            ),
          )
        ],
      )
    );
  }
  Widget pickerTopTitle(BuildContext context){
    return Container(
      height: setHeight(80.0),
      width: setWidth(750.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child:Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor:Colors.transparent,
                labelColor:widget.pickerTheme.tabbarColor,
                unselectedLabelColor:widget.isDark ? Color.fromRGBO(134, 134, 134, 1) : Color.fromRGBO(0, 0, 0, 0.65),
                indicatorSize: TabBarIndicatorSize.label,
                tabs:tabBarList.map((f){
                  return f;
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget tabBarView(BuildContext context){
    return TabBarView(
      controller: _tabController,
      children: 
      swiperArr.asMap().keys.map((i){
        return pickerList(context,i);
      }).toList(),
    );
  }
  Widget pickerList(BuildContext context,int swiperIndex){
    int listLength=swiperArr[swiperIndex].length;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      child: ListView.builder(
        itemCount: listLength,
        itemExtent: setHeight(90.0),
        controller: swiperIndex==0?controllerOne:swiperIndex==1?controllerTwo:controllerThree,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: (){
              clickItem(swiperIndex,index);
            },
            child: Container(
              color: widget.isDark ? Color.fromRGBO(45, 45, 46, 1) : Colors.white,
              height: setHeight(90.0),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20.0),
              child: swiperArr[swiperIndex][index].checkFlag?
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(swiperArr[swiperIndex][index].name,style: TextStyle(color: widget.pickerTheme.itemStyle,fontSize: 14.0),),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.check,size: 20.0,color: widget.pickerTheme.itemStyle),
                  )
                ],
              ):Text(swiperArr[swiperIndex][index].name,style: TextStyle(color:widget.isDark ? Color.fromRGBO(224, 224, 224, 1) : Color.fromRGBO(51,51,51, 1)),)
            ),
          );
        },
      ),
    );
  }
  // 点击处理事件
  clickItem(int swiperIndex, int index){
    if(swiperArr[swiperIndex][index].checkFlag == false){
      for(var i=0;i<swiperArr[swiperIndex].length;i++){
        swiperArr[swiperIndex][i].checkFlag=false;
      }
      switch (swiperIndex) {
        case 0:
          controllerOneIndex=double.parse(index.toString());
          break;
        case 1:
          controllerTwoIndex=double.parse(index.toString());
          break;
        case 2:
          controllerThreeIndex=double.parse(index.toString());
          break;
        default:
          print("没了");
      }
      swiperArr[swiperIndex][index].checkFlag=true;
      bool continueFlag=getItem(swiperIndex,swiperArr[swiperIndex][index]);
      String tabName=swiperArr[swiperIndex][index].name;
      tabBarList.fillRange(swiperIndex, swiperIndex+1,Tab(text:tabName));
      if(!continueFlag){
        setState(() {});
        return null;
      }
      if(requestFlag==true){
        widget.networkCallback(swiperArr[swiperIndex][index].code,(getdata){
          if(getdata.length!=0){
            if(swiperIndex==swiperArr.length-1){
              swiperArr.add(getdata);
              tabBarList.add(Tab(text:"请选择"));
            }else{
              swiperArr.fillRange(swiperIndex+1, swiperIndex+2,getdata);
              tabBarList.fillRange(swiperIndex+1, swiperIndex+2,Tab(text:"请选择"));
              tabBarList.removeRange(swiperIndex+2,swiperArr.length);
              swiperArr.removeRange(swiperIndex+2, swiperArr.length);
            }
            nextSwiper=true;
            nextSwiperindex=swiperIndex+1;
            refreshController();
            _tabController.index=swiperIndex;
            setState(() {});
          }else{
            widget.pickerCallback(callbackData);
            Navigator.of(sheetContext).maybePop();
          }
        });
      }else{
        if(swiperArr[swiperIndex][index].children!=null&&swiperArr[swiperIndex][index].children.length!=0){
          if(swiperIndex==swiperArr.length-1){
            swiperArr.add(swiperArr[swiperIndex][index].children);
            tabBarList.add(Tab(text:"请选择"));
          }else{
            swiperArr.fillRange(swiperIndex+1, swiperIndex+2,swiperArr[swiperIndex][index].children);
            tabBarList.fillRange(swiperIndex+1, swiperIndex+2,Tab(text:"请选择"));
            tabBarList.removeRange(swiperIndex+2,swiperArr.length);
            swiperArr.removeRange(swiperIndex+2, swiperArr.length);
          }
          nextSwiper=true;
          nextSwiperindex=swiperIndex+1;
          refreshController();
          _tabController.index=swiperIndex;
        }
      }
      setState(() {});
    }
  }
  // 获取选择的条目信息
  getItem(int index,data){
    if(callbackData.length==index){
      callbackData.add(data);
    }else if(callbackData.length>index){
      callbackData.fillRange(index,index+1,data);
      try{
        callbackData.removeRange(index+2, callbackData.length);
      }catch(e){}
    }
    if(index==widget.series-1){
       widget.pickerCallback(callbackData);
       Navigator.of(sheetContext).maybePop();
       return false;
    }
    return true;
  }
}