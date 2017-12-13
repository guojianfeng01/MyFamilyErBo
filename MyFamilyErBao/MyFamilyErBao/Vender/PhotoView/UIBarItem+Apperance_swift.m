//
//  UIBarItem+Apperance_swift.m
//  MyFamilyErBao
//
//  Created by guojianfeng on 2017/11/15.
//  Copyright © 2017年 guojianfeng. All rights reserved.
//

#import "UIBarItem+Apperance_swift.h"

@implementation UIBarItem (Apperance_swift)

+ (instancetype)aw_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass{
    return [self appearanceWhenContainedInInstancesOfClasses:@[containerClass]];
}

@end
