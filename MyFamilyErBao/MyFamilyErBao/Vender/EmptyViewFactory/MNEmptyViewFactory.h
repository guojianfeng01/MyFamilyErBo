//
//  MNEmptyViewFactory.h
//  MNDataBank
//
//  Created by liu nian on 2017/2/27.
//  Copyright © 2017年 Shanghai Chengtai Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWTableViewUnit/FORScrollViewEmptyAssistant.h>

@interface MNEmptyViewFactory : NSObject
// 请求失败只带文字
+ (void)errorMessage:(UIScrollView *)scrollView
            errorMsg:(NSString *)message;
// 请求失败带按钮的
+ (void)errorNetwork:(UIScrollView *)scrollView
            btnBlock:(void(^)(void))btnBlock;

// 请求失败网络无法链接
+ (void)errorNetwork:(UIScrollView *)scrollView
            errorMsg:(NSString *)message
            btnBlock:(void(^)(void))btnBlock;
// 请求失败和信息带按钮的
+ (void)errorService:(UIScrollView *)scrollView
            errorMsg:(NSString *)message
            btnBlock:(void(^)(void))btnBlock;
// 请求成功无数据
+ (void)emptyMainView:(UIScrollView *)scrollView
             errorMsg:(NSString *)message;
// 首页启动占位图
+ (void)emptyMainView:(UIScrollView *)scrollView
             btnBlock:(void(^)(void))btnBlock;

// 首页启动占位图(无按钮)
+ (void)emptyMainView:(UIScrollView *)scrollView;

+ (void)emptyMainView:(UIScrollView *)scrollView image:(UIImage *)image emptyTitle:(NSString *)emptyTitle emptySubtitle:(NSString *)emptySubtitle;

+ (void)emptyMainView:(UIScrollView *)scrollView image:(UIImage *)image emptyTitle:(NSString *)emptyTitle emptySubtitle:(NSString *)emptySubtitle emptyCenterOffsetY:(CGFloat)emptyCenterOffsetY;
@end
