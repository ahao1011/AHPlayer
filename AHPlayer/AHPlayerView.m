//
//  AHPlayerView.m
//  AHPlayer
//
//  Created by AH on 2017/6/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#define WS(weakSelf) __weak typeof(&*self) weakSelf = self;

#import "AHPlayerView.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>
#import <Masonry.h>
#import "AHPlayerControView.h"
#import "ZFBrightnessView.h"
#import "AHPlayerStatus.h"


@interface AHPlayerView ()<UIGestureRecognizerDelegate>

/**播放layer*/
@property (nonatomic,strong)  AVPlayer *player;
/**视频资源*/
@property (nonatomic,strong) AVPlayerItem *playerItem;
/**url资源*/
@property (nonatomic,strong) AVURLAsset *urlAsset;
/**playerlayer*/
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
/**是否自动播放*/
@property (nonatomic,assign) BOOL isAutoplay;
@property (nonatomic,strong) id timeObserve;
/**移动方向*/
@property (nonatomic,copy) NSString *panType;
/**音量调节*/
@property (nonatomic,strong) UISlider *voiceSlider;
/**是否在进行音量调节*/
@property (nonatomic,assign) BOOL isVolume;
/**从多少秒处开始播放 切换分辨率 从后台被唤醒 切换程序 切换回来 */
@property (nonatomic, assign) NSInteger seekTime;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/**delegate集合*/
@property (nonatomic,strong) NSPointerArray *delegateArr;
/**亮度调节控件  TODO: 控制层结束后再完善该组件*/
@property (nonatomic,strong) ZFBrightnessView *brightnessView;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat  sliderLastValue;
/**视频帧*/
@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;

@end

@implementation AHPlayerView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self SetInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SetInitialize];
    }
    return self;
}
#pragma mark - 初始量设置

- (void)SetInitialize{
    
    self.isAutoplay = NO;
    self.backgroundColor = [UIColor blackColor];
    self.playMode = AHPlayMode_VC;
    [self ChandgePlayerStatus:AHPlayerPrepare];
    UIView *view  = [self delegateView];
    self.delegate = (id)view;
    [self.delegateArr addPointer:(__bridge void*)view];
    
}

- (void)setItem:(AHPlayerItem *)item{
    
    _item = item;
    
    [self SetUpPlayerLayer];
    [self AddNotifications];
    [self CreatTimer];
    [self GetSystemVoice];
    [self play];
}


- (void)SetUpPlayerLayer{
    
#warning 这里应该根据当前网络的具体情况 设置不同的视频源
    self.urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:_item.item_high_url]];
    self.playerItem = [[AVPlayerItem alloc]initWithAsset:self.urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.bounds = self.layer.bounds;
    [self.layer addSublayer:self.playerLayer];
    
}


- (void)CreatTimer{
    
    WS(weakself);
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        
        AVPlayerItem *currentItem = weakself.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count>0 && currentItem.duration.timescale!=0  ) {
            
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds(currentItem.currentTime);
            CGFloat totalTime = (CGFloat)currentItem.duration.value/currentItem.duration.timescale;
            CGFloat value = CMTimeGetSeconds(currentItem.currentTime)/totalTime;
            
            for (id delegate in weakself.delegateArr) {
                
                if ([delegate respondsToSelector:@selector(AH_PlayerCurrentime:TotalTime:Progress:Item:PlayerView:)]) {
                    
                    [delegate AH_PlayerCurrentime:currentTime TotalTime:totalTime Progress:value Item:weakself.item PlayerView:weakself];
                }
                
            }
        }
    }];
}

#pragma mark - 添加/移除  观察者  通知

