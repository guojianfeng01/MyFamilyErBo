//
//  UIScrollView+MWInfiniteScrolling.h
//  Pods
//
//  Created by liu nian on 4/6/16.
//
//

#import <UIKit/UIKit.h>

@class MWInfiniteScrollingView;
@interface UIScrollView (MWInfiniteScrolling)

/**
 *  添加上提操作
 *
 *  @param actionHandler 操作柄
 */
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;

/**
 *  主调调用加载更多
 */
- (void)triggerInfiniteScrolling;
/**
 *  停止加载更多动画
 */
- (void)stopTriggerInfiniteAnimation;

@property (nonatomic, strong, readonly) MWInfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@end

enum {
    MWInfiniteScrollingStateStopped = 0,
    MWInfiniteScrollingStateTriggered,
    MWInfiniteScrollingStateLoading,
    MWInfiniteScrollingStateAll = 10
};

typedef NSUInteger MWInfiniteScrollingState;

@interface MWInfiniteScrollingView : UIView

@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, readonly) MWInfiniteScrollingState state;
@property (nonatomic, readwrite) BOOL enabled;

- (void)setCustomView:(UIView *)view forState:(MWInfiniteScrollingState)state;

- (void)startAnimating;
- (void)stopAnimating;

@end
