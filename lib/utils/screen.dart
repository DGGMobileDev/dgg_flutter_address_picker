import 'package:flutter_screenutil/flutter_screenutil.dart';

///假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
void setScreenSize(context) {
  ScreenUtil.init(context, width: 750, height: 1334);
}

double setWidth(double pxNum) {
  return ScreenUtil().setWidth(pxNum);
}

double setHeight(double pxNum) {
  return ScreenUtil().setHeight(pxNum);
}

double setFontSize(double pxNum) {
  return ScreenUtil().setSp(pxNum);
}
