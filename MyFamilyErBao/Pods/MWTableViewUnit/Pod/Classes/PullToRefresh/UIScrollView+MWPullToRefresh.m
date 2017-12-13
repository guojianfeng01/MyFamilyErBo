//
//  UIScrollView+MWPullToRefresh.m
//  Pods
//
//  Created by liu nian on 4/6/16.
//
//

#import "UIScrollView+MWPullToRefresh.h"
#import <objc/runtime.h>
#import "AnimatedGIFImageSerialization.h"

static char UIScrollViewPullToRefreshView;
@implementation UIScrollView (MWPullToRefresh)
@dynamic pullToRefreshView, showPullToRefresh;

- (void)addPullToRefreshProgressImages:(NSArray *)progressImages
                         loadingImages:(NSArray *)loadingImages
               progressScrollThreshold:(NSInteger)threshold
                loadingImagesFrameRate:(NSInteger)lframe
                         actionHandler:(actionHandler)handler{
    NSAssert(progressImages.count> 0, @"progressImages not nil and empty");
    if(!self.pullToRefreshView){
        MWAnimatedGifActivityIndicator *view = [[MWAnimatedGifActivityIndicator alloc] initWithProgressImages:progressImages
                                                                                                loadingImages:loadingImages
                                                                                      progressScrollThreshold:threshold
                                                                                       loadingImagesFrameRate:lframe];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(view.bounds))/2,
                                -CGRectGetHeight(view.bounds),
                                CGRectGetWidth(view.bounds),
                                CGRectGetHeight(view.bounds));
        
        view.originalTopInset = self.contentInset.top;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
    
}

- (void)addPullToRefreshProgressImages:(NSArray *)progressImages
               progressScrollThreshold:(NSInteger)threshold
                         actionHandler:(actionHandler)handler{
    [self addPullToRefreshProgressImages:progressImages
                           loadingImages:nil
                 progressScrollThreshold:threshold
                  loadingImagesFrameRate:0
                           actionHandler:handler];
}

#pragma mark - GIF Image

- (void)addPullToRefreshProgressGIFImage:(UIImage *)progressGIFImage
                 progressScrollThreshold:(NSInteger)threshold
                           actionHandler:(actionHandler)handler{
    [self addPullToRefreshProgressImages:progressGIFImage.images
                 progressScrollThreshold:threshold
                           actionHandler:handler];
}

- (void)addPullToRefreshProgressGIFImage:(UIImage *)progressGIFImage
                         loadingGIFImage:(UIImage *)loadingGIFImage
                 progressScrollThreshold:(NSInteger)threshold
                           actionHandler:(actionHandler)handler{
    [self addPullToRefreshProgressImages:progressGIFImage.images
                           loadingImages:loadingGIFImage.images
                 progressScrollThreshold:threshold
                  loadingImagesFrameRate:(NSInteger)ceilf(1.0/(loadingGIFImage.duration/loadingGIFImage.images.count))
                           actionHandler:handler];
}
- (void)addPullToRefreshProgressGIFImage:(UIImage *)progressGIFImage
                         loadingGIFImage:(UIImage *)loadingGIFImage
                 progressScrollThreshold:(NSInteger)threshold
                   loadingImageFrameRate:(NSInteger)frameRate
                           actionHandler:(actionHandler)handler{
    [self addPullToRefreshProgressImages:progressGIFImage.images
                           loadingImages:loadingGIFImage.images
                 progressScrollThreshold:threshold
                  loadingImagesFrameRate:frameRate
                           actionHandler:handler];
}


- (void)addTopInsetInPortrait:(CGFloat)pInset TopInsetInLandscape:(CGFloat)lInset{
    self.pullToRefreshView.portraitTopInset = pInset;
    self.pullToRefreshView.landscapeTopInset = lInset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown){
        self.pullToRefreshView.originalTopInset = self.pullToRefreshView.portraitTopInset;
    } else {
        self.pullToRefreshView.originalTopInset = self.pullToRefreshView.landscapeTopInset;
    }
}

- (void)removePullToRefreshActionHandler{
    self.showPullToRefresh = NO;
    [self.pullToRefreshView removeFromSuperview];
    self.pullToRefreshView = nil;
}

- (void)triggerPullToRefresh{
    [self.pullToRefreshView manuallyTriggered];
}

- (void)stopPullToRefreshAnimation{
    [self.pullToRefreshView stopIndicatorAnimation];
}

#pragma mark - property
- (void)setPullToRefreshView:(MWAnimatedGifActivityIndicator *)pullToRefreshView{
    [self willChangeValueForKey:@"MWAnimatedGifActivityIndicator"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"MWAnimatedGifActivityIndicator"];
}

- (MWAnimatedGifActivityIndicator *)pullToRefreshView{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh){
        if(!self.pullToRefreshView.isObserving){
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification
                                                       object:[UIDevice currentDevice]];
            
            self.pullToRefreshView.isObserving = YES;
        }
    } else {
        if(self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
            
            self.pullToRefreshView.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh{
    return !self.pullToRefreshView.hidden;
}

- (void)setPullToRefreshAlphaTransition:(BOOL)showAlphaTransition{
    self.pullToRefreshView.showAlphaTransition = showAlphaTransition;
}

- (BOOL)pullToRefreshAlphaTransition{
    return self.pullToRefreshView.showAlphaTransition;
}

- (void)setPullToRefreshShowVariableSize:(BOOL)showVariableSize{
    self.pullToRefreshView.isVariableSize = showVariableSize;
}

- (BOOL)pullToRefreshShowVariableSize{
    return self.pullToRefreshView.isVariableSize;
}
- (void)setPullToRefreshActivityIndcatorStyle:(UIActivityIndicatorViewStyle)activityIndcatorStyle{
    [self.pullToRefreshView setActivityIndicatorViewStyle:activityIndcatorStyle];
}

- (UIActivityIndicatorViewStyle)pullToRefreshActivityIndcatorStyle{
    return self.pullToRefreshView.activityIndicatorStyle;
}

- (void) orientationChanged:(NSNotification *)note{
    UIDevice * device = note.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pullToRefreshView orientationChange:device.orientation];
    });
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview == nil) {
        [self removePullToRefreshActionHandler];
    }
}

@end