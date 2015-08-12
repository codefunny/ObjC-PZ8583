//
//  PZSignInResponse.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZSignInResponse.h"
#import "PZMessageUtils.h"

@implementation PZSignInResponse

- (BOOL)decode:(NSData *)mes {
    [super decode:mes];
    
    NSString    *prv62 = self.posFields.private62;
    if (prv62 == nil) {
        return NO;
    }
    
    self.private62 = [[PZPrivateField62 alloc] initWithData:prv62];
    
    return YES;
}

@end
