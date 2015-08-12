//
//  TlvTagValue.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/14.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "TlvTagValue.h"

@implementation TlvTagValue

- (instancetype)initWithTag:(NSString *)tagStr {
    if (self = [super init]) {
        _tlvTag = tagStr;
        _tlvValue = nil;
    }
    
    return self;
}

- (NSString *)description {
    NSString  *desc = [NSString stringWithFormat:@"< - [%@] %@>",self.tlvTag,self.tlvValue];
    return desc;
}

@end
