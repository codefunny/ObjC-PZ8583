//
//  PZPrivateField62.m
//  PaylabMPos
//
//  Created by mark zheng on 15/6/18.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPrivateField62.h"

const NSInteger     kKeyIndexLen = 2;
const NSInteger     kPinKeyLen = 32;
const NSInteger     kPinKeyValueLen = 8;
const NSInteger     kMacKeyLen = 32;
const NSInteger     kMacKeyValueLen = 8;
const NSInteger     kTrkKeyLen = 32;
const NSInteger     kTrkKeyValueLen = 8;

@implementation PZPrivateField62

- (id)initWithData:(NSString *)prvData {
    if (self = [super init]) {
        NSRange range = NSMakeRange(0, kKeyIndexLen);
        _keyIndex = [prvData substringWithRange:range];
        range = NSMakeRange(range.location+range.length, kPinKeyLen);
        _pinKey = [prvData substringWithRange:range];
        range = NSMakeRange(range.location+range.length, kPinKeyValueLen);
        _pinKeyValue = [prvData substringWithRange:range];
        
        range = NSMakeRange(range.location+range.length, kMacKeyLen);
        _macKey = [prvData substringWithRange:range];
        range = NSMakeRange(range.location+range.length, kMacKeyValueLen);
        _macKeyValue = [prvData substringWithRange:range];
        
        range = NSMakeRange(range.location+range.length, kTrkKeyLen);
        _trkKey = [prvData substringWithRange:range];
        range = NSMakeRange(range.location+range.length, kTrkKeyValueLen);
        _trkKeyValue = [prvData substringWithRange:range];
    }
    
    return self;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"<pin|%@:%@  mac|%@:%@  trc|%@:%@>",self.pinKey,self.pinKeyValue,
                      self.macKey,self.macKeyValue,self.trkKey,self.trkKeyValue];
    return desc;
}

@end
