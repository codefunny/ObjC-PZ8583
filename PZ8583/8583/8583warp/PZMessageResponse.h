//
//  PZResponse.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZBaseMessage.h"

@interface PZMessageResponse : PZBaseMessage

@property (nonatomic,strong) NSString   *respCode;

@end
