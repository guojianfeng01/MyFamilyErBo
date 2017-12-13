//
//  MWAnimatedGifActivityIndicator.m
//  Pods
//
//  Created by liu nian on 4/6/16.
//
//

#import "MWAnimatedGifActivityIndicator.h"
#import "UIScrollView+MWPullToRefresh.h"
#import "MWAnimatedGifPullToRefreshConfiguration.h"

#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0
#define cDefaultFloatComparisonEpsilon    0.001
#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define cNotEqualFloats(f1, f2, epsilon)    ( !cEqualFloats(f1, f2, epsilon) )

@interface MWAnimatedGifActivityIndicator ()
@property (nonatomic,strong) UIImageView *imageViewProgress;
@property (nonatomic,strong) UIImageView *imageViewLoading;

@property (nonatomic,strong) NSArray *imagesProgress;
@property (nonatomic,strong) NSArray *imagesLoading;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;  //Loading Indicator
@property (nonatomic, assign) double progress;
@property (nonatomic, assign) NSInteger progressThreshold;
@property (nonatomic, assign) NSInteger loadingFrameRate;
- (void)_commonInit;
- (void)_initAnimationView;
@end

@implementation MWAnimatedGifActivityIndicator

- (void)dealloc{
    _imageViewLoading = nil;
    _imageViewProgress = nil;
    _imagesLoading = nil;
    _imagesProgress = nil;
    _activityIndicatorView = nil;
    
}

- (id)initWithProgressImages:(NSArray *)progressImg
               loadingImages:(NSArray *)loadingImages
     progressScrollThreshold:(NSInteger)threshold
      loadingImagesFrameRate:(NSInteger)lFrameRate{
    if(threshold <=0){
        threshold = initialPulltoRefreshThreshold;
    }
    UIImage *image1 = progressImg.firstObject;
    self = [super initWithFrame:CGRectMake(0, -image1.size.height, image1.size.width, image1.size.height)];
    if(self) {
        self.imagesProgress = progressImg;
        self.imagesLoading = loadingImages;
        self.progressThreshold = threshold;
        self.loadingFrameRate = lFrameRate;
        [self _commonInit];
    }
    return self;
}


- (void)_commonInit{
    self.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
    self.state = MWGIFPullToRefreshStateNone;
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0f;
    
    NSAssert([self.imagesProgress.lastObject isKindOfClass:[UIImage class]], @"imagesProgress Array has object that is not image");
    self.imageViewProgress.image = [self.imagesProgress lastObject];
    
    if(self.imagesLoading == nil){
        self.activityIndicatorView.activityIndicatorViewStyle = self.activityIndicatorStyle;
    } else {
        NSAssert([self.imagesLoading.lastObject isKindOfClass:[UIImage class]], @"imagesLoading Array has object that is not image");
        self.imageViewLoading.image = [self.imagesLoading firstObject];
        self.imageViewLoading.animationImages = self.imagesLoading;
        self.imageViewLoading.animationDuration = (CGFloat)ceilf((1.0/(self.loadingFrameRate) * self.imageViewLoading.animationImages.count));
    }
    
    [self actionStopState];
}

