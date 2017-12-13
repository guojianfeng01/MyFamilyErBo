//
//  UIScrollView+MWPullToRefresh.h
//  Pods
//
//  Created by liu nian on 4/6/16.
//
//

#import <UIKit/UIKit.h>
#import "MWAnimatedGifActivityIndicator.h"

@interface UIScrollView (MWPullToRefresh)

@property (nonatomic, assign) BOOL showPullToRefresh;
@property (nonatomic, assign) BOOL pullToRefreshAlphaTransition;
@property (nonatomic, assign) BOOL pullToRefreshShowVariableSize;
@property (nonatomic, strong, readonly) MWAnimatedGifActivityIndicator *pullToRefreshView;

#pragma mark - Image Array

/**
 *  设置下拉和加载时的图片组以此来进行动画
 *
 *  @param handler        操作柄
 *  @param progressImages 下拉时的图片组
 *  @param loadingImages  加载中的图片组
 *  @param threshold      可以下拉的高度
 *  @param lframe         加载中的动画频率
 */
- (void)addPullToRefreshProgressImages:(NSArray *)progressImages
                         loadingImages:(NSArray *)loadingImages
               progressScrollThreshold:(NSInteger)threshold
                loadingImagesFrameRate:(NSInteger)lframe
                         actionHandler:(actionHandler)handler;

/**
 *  设置下拉的图片组以此来进行动画,加载中使用UIActivityIndicatorView
 *
 *  @param handler        操作柄
 *  @param progressImages 下拉时的图片组
 *  @param threshold      可以下拉的高度
 */
- (void)addPullToRefreshProgressImages:(NSArray *)progressImages
               progressScrollThreshold:(NSInteger)threshold
                         actionHandler:(actionHandler)handler;

#pragma mark - GIF Image

/**
 *  只设置下拉时的GIF动画，加载中使用系统的UIActivityIndicatorView
 *
 *  @param handler          操作柄
 *  @param progressGIFImage 下拉时的GIF图片
 *  @param threshold        可以下拉的高度
 */
- (void)addPullToRefreshProgressGIFImage:(UIImage *)progressGIFImage
                 progressScrollThreshold:(NSInteger)threshold
                           actionHandler:(actionHandler)handler;
/**
 *  直接使用GIF图片进行配置,使用默认的加载中动画频率(ceilf(1.0/(loadingGIFImage.duration/loadingGIFImage.images.count))
 *
 *  @param handler          操作柄
 *  @param progressGifImage 下拉时的GIF图片
 *  @param loadingGifImage  加载中的GIF图片
 *  @param threshold        可以下拉的高度
 */
- (void)addPullToRefreshProgressGIFImage:(UIImage *)progressGIFImage
                         loadingGIFImage:(UIImage *)loadingGIFImage
                 progressScrollThreshold:(NSInteger)threshold
                           actionHandler:(actionHandler)handler;

/**
 *  直接使用GIF图片进行配置
 *
 *  @param handler          操作柄
 *  @param progressGIFImage 下拉时的GIF图片
 *  @param loadingGIFImage  加载中的GIF图片
 *  @param threshold        可以下拉的高度
 *  @param frameRate        加载中的动画频率
 */
- (void)addPullToRefreshProgressGIFImage:(UIImage *)progressGIFImage
                         loadingGIFImage:(UIImage *)loadingGIFImage
                 progressScrollThreshold:(NSInteger)threshold
                   loadingImageFrameRate:(NSInteger)frameRate
                           actionHandler:(actionHandler)handler;

/**
 *  删除下拉进程中的视图
 */
- (void)removePullToRefreshActionHandler;

/**
 *  手动调用下拉动画
 */
- (void)triggerPullToRefresh;
/**
 *  手动停止加载中动画
 */
- (void)stopPullToRefreshAnimation;

/**
 *  设置横竖屏时加载动画视图的顶部距离
 *
 *  @param pInset 竖屏时距顶部的距离
 *  @param lInset 横盘时距顶部的距离
 */
- (void)addTopInsetInPortrait:(CGFloat)pInset TopInsetInLandscape:(CGFloat)lInset; // Should have called after addPullToRefreshActionHandler

- (void)setPullToRefreshActivityIndcatorStyle:(UIActivityIndicatorViewStyle)activityIndcatorStyle;
- (UIActivityIndicatorViewStyle)pullToRefreshActivityIndcatorStyle;

@end

