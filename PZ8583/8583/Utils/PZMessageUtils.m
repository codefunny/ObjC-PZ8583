//
//  PZMessageUtils.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/10.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageUtils.h"
//#import "dl_output.h"

@implementation PZMessageUtils

+ (NSString *)hexToAscii:(NSString *)str {
    NSData    *hexData = [self hexToBytes:str];
    NSString  *asciiStr = [[NSString alloc] initWithData:hexData encoding:NSASCIIStringEncoding];

    return asciiStr;
}

+ (NSString *)asciiToHex:(NSString *)str {
    NSData  *hexData = [str dataUsingEncoding:NSASCIIStringEncoding];
    NSString    *hexStr = [self hexStringFromData:hexData];
    
    return hexStr;
}

+ (NSData*) hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        
        NSString* hexStr = [str substringWithRange:range];
        
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        
        unsigned int intValue;
        
        [scanner scanHexInt:&intValue];
        
        [data appendBytes:&intValue length:1];
        
    }
    
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)data
{
    NSMutableString *str = [NSMutableString string];
    
    Byte *byte = (Byte *)[data bytes];
    
    for (int i = 0; i<[data length]; i++) {
        // byte+i为指针
        [str appendString:[self stringFromByte:*(byte+i)]];
    }
    
    return str;
}

+ (NSString *)stringFromByte:(Byte)byteVal
{
    NSMutableString *str = [NSMutableString string];
    
    //取高四位
    Byte byte1 = byteVal>>4;
    
    //取低四位
    Byte byte2 = byteVal & 0xf;
    
    //拼接16进制字符串
    [str appendFormat:@"%x",byte1];
    [str appendFormat:@"%x",byte2];
    
    return str;
}

//+ (void)showMessageHexWithData:(NSData *)data {
//    DL_UINT8 *bytes = (DL_UINT8 *)[data bytes];
//    DL_OUTPUT_Hex(stdout, NULL, bytes, (DL_UINT32)data.length);
//}

@end
