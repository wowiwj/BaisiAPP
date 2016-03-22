//
//  WJTopic.h
//  百思不得姐
//
//  Created by wangju on 16/3/22.
//  Copyright © 2016年 wangju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJTopic : NSObject
/*名称*/
@property (nonatomic,copy) NSString *name;

/*发帖时间*/
@property (nonatomic,copy) NSString *create_time;

/*顶的人数*/
@property (nonatomic,assign) NSInteger ding;

/*喜欢的人数*/
@property (nonatomic,assign) NSInteger favourite;

/*踩的人数*/
@property (nonatomic,assign) NSInteger cai;

/** 转发的人数 */
@property (nonatomic,assign) NSInteger repost;

/*文本内容*/
@property (nonatomic,copy) NSString *text;

/*头像URL*/
@property (nonatomic,copy) NSString *profile_image;

@end
