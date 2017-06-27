//
//  AHPlayerControView.m
//  AHPlayer
//
//  Created by AH on 2017/6/21.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "AHPlayerControView.h"
#import "AHPlayerViewDelegate.h"
#import "ASValueTrackingSlider.h"
#import "UIImage+AH.h"
#import "AHPlayerStatus.h"
#import "MMMaterialDesignSpinner.h"
#import "AHPlayerHeader.h"
#import <Masonry.h>
#import "AHPlayerStatus.h"

@interface AHPlayerControView ()<AHPlayerViewDelegate,UIGestureRecognizerDelegate>

/**标题*/
@property (nonatomic,strong) UILabel *titleLable;
/**屏幕中间的播放按钮*/
@property (nonatomic,strong) UIButton *playBtn;
/**当前时长*/
@property (nonatomic,strong) UILabel *currentTimeLabel;
/**总时长*/
@property (nonatomic,strong) UILabel *totalTimeLabel;
/**缓冲进度*/
@property (nonatomic,strong) UIProgressView *progressView;
/**滑杆*/
@property (nonatomic,strong) ASValueTrackingSlider *slider;
/**分辨率*/
@property (nonatomic,strong) UIButton *resolutionBtn;
/**是否全屏按钮*/
@property (nonatomic,strong) UIButton *fullScreenBtn;
/**音频模式*/
@property (nonatomic,strong) UIButton *vioceModelBtn;
/**开始/暂停按钮*/
@property (nonatomic,strong) UIButton *startBtn;
/**返回按钮*/
@property (nonatomic,strong) UIButton *backBtn;
/**顶部背景*/
@property (nonatomic,strong) UIImageView *topImgView;
/**底部背景*/
@property (nonatomic,strong) UIImageView *bottomImgView;
/**下载按钮*/
@property (nonatomic,strong) UIButton *downedBtn;
/**更多按钮*/
@property (nonatomic,strong) UIButton *moreBtn;
/**锁屏按钮*/
@property (nonatomic,strong) UIButton *lockScreenBtn;
/**占位图*/
@property (nonatomic,strong) UIImageView *placeImg;
/**菊花*/
@property (nonatomic,strong) MMMaterialDesignSpinner *activity;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 显示控制层 */
@property (nonatomic, assign) BOOL  showing;

#warning 快进快退的指示view 待封装
/** 快进快退View*/
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress*/
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间*/
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView*/
@property (nonatomic, strong) UIImageView             *fastImageView;


@end

@implementation AHPlayerControView

- (void)SetInitialize{
    
    //  返回按钮 中间播放状态按钮 锁屏按钮
    [self addSubview:self.placeImg];
    [self addSubview:self.backBtn];
    [self addSubview:self.lockScreenBtn];
    [self addSubview:self.playBtn];
    [self addSubview:self.activity];
    
    [self addSubview:self.topImgView];
    [self addSubview:self.bottomImgView];
    [self addSubview:self.fastView];
    
    [self.topImgView addSubview:self.titleLable];
    [self.topImgView addSubview:self.downedBtn];
    [self.topImgView addSubview:self.moreBtn];
    
    [self.bottomImgView addSubview:self.startBtn];
    [self.bottomImgView addSubview:self.currentTimeLabel];
    [self.bottomImgView addSubview:self.progressView];
    [self.bottomImgView addSubview:self.slider];
    [self.bottomImgView addSubview:self.totalTimeLabel];
    [self.bottomImgView addSubview:self.fullScreenBtn];
    
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];
    
    
    [self.placeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.top.mas_equalTo(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.lockScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(32);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.mas_equalTo(self);
        
    }];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(45);
    }];
    
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(self.backBtn.mas_trailing).with.offset(4);
        make.trailing.mas_equalTo(self.downedBtn.mas_leading).with.offset(-10);
        make.top.mas_equalTo(23);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.leading.equalTo(self.downedBtn.mas_trailing).offset(5);
        make.trailing.mas_equalTo(-5);
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
    
    [self.downedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLable.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.moreBtn.mas_leading).with.offset(5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.centerY.equalTo(self.titleLable.mas_centerY);
    }];
    
    
    [self.bottomImgView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.bottomImgView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImgView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(50);
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(36);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImgView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(30);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
    
    [self CreateGesture];
    [self AddKVO];
    self.showing = NO;
    self.clipsToBounds = YES;
    self.fastView.hidden = YES;
    
}

