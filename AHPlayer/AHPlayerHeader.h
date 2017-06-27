//
//  AHPlayerHeader.h
//  AHPlayer
//
//  Created by AH on 2017/6/23.
//  Copyright © 2017年 AH. All rights reserved.
//

#import <Foundation/Foundation.h>


#define AHColorHex(hex)                RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),1.f)
#define AHALColorHex(hex,a)             RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)
#define AHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define AHALColor(r, g, b,al) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:al]
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height


typedef NS_ENUM(NSInteger,PlayerStatus) {
    
    /**播放前准备*/
    PlayerStatusPrepare    =0,
    /**即将播放*/
    PlayerStatusWillPlay   = 1<<0,
    /**缓冲中*/
    PlayerStatusBuffer     = 1<<1,
    /**播放中*/
    PlayerStatusPlaying    = 1<<2,
    /**播放暂停*/
    PlayerStatusPause      = 1<<3,
    /**播放结束*/
    PlayerStatusEnd        = 1<<4,
    /**播放失败*/
    PlayerStatusFail       = 1<<5
};
