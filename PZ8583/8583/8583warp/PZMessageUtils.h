//
//  PZMessageUtils.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/10.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZMessageUtils : NSObject

+ (NSString *)hexToAscii:(NSString *)str;

+ (NSString *)asciiToHex:(NSString *)str;

+ (NSData*) hexToBytes:(NSString *)str;

+ (NSString *)hexStringFromData:(NSData *)data;

//+ (void)showMessageHexWithData:(NSData *)data ;

@end