- (void)AddKVO{
    
    [[AHPlayerStatus defaultStatus]addObserver:self forKeyPath:@"Showactivity" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (object== [AHPlayerStatus defaultStatus]) {
        
        if ([keyPath isEqualToString:@"Showactivity"]) {
            
            [self Showactivity:[AHPlayerStatus defaultStatus].Showactivity];
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self SetInitialize];
    }
    return self;
}

- (void)CreateGesture{
    
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
}
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    
    self.showing = !self.showing;
    
    if (self.showing) {
        
        [self CancelAutoFadeOutControlView];
    }
}


- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    
    if ([AHPlayerStatus defaultStatus].isLockScreen) {
        
        return;
    }

    if ([AHPlayerStatus defaultStatus].playerStatus == AHPlayerEnd ||
        [AHPlayerStatus defaultStatus].playerStatus == AHPlayerFail||
        [AHPlayerStatus defaultStatus].playerStatus == AHPlayerWillPlay
        ) {
        return;
    }
    
    if ([AHPlayerStatus defaultStatus].playerStatus==AHPlayerPause) {
        
        [AHPlayerStatus defaultStatus].playerStatus=AHPlayerPlaying;
    }else{
         [AHPlayerStatus defaultStatus].playerStatus=AHPlayerPause;
    }
    self.startBtn.selected = !self.startBtn.selected;
    

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGRect rect = [self thumbRect];
    CGPoint point = [touch locationInView:self.slider];
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        if (point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x) { return NO; }
    }
    return YES;
}
- (void)updateConstraints{
    
    if (self.showing) {  // 展示控制层
        
        [self.lockScreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
        }];
        if (!self.lockScreenBtn.selected) {
            
            [self.topImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
            [self.bottomImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }
        
    }else{  // 隐藏控制层
        [self.lockScreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-32);
        }];
        [self.topImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-50);
        }];
        [self.bottomImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(50);
        }];
    }
    
    [super updateConstraints];
}

