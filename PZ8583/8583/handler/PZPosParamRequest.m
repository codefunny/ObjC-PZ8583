//
//  PZPosParamRequest.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPosParamRequest.h"

static NSString     *const kMessageType = @"0800";

@implementation PZPosParamRequest

- (BOOL)decode:(NSData *)mes {
    [super decode:mes];
    
    return YES;
}

/**
 * @brief 打包成8583格式报文
 * @return 转换网络传输的字节
 */
- (NSData *)encode {
    self.posFields.messageType = kMessageType;
    
    return [super encode];
}

@end
