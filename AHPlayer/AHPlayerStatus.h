//
//  AHPlayerStatus.h
//  AHPlayer
//
//  Created by AH on 2017/6/21.
//  Copyright © 2017年 AH. All rights reserved.
//





#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//  视频状态
/**播放准备*/
static NSString *const AHPlayerPrepare = @"AHPlayerPrepare";
/**即将播放*/
static NSString *const AHPlayerWillPlay =@"AHPlayerWillPlay";
/**缓冲中*/
static NSString *const AHPlayerBuffer = @"AHPlayerBuffer";
/**播放中*/
static NSString *const AHPlayerPlaying = @"AHPlayerPlaying";
/**播放暂停*/
static NSString *const AHPlayerPause = @"AHPlayerPause";
/**播放结束*/
static NSString *const AHPlayerEnd  = @"AHPlayerEnd ";
/**播放失败*/
static NSString *const AHPlayerFail = @"AHPlayerFail";

#warning  根据不同的模式   屏幕方向  布局要对应更改
//播放模式
/**cell上播放*/
static NSString *const AHPlayMode_Cell = @"AHPlayMode_Cell";
/**嵌入在vc中播放*/
static NSString *const AHPlayMode_VC = @"AHPlayMode_VC";
/**全屏 竖屏*/   //  友邻优课  
static NSString *const AHPlayMode_FullScreen_Vertical = @"AHPlayMode_FullScreen_vertical";
/**全屏 横屏*/
static NSString *const AHPlayMode_FullScreen_Level =  @"AHPlayMode_FullScreen_Level";


// 通知
@interface AHPlayerStatus : NSObject





+ (instancetype)defaultStatus;

/**视频播放器当前状态*/
@property (nonatomic,assign) NSString *playerStatus;
/**音量*/
@property (nonatomic,assign) CGFloat volumeValue;
/**亮度*/
@property (nonatomic,assign) CGFloat brightValue;
/**播放模式*/
@property (nonatomic,copy) NSString *playMode;
/**拖拽中的值*/
@property (nonatomic,assign) CGFloat draggedingValue;
/**拖拽结束时的值*/
@property (nonatomic,assign) CGFloat draggedendValue;
/**是否全屏*/
@property (nonatomic,assign,getter=fullScreen) BOOL  isFullScreen;
/**是否锁屏*/
@property (nonatomic,assign,getter=lockScreen) BOOL  isLockScreen;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否展示菊花 */
@property (nonatomic, assign) BOOL  Showactivity;




@end
