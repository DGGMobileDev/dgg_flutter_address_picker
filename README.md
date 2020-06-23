# dgg_flutter_address_picker
flutter多级地址选择器

### 首先在项目的pubspec.yaml文件中，引入地址分页选择器组件
dgg_flutter_address_picker: ^0.0.1

### 在需要使用的页面上引入组件文件
import 'package:dgg_flutter_address_picker/dgg_flutter_address_picker.dart';

### 使用：
    DggPicker.openPicker(
        context: context,
        isDark:true,
        /// 传入默认省市区值，必须传入顺序正确且匹配列表数据的值
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
