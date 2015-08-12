//
//  PZSignInRequest.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZSignInRequest.h"

static NSString     *const kMessageType = @"0800";

@implementation PZSignInRequest

- (BOOL)decode:(NSData *)mes {
    [super decode:mes];
    
    return YES;
}

/**
 * @brief 打包成8583格式报文
 * @return 转换网络传输的字节
 */
- (NSData *)encode {
    self.posFields.private63 = self.oprNumber;
    self.posFields.messageType = kMessageType;
    
    return [super encode];
}

@end
