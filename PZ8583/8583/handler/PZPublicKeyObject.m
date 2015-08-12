//
//  PZPublicKeyObject.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/2.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPublicKeyObject.h"
#import <objc/runtime.h>

NSString    *const kRidKey = @"9F06";
NSString    *const kIndexKey = @"9F22";
NSString    *const kExpireKey = @"DF05";
NSString    *const kHashTagKey = @"DF06";
NSString    *const kAlgorithmTagKey = @"DF07";
NSString    *const kModeKey = @"DF02";
NSString    *const kIndicesKey = @"DF04";
NSString    *const kCheckValueKey = @"DF03";

@implementation PZPublicKeyObject

- (instancetype)init {
    if (self = [super init]) {
        [self initProperty];
    }
    
    return self;
}

- (void)initProperty {
    _rid = [[TlvTagValue alloc] initWithTag:kRidKey];
    _pubKeyIndex = [[TlvTagValue alloc] initWithTag:kIndexKey];
    _pubKeyExpire = [[TlvTagValue alloc] initWithTag:kExpireKey];
    _pubKeyHashTag = [[TlvTagValue alloc] initWithTag:kHashTagKey];
    _pubKeyAlgorithmTag = [[TlvTagValue alloc] initWithTag:kAlgorithmTagKey];
    _pubKeyMode = [[TlvTagValue alloc] initWithTag:kModeKey];
    _pubKeyIndices = [[TlvTagValue alloc] initWithTag:kIndicesKey];
    _pubKeyCheckValue = [[TlvTagValue alloc] initWithTag:kCheckValueKey];
}

- (NSDictionary *)tagMap {
    return @{kRidKey:@"rid.tlvValue",
             kIndexKey:@"pubKeyIndex.tlvValue",
             kExpireKey:@"pubKeyExpire.tlvValue",
             kHashTagKey:@"pubKeyHashTag.tlvValue",
             kAlgorithmTagKey:@"pubKeyAlgorithmTag.tlvValue",
             kModeKey:@"pubKeyMode.tlvValue",
             kIndicesKey:@"pubKeyIndices.tlvValue",
             kCheckValueKey:@"pubKeyCheckValue.tlvValue"};
}

- (NSString *)description {
    NSMutableString     *descStr = [NSMutableString new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([PZPublicKeyObject class], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        TlvTagValue *tagValue = [self valueForKey:key];
        NSLog(@"%@",[tagValue description]);
        [descStr appendFormat:@"%@\n",[tagValue description]];
    }
    
    return descStr;
}

@end
