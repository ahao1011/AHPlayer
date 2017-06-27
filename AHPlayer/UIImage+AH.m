//
//  UIImage+AH.m
//  AHPlayer
//
//  Created by AH on 2017/6/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "UIImage+AH.h"

@implementation UIImage (AH)

+ (UIImage *)BundleSourceName:(NSString *)name{
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"AHPlayer.bundle/icon/%@",name]];
}

@end