- (void)_initAnimationView {
    
    if(self.imagesLoading.count > 0) {
        [self.imageViewLoading stopAnimating];
        self.imageViewLoading.alpha = 0.0f;
        
    } else {
        self.activityIndicatorView.transform = CGAffineTransformIdentity;
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.alpha = 0.0f;
    }
    //    self.alpha = 0.0f;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}


#pragma mark - ScrollViewInset
- (void)setupScrollViewContentInsetForLoadingIndicator:(actionHandler)handler animation:(BOOL)animation{
    
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    float idealOffset = self.originalTopInset + self.bounds.size.height + 20.0;
    currentInsets.top = idealOffset;

    [self setScrollViewContentInset:currentInsets handler:handler animation:animation];
}
- (void)resetScrollViewContentInset:(actionHandler)handler animation:(BOOL)animation {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets handler:handler animation:animation];
}
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset handler:(actionHandler)handler animation:(BOOL)animation {
    //    NSLog(@"offset %f",self.scrollView.contentOffset.y);
    if(animation) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.scrollView.contentInset = contentInset;
                             if(self.state == MWGIFPullToRefreshStateLoading && self.scrollView.contentOffset.y <10) {
                                 self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -1*contentInset.top);
                             }
                         }
                         completion:^(BOOL finished) {
                             if(handler)
                                 handler();
                         }];
    } else {
        self.scrollView.contentInset = contentInset;
        
        if(self.state == MWGIFPullToRefreshStateLoading && self.scrollView.contentOffset.y <10) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -1*contentInset.top);
        }
        
        if(handler)
            handler();
    }
}
#pragma mark - property
- (void)setProgress:(double)progress{
    static double prevProgress;
    if(progress > 1.0) {
        progress = 1.0;
    }
    if(self.showAlphaTransition){
        if(self.state < MWGIFPullToRefreshStateTriggered)
            self.alpha = 1.0 * progress;
        else
            self.alpha = 1.0;
    } else {
        CGFloat alphaValue = 1.0 * progress *5;
        if(alphaValue > 1.0)
            alphaValue = 1.0f;
        self.alpha = alphaValue;
        
    }
    if (progress >= 0.0f && progress <=1.0f) {
        //Animation
        NSInteger index = (NSInteger)roundf((self.imagesProgress.count ) * progress);
        if(index ==0) {
            self.imageViewProgress.image = nil;
        } else {
            self.imageViewProgress.image = [self.imagesProgress objectAtIndex:index-1];
        }
    }
    _progress = progress;
    prevProgress = progress;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"contentOffset"]){
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    } else if([keyPath isEqualToString:@"contentSize"]) {
        [self setNeedsLayout];
        [self setNeedsDisplay];
        self.center = CGPointMake(self.scrollView.center.x, self.center.y);
    } else if([keyPath isEqualToString:@"frame"]) {
        [self setFrameSizeByProgressImage];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}
