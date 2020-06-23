import 'package:dgg_flutter_address_picker/localDataModel.dart';
import 'package:dgg_flutter_address_picker/pickerContent.dart';
import 'package:dgg_flutter_address_picker/theme.dart';
import 'package:flutter/material.dart';
import 'package:dgg_flutter_address_picker/utils/screen.dart';
import 'package:dgg_flutter_address_picker/pcData.dart';
import 'dart:async';

class DggPicker {
  static Future<Null> openPicker({
    @required BuildContext context,
    List startPickerData,
    PickerTheme pickerTheme:PickerTheme.Default,
    // 暗黑模式
    bool isDark=false,
    // 默认传入的初始数据
    bool requestFlag = true,
    // 是网络请求下级数据的picker，还是使用的本地多元数组数据
    String pickerTitle = "请选择",
    // picker的原始数据
    int series,
    // 级数,使用本地数据必填
    String startCode = "",
    // 网络请求初始code，不传默认为空字符串
    Function pickerCallback,
    // 获取值后回调
    Function networkCallback
  }){
    assert(context!=null);
    assert(requestFlag!=null);
    assert(pickerTitle!=null);
    assert(series!=null);
    if(series>3||series<1){
        print("级数不能大于3,且不能小于1");
        return null;
    }
    switch(requestFlag){
      case false:
        List local=PickerData.getData();
        List pickerData=[];
        pickerData=getLocalData(local);
        List swiperArr=[];
        if(startPickerData!=null&&startPickerData.length!=0){
          swiperArr=handlelocalData(series,startPickerData,pickerData);
        }else{
          swiperArr.add(pickerData);
        }
        show(
          context,
          isDark,
          startPickerData,
          pickerTitle,
          requestFlag,
          swiperArr,
          series,
          pickerTheme,
          pickerCallback,
          networkCallback
        );
        break;
      case true:
        // 如果是网络请求数据的话
        if(networkCallback!=null){
          if(startPickerData!=null&&startPickerData.length!=0){
            // 请求网络数据后打开picker
            handleNetworkData(startCode,series,startPickerData,networkCallback).then((swiperArr){
              show(
                context,
                isDark,
                startPickerData,
                pickerTitle,
                requestFlag,
                swiperArr,
                series,
                pickerTheme,
                pickerCallback,
                networkCallback
              );
            });
          }else{
            getFutureData(startCode,networkCallback).then((provinceArr){
              List swiperArr=[];
              swiperArr.add(provinceArr);
              show(
                context,
                isDark,
                startPickerData,
                pickerTitle,
                requestFlag,
                swiperArr,
                series,
                pickerTheme,
                pickerCallback,
                networkCallback
              );
            });
          }
        }else{
          print("网络请求数据，需要配置回调方法——networkCallback");
        }
        break;
      default:
        print("请传入正确的requestFlag值");
    }
  }
}
// 处理本地数据
getLocalData(List local){
  List handleData = [];
  local.forEach((a){
    LocalData provinceItem=LocalData.fromJson(a);
    provinceItem.checkFlag=false;
    List cityArr=[];
    provinceItem.children.forEach((b){
      LocalData cityItem=LocalData.fromJson(b);
      cityItem.checkFlag=false;
      cityArr.add(cityItem);
      List areaArr=[];
      cityItem.children.forEach((c){
        LocalData areaItem=LocalData.fromJson(c);
        areaItem.checkFlag=false;
        areaArr.add(areaItem);
      });
      cityItem.children=areaArr;
    });
    provinceItem.children=cityArr;
    handleData.add(provinceItem);
  });
  return handleData;
}
// 弹起picker
Future show(
    BuildContext context,
    bool isDark,
    List startPickerData,
    String pickerTitle,
    bool requestFlag,
    List pickerData,
    int series,
    PickerTheme pickerTheme,
    Function pickerCallback,
    Function networkCallback
  ){
  return showModalBottomSheet(
    context:context,
    builder:(BuildContext context){
      return Stack(
        children: <Widget>[
          Container(
            height: 30.0,
            width: double.infinity,
            color: isDark ? Color.fromRGBO(15, 15, 15, 1) : Colors.black54,
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? Color.fromRGBO(45, 45, 46, 1) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              )
            ),
          ),
          PickerContent(
            sheetContext: context,
            isDark:isDark,
            startPickerData:startPickerData,
            pickerTitle: pickerTitle,
            requestFlag: requestFlag,
            pickerData: pickerData,
            series: series,
            pickerTheme:pickerTheme,
            pickerCallback:pickerCallback,
            networkCallback:networkCallback
          )
        ],
      );
    }
  );
}
// 使用本地数据，如果有默认数据则需要先装填分级数据
handlelocalData(
  int series,
  List startPickerData,
  List pickerData
){
  List swiperArr=[];
  int seriesIndex=series;
  for(int a=0;a<pickerData.length;a++){
    if(pickerData[a].name==startPickerData[0]){
      // 将默认的省级数据选中
      pickerData[a].checkFlag=true;
      // 装入省级数据
      swiperArr.add(pickerData);
      seriesIndex--;
      // 判断是否符合级数
      if(swiperArr.length>=series){
        return swiperArr;
      }
      if(seriesIndex==0||startPickerData.length<2){
        swiperArr.add(pickerData[a].children);
        return swiperArr;
      }
      for(int b=0;b<pickerData[a].children.length;b++){
        if(pickerData[a].children[b].name==startPickerData[1]){
          // 将默认的市级数据选中
          pickerData[a].children[b].checkFlag=true;
          // 装入市级数据
          swiperArr.add(pickerData[a].children);
          seriesIndex--;
          // 判断是否符合级数
          if(swiperArr.length>=series){
            return swiperArr;
          }
          if(seriesIndex==0||startPickerData.length<3){
            swiperArr.add(pickerData[a].children[b].children);
            return swiperArr;
          }
          for(int c=0;c<pickerData[a].children[b].children.length;c++){
            if(pickerData[a].children[b].children[c].name==startPickerData[2]){
              // 将默认的区级数据选中
              pickerData[a].children[b].children[c].checkFlag=true;
              // 装入区级数据
              swiperArr.add(pickerData[a].children[b].children);
              return swiperArr;
            }
          }
        }
      }
    }
  }
}
// 如果有默认值则需要初始异步请求网路数据.
Future handleNetworkData(
  String startCode,
  int series,
  List startPickerData,
  Function networkCallback
){
  Completer completer = new Completer();
  int seriesIndex=series;
  List swiperArr=[];
  List provinceArr=[];
  List cityArr=[];
  List areaArr=[];
  getFutureData(startCode,networkCallback).then((classA){
    String codeAStorage="";
    if(classA.length!=0){
      classA.forEach((a){
        a.checkFlag=false;
        try{
          if(a.name == startPickerData[0]){
            a.checkFlag=true;
            codeAStorage=a.code;
          }
        }catch(e){}
        provinceArr.add(a);
      });
      swiperArr.add(provinceArr);
      seriesIndex--;
      if(seriesIndex==0){
        completer.complete(swiperArr);
        return;
      }
      if(codeAStorage!=""){
        getFutureData(codeAStorage,networkCallback).then((classB){
          String codeBStorage="";
          if(classB.length!=0){
            classB.forEach((b){
              b.checkFlag=false;
              try{
                if(b.name == startPickerData[1]){
                  b.checkFlag=true;
                  codeBStorage=b.code;
                }
              }catch(e){}
              cityArr.add(b);
            });
            swiperArr.add(cityArr);
            seriesIndex--;
            if(seriesIndex==0){
              completer.complete(swiperArr);
              return;
            }
            if(codeBStorage!=""){
              getFutureData(codeBStorage,networkCallback).then((classC){
                if(classC.length!=0){
                  classC.forEach((c){
                    c.checkFlag=false;
                    try{
                      if(c.name == startPickerData[2]){
                        c.checkFlag=true;
                      }
                    }catch(e){}
                    areaArr.add(c);
                  });
                  swiperArr.add(areaArr);
                  completer.complete(swiperArr);
                }else{
                  completer.complete(swiperArr);
                  print("第三组数据为空");
                }
              });
            }else{
              completer.complete(swiperArr);
            }
          }else{
            completer.complete(swiperArr);
            print("第二组数据为空");
          }
        });
      }else{
        completer.complete(swiperArr);
      }
    }else{
      print("首次获取数据为空");
    }
  });
  return completer.future;
}
// 简单请求回调函数
Future getFutureData(String code,Function networkCallback){
  Completer completerNet = new Completer();
  networkCallback(code,(List dataList){
    completerNet.complete(dataList);
  });
  return  completerNet.future;
}