//
//  ViewController.m
//  AHPlayer
//
//  Created by AH on 2017/6/20.
//  Copyright © 2017年 AH. All rights reserved.
//

#import "ViewController.h"

#import "AHPlayerView.h"
#import "AHPlayerItem.h"
#import "AHPlayerViewDelegate.h"

@interface ViewController ()<AHPlayerViewDelegate>

@property (nonatomic,strong) AHPlayerView *playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    AHPlayerItem *item = [[AHPlayerItem alloc]init];
    item.item_title = @"测试";
    item.item_high_url = @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4";
    item.item_cover_url = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
    self.playerView = [[AHPlayerView alloc]initWithFrame:CGRectMake(0, 0, width, width *9/16)];
    self.playerView.item = item;
    [self.view addSubview:self.playerView];
    
    self.playerView.delegate = self;
}

- (void)AH_BrightnesChange:(CGFloat)brightnesValue Item:(AHPlayerItem *)item PlayerView:(AHPlayerView *)playerview{
    
     NSLog(@"控制器也接受到了变化=====%f",brightnesValue);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
