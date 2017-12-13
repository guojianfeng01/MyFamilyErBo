//
//  UIDefine.swift
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/12.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

import UIKit

let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height

//MARK: 颜色配置
/// alpha is zero, The color With RGB
///
/// - Parameters:
///   - red: CGFloat
///   - green: CGFloat
///   - blue: CGFloat
/// - Returns: color
func RGB(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> UIColor{
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
}


/// alpha is not zero, The color With RGB
///
/// - Parameters:
///   - red: CGFloat
///   - green: CGFloat
///   - blue: CGFloat
///   - alpha: CGFloat
/// - Returns: color
func RGBA(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat,_ alpha: CGFloat) -> UIColor{
    return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

func kColor_hex(_ rgbValue: NSInteger) -> UIColor {
    return RGB(CGFloat((rgbValue & 0xFF0000) >> 16), CGFloat((rgbValue & 0xFF00) >> 8), CGFloat(rgbValue & 0xFF))
}

let kColor_1       = RGB(20,148,155)            //用于重点突出文字、数字、按钮和点击后的icon
let kColor_1H      = RGB(26,126,217)            //用于按钮点击后的高亮颜色
let kColor_1h      = RGB(233,245,255)           //用于分隔模块的底色，以及部分按钮的文字
let kColor_2       = RGB(255,255,255)           //用于分隔模块的底色，以及部分按钮的文字
func kColor_2_A(a: CGFloat) -> UIColor{return RGBA(255,255,255,a)}//白色，透明度自己调整
func kColor_3_A(a: CGFloat) -> UIColor{return RGBA(0, 0, 0,a)}//用于弹出框背景，透明度需调整
let kColor_4       = RGB(51,51,51)              //纯黑色(用于重要文字信息，如导航栏文字，内页标题文字)
let kColor_5       = RGB(102,102,102)           //主标题黑色(用于次级文字，如列表页的标签、菜单栏和导航栏文字、图标)
let kColor_6       = RGB(153,153,153)           //次级标题黑色(用于辅助文字信息，普通文字段落信息和引导词)
let kColor_7       = RGB(204,204,204)           //弱3(用于默认文字信息 1px)
let kColor_8       = RGB(229,229,229)           //弱2(用于同模块不同内容的分割线，分割线默认  1px)
let kColor_9       = RGB(245,245,245)           //弱1(用于分隔模块或者背景的底色)
let kColor_10      = RGB(44,206,170)            //绿色(用于各种辅助性指标性图标)
let kColor_11      = RGB(255,100,110)           //红色 爱情基色调
let kColor_11h     = RGB(255,218,220)           //
let kColor_11H     = RGB(231,96,105)            //
let kColor_12      = RGB(75, 165, 251)          //蓝色 人才基色调
let kColor_12h     = RGB(232, 241, 250)         //
let kColor_12H     = RGB(67, 148, 225)          //
let KColorGardenDisable     = RGB(204, 204, 204)//

//MARK: 字体配置
func kFontWithF(_ f: CGFloat) -> UIFont{return UIFont.systemFont(ofSize: f)}
let kFont_1        = kFontWithF(1)
let kFont_2         = kFontWithF(2)
let kFont_3         = kFontWithF(3)
let kFont_4         = kFontWithF(4)
let kFont_5         = kFontWithF(5)
let kFont_6         = kFontWithF(6)
let kFont_7         = kFontWithF(7)
let kFont_8         = kFontWithF(8)
let kFont_9         = kFontWithF(9)
let kFont_10        = kFontWithF(10)
let kFont_12        = kFontWithF(12)
let kFont_13        = kFontWithF(13)
let kFont_14        = kFontWithF(14)
let kFont_15        = kFontWithF(15)
let kFont_16        = kFontWithF(16)
let kFont_17        = kFontWithF(17)
let kFont_18        = kFontWithF(18)
let kFont_19        = kFontWithF(19)
let kFont_20        = kFontWithF(20)
let kFont_21        = kFontWithF(21)
let kFont_22        = kFontWithF(22)
let kFont_23        = kFontWithF(23)
let kFont_24        = kFontWithF(24)
let kFont_25        = kFontWithF(25)
