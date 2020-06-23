import 'package:dgg_flutter_address_picker/dgg_flutter_address_picker.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List networkData=[
    {
      "code": "110000",
      "id": "110000",
      "name": "四川省",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
    },
    {
      "code": "110000",
      "id": "110000",
      "name": "山西省",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
    },
    {
      "code": "110000",
      "id": "110000",
      "name": "山东省",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
    },
    {
      "code": "110000",
      "id": "110000",
      "name": "陕西省",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
    },
  ];
  List networkCity=[
     {
      "code": "220000",
      "id": "110000",
      "name": "成都市",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
     },
     {
      "code": "220000",
      "id": "110000",
      "name": "太原市",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
     },
     {
      "code": "220000",
      "id": "110000",
      "name": "济南市",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
     },
     {
      "code": "220000",
      "id": "110000",
      "name": "西安市",
      "pcode": "2147483647",
      "pid": "7453706779315408896",
     }
  ];
  List networkArea=[
    {
    "code": "330000",
    "id": "110000",
    "name": "武侯区",
    "pcode": "2147483647",
    "pid": "7453706779315408896",
    },
    {
    "code": "330000",
    "id": "110000",
    "name": "双流区",
    "pcode": "2147483647",
    "pid": "7453706779315408896",
    },
    {
    "code": "330000",
    "id": "110000",
    "name": "金牛区",
    "pcode": "2147483647",
    "pid": "7453706779315408896",
    },
    {
    "code": "330000",
    "id": "110000",
    "name": "锦江区",
    "pcode": "2147483647",
    "pid": "7453706779315408896",
    }
  ];
  String province="四川省";
  String city="成都市";
  String area="武侯区";
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text(
          "测试",
          style: TextStyle(color: Colors.black),  
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: bodyContent(context),
    );
  }
  // 页面主体组件
  Widget bodyContent(BuildContext context){
    return SafeArea(
      child: Container(
        color: Color.fromRGBO(15, 15, 15, 1),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 200.0,
                height: 40.0,
                alignment: Alignment.center,
                child: Text("$province-$city-$area"),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)
                ),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius:  BorderRadius.circular(30.0),
                  ),
                  onPressed: (){
                    // 处理本地多元数组
                    DggPicker.openPicker(
                      context: context,
                      isDark:true,
                      // 传入默认省市区值，必须传入顺序正确且匹配列表数据的值
                      startPickerData:["北京市","北京市","东城区"],
                      // 是否是网络请求数据，false为使用本地多元数据
                      requestFlag: false,
                      // picker的头部文字
                      pickerTitle: "请选择地址",
                      // 级数必填
                      series: 3,
                      // 网络请求初始code
                      startCode:"",
                      // 配置基础属性
                      pickerTheme:PickerTheme(
                        // picker背景色，以下为默认值
                        backgroundColor:Colors.red,
                        // tabbar选中颜色，以下为默认值
                        tabbarColor:Color.fromRGBO(16,187,184,1),
                        // 列表项选中时颜色，以下为默认值
                        itemStyle:Color.fromRGBO(16,187,184,1),
                        // picker标题字体配置，以下为默认值
                        titleStyle:TextStyle(color: Color.fromRGBO(51,51,51,1), fontSize: 18.0)
                      ),
                      // picker选择后的回调，val获取的值
                      pickerCallback:(List val){
                        // 选择完毕 获取到值
                        print(val);
                        setState(() {});
                      },
                      // 如果requestFlag为true,则必须传入网络请求回调，自己写入请求函数；setFn传入请求到的已转为dart数据的值
                      networkCallback: (String code,Function setFn) {
                        Future.delayed(Duration(milliseconds: 100)).then((_){
                          if(code==""){
                            setFn(handleNetData(networkData));
                          }else if(code=="110000"){
                            setFn(handleNetData(networkCity));
                          }else if(code == "220000"){
                            setFn(handleNetData(networkArea));
                          }
                        });
                      }
                    );
                  },
                  child: Container(
                    height: 60.0,
                    width: 120.0,
                    child: Center(
                        child: Text(
                        "点我",
                        style:TextStyle(color: Colors.white,fontSize: 20.0),
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// 请自行将网络请求JSON数据转DART数据。
// 注意：必须要有name和code，checkFlag需要默认设置为false
// 下面是例子：
handleNetData(netData){
  List netDataArr=[];
  for(int a=0;a<netData.length;a++){
    NetworkData networkA=NetworkData.fromJson(netData[a]);
    networkA.checkFlag=false;
    netDataArr.add(networkA);
  }
  return netDataArr;
}
class NetworkData {
  String code;
  String id;
  String name;
  String pcode;
  String pid;
  bool checkFlag;

  NetworkData({this.code, this.id, this.name, this.pcode, this.pid, this.checkFlag});

  NetworkData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    id = json['id'];
    name = json['name'];
    pcode = json['pcode'];
    pid = json['pid'];
    checkFlag = json['checkFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pcode'] = this.pcode;
    data['pid'] = this.pid;
    data['checkFlag'] = this.checkFlag;
    return data;
  }
}
