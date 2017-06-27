//
//  AHPlayerItem.h
//  AHPlayer
//
//  Created by AH on 2017/6/20.
//  Copyright © 2017年 AH. All rights reserved.
//

/**
 
 视频数据模型基类  
 */

#import <Foundation/Foundation.h>

@interface AHPlayerItem : NSObject

/**视频标题*/
@property (nonatomic,copy) NSString *item_title;
/**视频url-超清*/
@property (nonatomic,copy) NSString *item_super_url;
/**视频url-高清*/
@property (nonatomic,copy) NSString *item_high_url;
/**视频url-清晰*/
@property (nonatomic,copy) NSString *item_distinct_url;
/**视频url-流畅*/
@property (nonatomic,copy) NSString *item_fluency_url;
/**视频封面url*/
@property (nonatomic,copy) NSString *item_cover_url;
/**视频id*/
@property (nonatomic,copy) NSString *item_id;
/**其他信息参数*/
@property (nonatomic,copy) NSString *item_other_info;

@end