/**显示控制层*/
- (void)showControView{
    
}
- (void)CancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - SET GET
- (void)setShowing:(BOOL)showing{
    
    _showing = showing;
    [self setNeedsUpdateConstraints];
    
    //    // 调用此方法告诉self.view 检测是否需要更新约束,若需要更新,下面添加动画效果
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (_showing) {
            
            [self performSelector:@selector(setShowing:) withObject:@(NO) afterDelay:3];
        }
    }];
}
- (UIButton *)backBtn{
    if (_backBtn==nil) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[UIImage BundleSourceName:[AHPlayerStatus defaultStatus].playMode==AHPlayMode_Cell?@"ZFPlayer_close":@"ZFPlayer_back_full"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.contentMode = UIViewContentModeCenter;
    }
    return _backBtn;
}
- (UIButton *)lockScreenBtn{
    if (_lockScreenBtn==nil) {
        _lockScreenBtn = [[UIButton alloc]init];
        [_lockScreenBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_unlock-nor"] forState:UIControlStateNormal];
        [_lockScreenBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_lock-nor"] forState:UIControlStateSelected];
        [_lockScreenBtn addTarget:self action:@selector(lockScreen) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockScreenBtn;
}
- (UIButton *)playBtn{
    if (_playBtn==nil) {
        _playBtn = [[UIButton alloc]init];
        [_playBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_play_btn"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(centerPlayBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIImageView *)topImgView{
    if (_topImgView==nil) {
        _topImgView = [[UIImageView alloc]init];
        _topImgView.userInteractionEnabled = YES;
        _topImgView.alpha = 1;
        _topImgView.image = [UIImage BundleSourceName:@"ZFPlayer_top_shadow"];
    }
    return _topImgView;
}
- (UIImageView *)bottomImgView{
    if (_bottomImgView==nil) {
        _bottomImgView = [[UIImageView alloc]init];
        _bottomImgView.userInteractionEnabled = YES;
        _bottomImgView.alpha = 1;  //ZFPlayer_bottom_shadow
        _bottomImgView.image = [UIImage BundleSourceName:@"ZFPlayer_bottom_shadow"];
    }
    return _bottomImgView;
}
-(UIImageView *)placeImg{
    if (_placeImg==nil) {
        _placeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_bgView"]];
        _placeImg.userInteractionEnabled = YES;
        _placeImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _placeImg;
}
- (MMMaterialDesignSpinner *)activity{
    if (_activity==nil) {
        _activity = [[MMMaterialDesignSpinner alloc]init];
        _activity.lineWidth = 1;
        _activity.duration = 1;
        _activity.tintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    }
    return _activity;
}
- (UILabel *)titleLable{
    if (_titleLable==nil) {
        
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.text = @"这是一段测试";
        _titleLable.font =[UIFont systemFontOfSize:12.0];
    }
    return _titleLable;
}
- (UIButton *)downedBtn{
    if (_downedBtn==nil) {
        _downedBtn = [[UIButton alloc]init];
        _downedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_downedBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_download"] forState:UIControlStateNormal];
        [_downedBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downedBtn;
}
- (UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_play"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_pause"] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}
- (UILabel *)currentTimeLabel{
    if (_currentTimeLabel==nil) {
        _currentTimeLabel = [[UILabel alloc]init];
        _currentTimeLabel.textColor= [UIColor whiteColor];
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
- (UIProgressView *)progressView{
    if (_progressView==nil) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:0];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}
- (ASValueTrackingSlider *)slider{
    if (_slider==nil) {
        _slider = [[ASValueTrackingSlider alloc]init];
        _slider.popUpViewCornerRadius = 0.0;
        _slider.popUpViewColor = AHColor(19, 19, 19);
        _slider.popUpViewArrowLength = 8;
        [_slider setThumbImage:[UIImage BundleSourceName:@"ZFPlayer_slider"] forState:UIControlStateNormal];
        _slider.maximumValue = 1;
        _slider.minimumTrackTintColor  = [UIColor whiteColor];
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        [_slider addTarget:self action:@selector(sliderTouchBegin) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderTouchEnd) forControlEvents:UIControlEventTouchUpInside| UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_slider addGestureRecognizer:panRecognizer];
    }
    return _slider;
}
- (void)panRecognizer:(UIPanGestureRecognizer *)sender {}
- (UILabel *)totalTimeLabel{
    if (_totalTimeLabel==nil) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.text = @"00:00";
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
- (UIButton *)fullScreenBtn{
    if (_fullScreenBtn==nil) {
        _fullScreenBtn = [[UIButton alloc]init];
        [_fullScreenBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage BundleSourceName:@"ZFPlayer_shrinkscreen"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}
- (UIButton *)moreBtn{
    if (_moreBtn==nil) {
        _moreBtn = [[UIButton alloc]init];
        [_moreBtn setImage:[UIImage BundleSourceName:@"detail_cache_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _moreBtn;
}
- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = AHALColor(0, 0, 0, 0.8);
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}
#pragma mark - 控制层的所有操作
/**全屏操作*/
- (void)fullClick{
#warning 全屏 在AHPlayerView种添加 KVO 实现 检测 和屏幕的旋转 
    if ([AHPlayerStatus defaultStatus].isLockScreen) {
        
        return;
    }
    self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
    [AHPlayerStatus defaultStatus].isFullScreen = self.fullScreenBtn.selected;
}
/**返回操作*/
- (void)backClick{
    
    
}
/**锁屏*/
- (void)lockScreen{  // 选中状态是锁屏
    
    self.lockScreenBtn.selected  = !self.lockScreenBtn.selected;
    [AHPlayerStatus defaultStatus].isLockScreen = self.lockScreenBtn.selected;
    if (self.lockScreenBtn.selected) {
         self.showing = NO;
    }else{
        self.showing = YES;
    }
}
#warning 以下操作 待完善
/**中间按钮的状态*/
- (void)centerPlayBtn{
    
    
}
/**下载操作*/
- (void)downClick{
    
    
}
/**开始 暂停*/
- (void)playClick{
    
    if ([AHPlayerStatus defaultStatus].isLockScreen) {
        
        return;
    }
    
    if ([AHPlayerStatus defaultStatus].playerStatus == AHPlayerEnd ||
        [AHPlayerStatus defaultStatus].playerStatus == AHPlayerFail||
        [AHPlayerStatus defaultStatus].playerStatus == AHPlayerWillPlay
        ) {
        return;
    }
    
    if ([AHPlayerStatus defaultStatus].playerStatus==AHPlayerPause) {
        
        [AHPlayerStatus defaultStatus].playerStatus=AHPlayerPlaying;
    }else{
        [AHPlayerStatus defaultStatus].playerStatus=AHPlayerPause;
    }
    self.startBtn.selected = !self.startBtn.selected;
    
}
/**slider开始滑动*/
- (void)sliderTouchBegin{
    
    [self CancelAutoFadeOutControlView];
}
/**slider值可以变化*/
-(void)sliderValueChange{
    
    [AHPlayerStatus defaultStatus].draggedingValue = self.slider.value;
    
}
/**slider结束*/
- (void)sliderTouchEnd{
    
    [AHPlayerStatus defaultStatus].draggedendValue = self.slider.value;
    
    self.showing = YES;
}
/**更多按钮被点击*/
- (void)moreClick{
    
    
}

#pragma mark - AHPlayerView delegate

- (void)AH_PlayerCurrentime:(NSInteger)currentTime TotalTime:(NSInteger)totalTime Progress:(CGFloat)progress Item:(AHPlayerItem *)item PlayerView:(AHPlayerView *)playerview{
#warning 这里时间的显示格式只是00:00  没有小时
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (![AHPlayerStatus defaultStatus].isDragged) {
        // 更新slider
        self.slider.value           = progress;
//        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
}

- (void)AH_PlayerStatusCHange:(NSString *)status Item:(AHPlayerItem *)item PlayerView:(AHPlayerView *)playerview{
    
#warning 暂时处理为隐藏  应该还有 缓存中 失败 之类的
    
    if (![status isEqualToString:AHPlayerPrepare]) {
        
        self.playBtn.hidden = YES;
        self.startBtn.selected = NO;
    }
    
    if ([status isEqualToString:AHPlayerPause]) {
        
        self.startBtn.selected = YES;
    }
    
    if ([status isEqualToString:AHPlayerBuffer] || [status isEqualToString:AHPlayerWillPlay]) {
        // 中间位置展示菊花
        [self Showactivity:YES];
    }else{
        [self Showactivity:NO];;
    }
}

- (void)Showactivity:(BOOL)Showactivity{
    
    if (Showactivity) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

- (void)AH_PlayerCacheProgress:(CGFloat)progress Item:(AHPlayerItem *)item PlayerView:(AHPlayerView *)playerview{
    
    [self.progressView setProgress:progress animated:NO];
}

- (void)AH_PlayerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd haveThumbImg:(BOOL)haveThumbImg thumbImg:(UIImage *)thumbImg Item:(AHPlayerItem *)item PlayerView:(AHPlayerView *)playerview{
    
    
    NSLog(@"测试开始");
    
    // 快进快退时候停止菊花
    [self.activity stopAnimating];
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    // 显示、隐藏预览窗
    self.slider.popUpView.hidden = [AHPlayerStatus defaultStatus].isFullScreen?YES:NO;
    // 更新slider的值
    self.slider.value            = draggedValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
   
    if (forawrd) {
        self.fastImageView.image = [UIImage BundleSourceName:@"ZFPlayer_fast_forward"];
    } else {
        self.fastImageView.image = [UIImage BundleSourceName:@"ZFPlayer_fast_backward"];
    }
    self.fastView.hidden           = haveThumbImg;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
}

- (void)AH_PlayerDraggedEnd{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fastView.hidden = YES;
    });
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self CancelAutoFadeOutControlView];
}

#pragma mark - 其他

/**重置状态*/
- (void)ResetStatus{
    
    [self.activity stopAnimating];
}
- (CGRect)thumbRect {
    return [self.slider thumbRectForBounds:self.slider.bounds
                                      trackRect:[self.slider trackRectForBounds:self.slider.bounds]
                                          value:self.slider.value];
}

- (void)dealloc{
    
    [[AHPlayerStatus defaultStatus] removeObserver:self forKeyPath:@"Showactivity"];
}



@end
