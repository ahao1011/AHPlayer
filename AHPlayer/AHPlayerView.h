//
//  AHPlayerView.h
//  AHPlayer
//
//  Created by AH on 2017/6/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHPlayerItem.h"
#import "AHPlayerStatus.h"
#import "AHPlayerViewDelegate.h"
#import "AHPlayerHeader.h"

/**水平移动*/
static NSString*const PanHorizontalScroll = @"PanHorizontalScroll";
/**垂直移动*/
static NSString*const PanVerticalMovement = @"PanVerticalMovement";


@interface AHPlayerView : UIView
/**代理*/
@property (nonatomic,weak)  id<AHPlayerViewDelegate> delegate;
/**视频模型*/
@property (nonatomic,strong) AHPlayerItem *item;
/**视频填充模式  AVLayerVideoGravityResize AVLayerVideoGravityResizeAspect AVLayerVideoGravityResizeAspectFill 随意写 会默认到AVLayerVideoGravityResizeAspect*/
@property (nonatomic,copy) NSString *videoGravity;
/**视频播放模式*/
@property (nonatomic,copy) NSString *playMode;

@property (nonatomic,assign) PlayerStatus playstatus;

@end
