
import 'package:flutter/material.dart';

///背景色
const BACKGROUND_COLOR = Colors.white;

///tabbar工具栏颜色
const Color Tabbar_COLOR = Color.fromRGBO(16,187,184,1);

///选择器内容颜色
const Color ITEM_COLOR = Color.fromRGBO(16,187,184,1);

///标题样式
const TextStyle Title_STYLE = TextStyle(color: Color.fromRGBO(51,51,51,1), fontSize: 18.0);

///默认配置样式
class PickerTheme{
  const PickerTheme({
    this.backgroundColor: BACKGROUND_COLOR,
    this.tabbarColor: Tabbar_COLOR,
    this.itemStyle:ITEM_COLOR,
    this.titleStyle: Title_STYLE,
  });

  static const PickerTheme Default = const PickerTheme();

  final Color backgroundColor;

  final Color tabbarColor;

  final Color itemStyle;

  final TextStyle titleStyle;
}