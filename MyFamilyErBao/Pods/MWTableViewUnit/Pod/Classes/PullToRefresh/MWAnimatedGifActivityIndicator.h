//
//  MWAnimatedGifActivityIndicator.h
//  Pods
//
//  Created by liu nian on 4/6/16.
//
//

#import <UIKit/UIKit.h>

typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, MWPullToRefreshState) {
    MWGIFPullToRefreshStateNone = 0,
    MWGIFPullToRefreshStateStopped,
    MWGIFPullToRefreshStateTriggering,
    MWGIFPullToRefreshStateTriggered,
    MWGIFPullToRefreshStateLoading,
    MWGIFPullToRefreshStateCanFinish
};

@interface MWAnimatedGifActivityIndicator : UIView
@property (nonatomic,assign) BOOL isObserving;
@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,assign) CGFloat landscapeTopInset;
@property (nonatomic,assign) CGFloat portraitTopInset;

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,assign) MWPullToRefreshState state;
@property (nonatomic,copy) actionHandler pullToRefreshHandler;
@property (nonatomic,assign) BOOL showAlphaTransition;
@property (nonatomic,assign) BOOL isVariableSize;
@property (nonatomic,assign) UIActivityIndicatorViewStyle activityIndicatorStyle;

- (id)initWithProgressImages:(NSArray *)progressImg
               loadingImages:(NSArray *)loadingImages
     progressScrollThreshold:(NSInteger)threshold
      loadingImagesFrameRate:(NSInteger)lFrameRate;

- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;
- (void)setSize:(CGSize) size;
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle) style;

- (void)setFrameSizeByProgressImage;
- (void)setFrameSizeByLoadingImage;
- (void)orientationChange:(UIDeviceOrientation)orientation;
@end
