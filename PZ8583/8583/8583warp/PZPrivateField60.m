//
//  PZPrivateField60.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/12.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPrivateField60.h"

static NSInteger    kField60Len = 11;
static NSInteger    kMsgTypeLen = 2;
static NSInteger    kBatchNumberLen = 6;
static NSInteger    kNetworkCodeLen = 3;

@implementation PZPrivateField60

- (BOOL)decode:(NSString *)field60 {
    if (field60 == nil) {
        return NO;
    }
    
    if (field60.length < kMsgTypeLen + kBatchNumberLen) {
        return NO;
    }
    
    NSRange range = NSMakeRange(0, kMsgTypeLen);
    self.msgType = [field60 substringWithRange:range];
    
    range = NSMakeRange(range.location + range.length, kBatchNumberLen);
    self.batchNumber = [field60 substringWithRange:range];
    
    if (field60.length >= kField60Len) {
        range = NSMakeRange(range.location+range.length, kNetworkCodeLen);
        self.networkCode = [field60 substringWithRange:range];
    }
    
    return YES;
}

- (NSString *)encode {
    if (self.msgType == nil || self.msgType.length != kMsgTypeLen) {
        return nil;
    }
    
    if (self.batchNumber == nil || self.batchNumber.length != kBatchNumberLen) {
        return nil;
    }
    
    return [self description];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[PZPrivateField60 class]]) {
        return NO;
    }
    
    PZPrivateField60 *field = (PZPrivateField60 *)object;
    if ([[field description] isEqualToString:[self description]] ) {
        return YES;
    } else {
        return NO;
    }
}

- (NSUInteger)hash {
    NSString *hashStr = [self description];
    return [hashStr hash];
}

- (NSString *)description {
    NSString *netCode = self.networkCode ? self.networkCode : @"";
    return [NSString stringWithFormat:@"%@%@%@",self.msgType,self.batchNumber,netCode];
}

@end