- (void)scrollViewDidScroll:(CGPoint)contentOffset{
    static double prevProgress;
    CGFloat yOffset = contentOffset.y;
    self.progress = ((yOffset+ self.originalTopInset + StartPosition)/(-self.progressThreshold ));
    self.center = CGPointMake(self.scrollView.center.x, (contentOffset.y+ self.originalTopInset)/2);
    
    switch (_state) {
        case MWGIFPullToRefreshStateStopped: //finish (1)
            break;
        case MWGIFPullToRefreshStateNone: //detect action (0)
        {
            if(self.scrollView.isDragging && yOffset < 0.0f )
            {
                self.imageViewProgress.alpha = 1.0f;
                [self setFrameSizeByProgressImage];
                self.state = MWGIFPullToRefreshStateTriggering;
            }
        }
            break;
        case MWGIFPullToRefreshStateTriggering: //progress (2)
        {
            if(self.progress >= 1.0f)
                self.state = MWGIFPullToRefreshStateTriggered;
        }
            break;
        case MWGIFPullToRefreshStateTriggered: //fire actionhandler (3)
            if(self.scrollView.isDragging == NO && prevProgress > 0.98f)
            {
                [self actionTriggeredState];
            }
            break;
        case MWGIFPullToRefreshStateLoading: //wait until stopIndicatorAnimation (4)
            break;
        case MWGIFPullToRefreshStateCanFinish: //(5)
            if(self.progress < 0.01f + ((CGFloat)StartPosition/-self.progressThreshold) && self.progress > -0.01f +((CGFloat)StartPosition/-self.progressThreshold))
            {
                self.state = MWGIFPullToRefreshStateNone;
            }
            break;
        default:
            break;
    }
    //because of iOS6 KVO performance
    prevProgress = self.progress;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showPullToRefresh) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)actionStopState{
    self.state = MWGIFPullToRefreshStateCanFinish;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        if(self.imagesLoading.count > 0){
        }else{
            self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
    } completion:^(BOOL finished) {
        
    }];
    
    [self resetScrollViewContentInset:^{
    } animation:YES];
    
    [self _initAnimationView];
}
- (void)actionTriggeredState{
    self.state = MWGIFPullToRefreshStateLoading;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.imageViewProgress.alpha = 0.0f;
        //        NSLog(@"state : %d",self.isVariableSize);
        
        if(self.isVariableSize){
            [self setFrameSizeByLoadingImage];
        }
        if(self.imagesLoading.count>0){
            self.imageViewLoading.alpha = 1.0f;
        }else{
            self.activityIndicatorView.alpha = 1.0f;
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    if(self.imagesLoading.count>0){
        [self.imageViewLoading startAnimating];
    }else{
        [self.activityIndicatorView startAnimating];
    }
    
    [self setupScrollViewContentInsetForLoadingIndicator:^{
        
    } animation:YES];
    
    if(self.pullToRefreshHandler)
        self.pullToRefreshHandler();
    
    
    
}
- (void)setFrameSizeByProgressImage{
    UIImage *image1 = self.imagesProgress.lastObject;
    if(image1)
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
}
- (void)setFrameSizeByLoadingImage{
    UIImage *image1 = self.imagesLoading.lastObject;
    if(image1){
        self.frame = CGRectMake((self.scrollView.bounds.size.width - image1.size.width)/2, -image1.size.height, image1.size.width, image1.size.height);
    }
}
- (void)orientationChange:(UIDeviceOrientation)orientation {
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if((NSInteger)deviceOrientation !=(NSInteger)statusBarOrientation){
        return;
    }
    
    if(UIDeviceOrientationIsLandscape(orientation)){
        if(cNotEqualFloats( self.landscapeTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
            self.originalTopInset = self.landscapeTopInset;
    }else{
        if(cNotEqualFloats( self.portraitTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
            self.originalTopInset = self.portraitTopInset;
    }
    
    if(self.state == MWGIFPullToRefreshStateLoading){
        if( self.isVariableSize ) {
            [self setFrameSizeByLoadingImage];
            
        } else {
            [self setFrameSizeByProgressImage];
        }
        [self setupScrollViewContentInsetForLoadingIndicator:^{
            
        } animation:NO];
    }else{
        [self setFrameSizeByProgressImage];
        [self resetScrollViewContentInset:^{
            
        } animation:NO];
    }
    self.alpha = 1.0f;
}

#pragma mark - public method
- (void)stopIndicatorAnimation{
    [self actionStopState];
}

- (void)manuallyTriggered{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height + 20.0f;
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -currentInsets.top);
    } completion:^(BOOL finished) {
        [self actionTriggeredState];
    }];
}
- (void)setSize:(CGSize) size{
    CGRect rect = CGRectMake((self.scrollView.bounds.size.width - size.width)/2,
                             -size.height,
                             size.width,
                             size.height);
    self.frame = rect;
    _activityIndicatorView.frame = self.bounds;
    _imageViewProgress.frame = self.bounds;
    _imageViewLoading.frame = self.bounds;
}
- (void)setIsVariableSize:(BOOL)isVariableSize{
    _isVariableSize = isVariableSize;
    if(!_isVariableSize){
        [self setFrameSizeByProgressImage];
    }
}
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    if(_activityIndicatorView){
        _activityIndicatorStyle = style;
        [_activityIndicatorView removeFromSuperview];
        self.activityIndicatorView.activityIndicatorViewStyle = _activityIndicatorStyle;
        [self insertSubview:self.activityIndicatorView belowSubview:self.imageViewProgress];
    }
}
#pragma mark - getter
- (UIImageView *)imageViewProgress{
    if (!_imageViewProgress) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:imageView];
        _imageViewProgress = imageView;
    }
    return _imageViewProgress;
}

- (UIImageView *)imageViewLoading{
    if (!_imageViewLoading) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        imageView.alpha = 0.0f;
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        _imageViewLoading = imageView;
    }
    return _imageViewLoading;
}

- (UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

@end
