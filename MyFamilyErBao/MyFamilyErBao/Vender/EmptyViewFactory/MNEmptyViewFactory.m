//
//  MNEmptyViewFactory.m
//  MNDataBank
//
//  Created by liu nian on 2017/2/27.
//  Copyright © 2017年 Shanghai Chengtai Information Technology Co.,Ltd. All rights reserved.
//

#import "MNEmptyViewFactory.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@implementation MNEmptyViewFactory

#pragma mark - blockConfig

// 请求失败只带文字
+ (void)errorMessage:(UIScrollView *)scrollView
            errorMsg:(NSString *)message{
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"wrong_icon_prompt"];
                                            configer.emptySubtitle = message;
                                            configer.emptyCenterOffsetY = -50;
                                        }
                                        emptyBtnTitle:nil
                                  emptyBtnActionBlock:nil];
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}

// 请求失败带按钮的
+ (void)errorNetwork:(UIScrollView *)scrollView
            btnBlock:(void(^)(void))btnBlock {
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"wrong_icon_nowifi"];
                                            configer.emptyTitle = @"网络请求失败";
                                            //                                            configer.emptySubtitle = @"请点击重新加载\n模拟数据也是需要人品的,现在成功概率更高了\n赶快试一试吧";
                                            configer.emptyCenterOffsetY = -50;
                                        }
                                        emptyBtnTitle:nil
                                  emptyBtnActionBlock:btnBlock];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}

// 请求失败和信息带按钮的
+ (void)errorNetwork:(UIScrollView *)scrollView
            errorMsg:(NSString *)message
            btnBlock:(void(^)(void))btnBlock{
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"wrong_icon_404"];
                                            configer.emptyTitle = @"点击重新加载";
                                            configer.emptySubtitle = message;
                                            configer.emptyCenterOffsetY = -50;
                                        }
                                        emptyBtnTitle:nil
                                  emptyBtnActionBlock:btnBlock];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}

+ (void)errorService:(UIScrollView *)scrollView
            errorMsg:(NSString *)message
            btnBlock:(void(^)(void))btnBlock{
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"wrong_icon_404"];
                                            configer.emptyTitle = @"点击重新加载";
                                            configer.emptySubtitle = message;
                                            configer.emptyCenterOffsetY = -50;
                                        }
                                        emptyBtnTitle:nil
                                  emptyBtnActionBlock:btnBlock];
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}
// 请求成功无数据
+ (void)emptyMainView:(UIScrollView *)scrollView
             errorMsg:(NSString *)message{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = [UIImage imageNamed:@"wrong_icon_nodata"];
    configer.emptyTitle = @"暂无数据";
    configer.emptySubtitle = message;
    configer.emptyCenterOffsetY = -50;
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}
// 首页启动占位图
+ (void)emptyMainView:(UIScrollView *)scrollView
             btnBlock:(void(^)(void))btnBlock {
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView
                                        configerBlock:^(FOREmptyAssistantConfiger *configer) {
                                            configer.emptyImage = [UIImage imageNamed:@"empty_order_icon"];
                                         
                                            configer.emptyTitle = @"暂无数据";
                                            configer.emptyBtntitleFont = [UIFont systemFontOfSize:15];
                                            configer.emptyBtntitleColor = [UIColor redColor];
                                        }
                                        emptyBtnTitle:@"添加"
                                  emptyBtnActionBlock:btnBlock];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
    
}


#pragma mark - modelConfig

// 首页启动占位图(无按钮)
+ (void)emptyMainView:(UIScrollView *)scrollView {
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.emptyImage = [UIImage imageNamed:@"wrong_icon_prompt"];
    configer.emptyTitle = @"已经删除完全部数据了";
    configer.emptySubtitle = @"可以在试试下拉刷新获取数据\n有一定的概率可以加载出之前的数据\n赶快试一试吧";
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}

+ (void)emptyMainView:(UIScrollView *)scrollView image:(UIImage *)image emptyTitle:(NSString *)emptyTitle emptySubtitle:(NSString *)emptySubtitle{
    [self emptyMainView:scrollView image:image emptyTitle:emptyTitle emptySubtitle:emptySubtitle emptyCenterOffsetY:-40];
}

+ (void)emptyMainView:(UIScrollView *)scrollView image:(UIImage *)image emptyTitle:(NSString *)emptyTitle emptySubtitle:(NSString *)emptySubtitle emptyCenterOffsetY:(CGFloat)emptyCenterOffsetY{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    configer.allowScroll = NO;
    configer.emptyCenterOffsetY = emptyCenterOffsetY;
    configer.emptySpaceHeight = 20.0;
    configer.emptyImage = image;
    configer.emptyTitle = emptyTitle;
    configer.emptyTitleFont = [UIFont systemFontOfSize:17.0f];
    configer.emptyTitleColor = [UIColor colorWithRed:0.784 green:0.784 blue:0.784 alpha:1.00];
    configer.emptySubtitle = emptySubtitle;
    configer.emptySubtitleFont = [UIFont systemFontOfSize:12.0f];
    configer.emptySubtitleColor = [UIColor lightGrayColor];
    [FORScrollViewEmptyAssistant emptyWithContentView:scrollView emptyConfiger:configer];
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)scrollView reloadData];
    }else if ([scrollView isKindOfClass:[UICollectionView class]]){
        [(UICollectionView *)scrollView reloadData];
    }else{
        [scrollView reloadEmptyDataSet];
    }
}
@end