- (void)AddNotifications{
  
#warning 这里需要监控  进入后台  进入前台 软件处于活跃状态了  该界面被压入栈 插入/拔出耳机的监控   来改变播放状态
    
#warning 播放完成的通知 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    
    if (_playerItem==playerItem) {
        return;
    }
    
    if (_playerItem) {
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [[AHPlayerStatus defaultStatus]removeObserver:self forKeyPath:@"playerStatus"];
        [[AHPlayerStatus defaultStatus]removeObserver:self forKeyPath:@"playMode"];
        [[AHPlayerStatus defaultStatus]removeObserver:self forKeyPath:@"dragged"];
        [[AHPlayerStatus defaultStatus]removeObserver:self forKeyPath:@"draggedingValue"];
        [[AHPlayerStatus defaultStatus]removeObserver:self forKeyPath:@"draggedendValue"];
    }
    _playerItem = playerItem;
    if (_playerItem) {
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        [[AHPlayerStatus defaultStatus] addObserver:self forKeyPath:@"playerStatus" options:NSKeyValueObservingOptionNew context:nil];
        [[AHPlayerStatus defaultStatus] addObserver:self forKeyPath:@"playMode" options:NSKeyValueObservingOptionNew context:nil];
        [[AHPlayerStatus defaultStatus] addObserver:self forKeyPath:@"dragged" options:NSKeyValueObservingOptionNew context:nil];
        [[AHPlayerStatus defaultStatus] addObserver:self forKeyPath:@"draggedingValue" options:NSKeyValueObservingOptionNew context:nil];
        [[AHPlayerStatus defaultStatus]addObserver:self forKeyPath:@"draggedendValue" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - 视频的一些操作

/**
 *  播放
 */
- (void)play {
    
    if ([AHPlayerStatus defaultStatus].playerStatus==AHPlayerPause) {
        [self ChandgePlayerStatus:AHPlayerPlaying];
    }
    [_player play];
}

/**
 * 暂停
 */
- (void)pause {
    if ([AHPlayerStatus defaultStatus].playerStatus==AHPlayerPlaying) {
        [self ChandgePlayerStatus:AHPlayerPause];
    }
    [_player pause];
}
#warning 这里在结束后 要做一些操作  比如 中间按钮的更新 双击不再响应  下一个资源的预加载(若有)
//  播放结束后的一些操作
- (void)VideoDidPlayToEnd{
    
    
}

#pragma mark - 获取系统音量

- (void)GetSystemVoice{
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    _voiceSlider = nil;
    for (UIView *view in volumeView.subviews) {
        
        _voiceSlider = (UISlider*)view;
        break;
    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object==self.player.currentItem) {
        
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status==AVPlayerItemStatusReadyToPlay) {
#warning 这里可能做了一些布局的调整
                NSLog(@"播放准备就绪");
                [self ChandgePlayerStatus:AHPlayerPlaying];
                [self.layer insertSublayer:self.playerLayer atIndex:0];
                // 只有在马上播放时才能添加平移手势控制 音量 亮度 进度
                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
                panRecognizer.delegate = self;
                [panRecognizer setMaximumNumberOfTouches:1];
                [panRecognizer setDelaysTouchesBegan:YES];
                [panRecognizer setDelaysTouchesEnded:YES];
                [panRecognizer setCancelsTouchesInView:YES];
                [self addGestureRecognizer:panRecognizer];
                
                [self.brightnessView removeFromSuperview];
                [[UIApplication sharedApplication].keyWindow addSubview:self.brightnessView];
                [self.brightnessView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo([UIApplication sharedApplication].keyWindow);
                    make.width.height.mas_equalTo(155);
                }];
                if (self.seekTime) {
                     // 跳转到xx秒播放
                    [self SkipTime:self.seekTime ComHandle:^(BOOL finished) {
                        
                    }];
                }
                
            }
            else if (self.player.currentItem.status==AVPlayerStatusFailed){
                
                [self ChandgePlayerStatus:AHPlayerFail];
            }
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){  // 缓冲
            
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration =  self.playerItem.duration;
            CGFloat totalDuration = CMTimeGetSeconds(duration);
            CGFloat progress = timeInterval/totalDuration;
            for (id delegate in self.delegateArr) {
                
                if ([delegate respondsToSelector:@selector(AH_PlayerCacheProgress:Item:PlayerView:)]) {
                    
                    [delegate AH_PlayerCacheProgress:progress Item:self.item PlayerView:self];
                }
            }
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
            
            if (self.playerItem.playbackBufferEmpty) { // 没有缓存了
                
                [AHPlayerStatus defaultStatus].playerStatus = AHPlayerBuffer;
                
#warning  这里需要暂停下 转圈展示  缓存一定程度再继续播放
            }
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
            
            // 缓存好了
            if (self.playerItem.playbackLikelyToKeepUp && [AHPlayerStatus defaultStatus].playerStatus==AHPlayerBuffer) {
                
                [AHPlayerStatus defaultStatus].playerStatus = AHPlayerPlaying;
            }
        }
    }else if (object==[AHPlayerStatus defaultStatus]){
        
        
        if ([keyPath isEqualToString:@"playerStatus"]) {
            
            if ([AHPlayerStatus defaultStatus].playerStatus==AHPlayerPause) {
                
                [self pause];
            }
            
            if ([AHPlayerStatus defaultStatus].playerStatus==AHPlayerPlaying) {
                
                [self play];
            }
        }else if ([keyPath isEqualToString:@"draggedingValue"]){
            //
            CGFloat slidervalue = [AHPlayerStatus defaultStatus].draggedingValue;
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                
                BOOL style = false;
                CGFloat value   = slidervalue - self.sliderLastValue;
                if (value > 0) { style = YES; }
                if (value < 0) { style = NO; }
                if (value == 0) { return; }
                
                self.sliderLastValue  = slidervalue;
                
                CGFloat totalTime     = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
                CGFloat dragedSeconds = floorf(totalTime * value);
                //转换成CMTime才能给player来控制播放进度
                CMTime dragedCMTime   = CMTimeMake(dragedSeconds, 1);
                for (id delegate in self.delegateArr) {
                    
                    if ([delegate respondsToSelector:@selector(AH_PlayerDraggedTime:totalTime:isForward:haveThumbImg:thumbImg:Item:PlayerView:)]) {
                        
                        [delegate AH_PlayerDraggedTime:dragedSeconds totalTime:totalTime isForward:style haveThumbImg:YES thumbImg:nil Item:self.item PlayerView:self];
                    }
                }
                if (totalTime > 0) {
                        
                        [self.imageGenerator cancelAllCGImageGeneration];
                        self.imageGenerator.appliesPreferredTrackTransform = YES;
                        self.imageGenerator.maximumSize = CGSizeMake(100, 56);
                        AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                            NSLog(@"帧图片%zd",result);
                            UIImage *thumbImg = nil;
                            if (result == AVAssetImageGeneratorSucceeded) {
                                thumbImg = [UIImage imageWithCGImage:im];
                            }
                            for (id delegate in self.delegateArr) {
                                
                                if ([delegate respondsToSelector:@selector(AH_PlayerDraggedTime:totalTime:isForward:haveThumbImg:thumbImg:Item:PlayerView:)]) {
                                    
                                    [delegate AH_PlayerDraggedTime:dragedSeconds totalTime:totalTime isForward:style haveThumbImg:YES thumbImg:thumbImg Item:self.item PlayerView:self];
                                }
                            }
                            
                        };
                        [self.imageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:dragedCMTime]] completionHandler:handler];
                    
                } else {
                    
                }
                
            }else {
#warning 这里可以对slider的一些细节要优化 暂无时间
            }

        }else if ([keyPath isEqualToString:@"draggedendValue"]){
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                // 视频总时间长度
                CGFloat slidervalue = [AHPlayerStatus defaultStatus].draggedendValue;
                CGFloat total  = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
                //计算出拖动的当前秒数
                NSInteger dragedSeconds = floorf(total * slidervalue);
                [self SkipTime:dragedSeconds ComHandle:nil];
            }
        }
    }
    
}
#pragma mark - 平移手势的处理
- (void)pan:(UIPanGestureRecognizer*)pan{
    
    if ([AHPlayerStatus defaultStatus].isLockScreen) {
        
        return;
    }
    
    CGPoint localtionPoint = [pan locationInView:self];
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    if (pan.state==UIGestureRecognizerStateBegan) {
        
        CGFloat x = fabs(veloctyPoint.x);
        CGFloat y = fabs(veloctyPoint.y);
        if (x>y) { // 水平移动
            
            self.panType = PanHorizontalScroll;
            CMTime time = self.player.currentTime;
            self.sumTime = time.value/time.timescale;
#warning 这里不用吧快进的进度传递出去吗
        }else if (x<y){  // 垂直移动
            
            self.panType=PanVerticalMovement;
            if (localtionPoint.x > self.bounds.size.width*0.5) {
                
                self.isVolume = YES;
                NSLog(@"进行音量调节");
            }else{
                self.isVolume = NO;
                NSLog(@"进行亮度调节");
            }
        }
        
    }
    else if (pan.state==UIGestureRecognizerStateChanged){  // 正在移动
        
        if ([self.panType isEqualToString:PanHorizontalScroll]) {  // 水平
            
            
            [self horizontalMoved:veloctyPoint.x];
            
        }else{
            
            [self verticalMoved:veloctyPoint.y];
        }
        
    }
    else if (pan.state==UIGestureRecognizerStateEnded){
        
        if (self.panType==PanHorizontalScroll) {
            
            [self SkipTime:self.sumTime ComHandle:^(BOOL finished) {
                
            }];
            self.sumTime=0;
            
        }else{
            
            
        }
    }
}
- (void)verticalMoved:(CGFloat)value {
    
    if ([AHPlayerStatus defaultStatus].isLockScreen) {
        
        return;
    }
    
    self.isVolume ? (self.voiceSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
    
    if (self.isVolume) {
        
        for (id delegate in self.delegateArr) {
            
            if ([delegate respondsToSelector:@selector(AH_VolumeChange:Item:PlayerView:)]) {
                
                [delegate AH_VolumeChange:self.voiceSlider.value Item:self.item PlayerView:self];
            }
        }
        
    }else{
        for (id delegate in self.delegateArr) {
            
            if ([delegate respondsToSelector:@selector(AH_BrightnesChange:Item:PlayerView:)]) {
                
                [delegate AH_BrightnesChange:[UIScreen mainScreen].brightness Item:self.item PlayerView:self];
            }
        }
    }
}

- (void)horizontalMoved:(CGFloat)value {
    
    if (![AHPlayerStatus defaultStatus].isLockScreen) {
        
        // 每次滑动需要叠加时间
        self.sumTime += value / 200;
        
        // 需要限定sumTime的范围
        CMTime totalTime           = self.playerItem.duration;
        CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
        if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
        if (self.sumTime < 0) { self.sumTime = 0; }
        
        BOOL style = false;
        if (value > 0) { style = YES; }
        if (value < 0) { style = NO; }
        if (value == 0) { return; }
        
        for (id delegate in self.delegateArr) {
            
            if ([delegate respondsToSelector:@selector(AH_PlayerDraggedTime:totalTime:isForward:haveThumbImg:thumbImg:Item:PlayerView:)]) {
                
                [delegate AH_PlayerDraggedTime:self.sumTime totalTime:totalMovieDuration isForward:style haveThumbImg:NO thumbImg:nil Item:self.item PlayerView:self];
            }
        }
    }
    
    
}
#pragma mark - 视频的一些处理

/** 跳转到xx秒继续播放 */
- (void)SkipTime:(NSInteger)SkipTime ComHandle:(void(^)(BOOL finished))ComHandle{
    
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        [AHPlayerStatus defaultStatus].Showactivity = YES;
        [AHPlayerStatus defaultStatus].playerStatus=AHPlayerBuffer;
        [self.player pause];
        CMTime dragedCMTime = CMTimeMake(SkipTime, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
            [AHPlayerStatus defaultStatus].Showactivity = NO;
            [AHPlayerStatus defaultStatus].playerStatus=AHPlayerPlaying;
            // 视频跳转回调
            if (ComHandle) { ComHandle(finished); }
            [weakSelf.player play];
            weakSelf.seekTime = 0;
            for (id delegate in self.delegateArr) {
                
                if ([delegate respondsToSelector:@selector(AH_PlayerDraggedEnd)]) {
                    
                    [delegate AH_PlayerDraggedEnd];
                }
            }
            
        }];
    }
}
#pragma mark - SET GET方法
- (AVAssetImageGenerator *)imageGenerator {
    if (!_imageGenerator) {
        _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.urlAsset];
    }
    return _imageGenerator;
}
- (ZFBrightnessView *)brightnessView{
    if (_brightnessView==nil) {
        _brightnessView = [ZFBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

- (void)setVideoGravity:(NSString *)videoGravity{
    
    _videoGravity = videoGravity;
    
    if (self.playerLayer) {
        
        if ([videoGravity isEqualToString:AVLayerVideoGravityResize]||
            [videoGravity isEqualToString:AVLayerVideoGravityResizeAspect]||
            [videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]
            ) {
            
            self.playerLayer.videoGravity = videoGravity;
        }else{
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
    }
}
- (void)setPlayMode:(NSString *)playMode{
    
    _playMode = playMode;
    [AHPlayerStatus defaultStatus].playMode = playMode;
}

- (NSPointerArray *)delegateArr{
    if (!_delegateArr) {
        _delegateArr = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegateArr;
}
- (void)setDelegate:(id<AHPlayerViewDelegate>)delegate{
    
    if (delegate) {
        
        [self.delegateArr addPointer:(__bridge void*)delegate];
    }
}


#pragma mark - 进度 时间的一些计算

/**计算缓冲进度*/
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - 布局相关

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    
}

#pragma mark -视图销毁

- (void)dealloc {
    self.playerItem = nil;
//    self.scrollView  = nil;
//    ZFPlayerShared.isLockScreen = NO;
//    [self.controlView zf_playerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // 移除time观察者
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
}

#pragma mark - 其他

- (UIView*)delegateView{
    
    Class classname = NSClassFromString(@"AHPlayerControView");
    if (classname!=nil) {
        UIView *view = [[classname alloc]init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
            make.top.left.bottom.right.mas_equalTo(0);
        }];
        return view;
    }else{
        return nil;
    }
}

- (void)ChandgePlayerStatus:(NSString*)status{
    
    [AHPlayerStatus defaultStatus].playerStatus=status;
    for (id delegate in self.delegateArr) {
        
        if ([delegate respondsToSelector:@selector(AH_PlayerStatusCHange:Item:PlayerView:)]) {
            [delegate AH_PlayerStatusCHange:status Item:self.item PlayerView:self];
        }
    }
}
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            [self play];
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            
            [self pause];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}









@end
