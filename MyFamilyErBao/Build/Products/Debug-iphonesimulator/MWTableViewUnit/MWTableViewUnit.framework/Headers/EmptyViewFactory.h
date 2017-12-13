//
//  OFFemptyFactory.h
//  51offer
//
//  Created by XcodeYang on 12/3/15.
//  Copyright © 2015 51offer. All rights reserved.
//

#import "FORScrollViewEmptyAssistant.h"

@interface EmptyViewFactory : NSObject

+ (void)emptyMainView:(UIScrollView *)scrollView
        configerBlock:(void (^)(FOREmptyAssistantConfiger *configer))configerBlock
             btnTitle:(NSString *)btnTitle
             btnBlock:(void(^)())btnBlock;
@end
