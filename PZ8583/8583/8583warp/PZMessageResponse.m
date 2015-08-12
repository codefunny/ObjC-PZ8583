//
//  PZResponse.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageResponse.h"

@implementation PZMessageResponse

- (BOOL)decode:(NSData *)mes {
    [super decode:mes];

    self.respCode = self.posFields.responseCode;
    
    return YES;
}

@end
