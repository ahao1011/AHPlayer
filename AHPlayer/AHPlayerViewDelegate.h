//
//  AHPlayerViewDelegate.h
//  AHPlayer
//
//  Created by AH on 2017/6/22.
//  Copyright © 2017年 AH. All rights reserved.
//

#ifndef AHPlayerViewDelegate_h
#define AHPlayerViewDelegate_h


#endif /* AHPlayerViewDelegate_h */

@class AHPlayerView;
@class AHPlayerItem;

@protocol AHPlayerViewDelegate <NSObject>

@required
/**视频进度的更新 正常播放时 */
- (void)AH_PlayerCurrentime:(NSInteger)currentTime TotalTime:(NSInteger)totalTime Progress:(CGFloat)progress Item:(AHPlayerItem*)item PlayerView:(AHPlayerView*)playerview;
/**视频缓冲的进度*/
- (void)AH_PlayerCacheProgress:(CGFloat)progress Item:(AHPlayerItem*)item PlayerView:(AHPlayerView*)playerview;

/**视频被平移拖动时会调用这个方法 forawrd YES前进 NO后退*/
- (void)AH_PlayerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd haveThumbImg:(BOOL)haveThumbImg thumbImg:(UIImage*)thumbImg Item:(AHPlayerItem*)item PlayerView:(AHPlayerView*)playerview;

@optional

/**音量更改 */
- (void)AH_VolumeChange:(CGFloat)volumeValue Item:(AHPlayerItem*)item PlayerView:(AHPlayerView*)playerview;
/**亮度更改 */
- (void)AH_BrightnesChange:(CGFloat)brightnesValue Item:(AHPlayerItem*)item PlayerView:(AHPlayerView*)playerview;
/**视频播放状态改变  播放准备 播放失败 缓冲中 准备播放 播放中 播放暂停 播放结束 */
- (void)AH_PlayerStatusCHange:(NSString*)status Item:(AHPlayerItem*)item PlayerView:(AHPlayerView*)playerview;
/**水平移动结束时回调*/
- (void)AH_PlayerDraggedEnd;





@required

@end
