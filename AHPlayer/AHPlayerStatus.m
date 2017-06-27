//
//  AHPlayerStatus.m
//  AHPlayer
//
//  Created by AH on 2017/6/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPlayerStatus.h"

@implementation AHPlayerStatus

+ (instancetype)defaultStatus{
    
    static AHPlayerStatus *Status= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Status = [[AHPlayerStatus alloc]init];
        Status.playerStatus = AHPlayerPrepare;
        Status.playMode = AHPlayMode_VC;
    });
    return Status;
}

- (void)setPlayerStatus:(NSString *)playerStatus{
    
    _playerStatus = playerStatus;
#warning 这里要展示系统小菊花之类的
}

@end
