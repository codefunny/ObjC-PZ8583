//
//  PZMiddleMessage.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/10.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMiddleMessage.h"
#import "PZMessageUtils.h"
#include "dl_iso8583.h"
#include "dl_iso8583_defs_pos.h"
#include "dl_output.h"

// indicates the buffer size (in bytes)
#define kBUFFER_SIZE	1000
#define kBUFFER_TPDU    5
#define kBUFFER_HEAD    6

@interface PZMiddleMessage ()
{
    DL_ISO8583_HANDLER isoHandler;
    DL_ISO8583_MSG     isoMsg;
    DL_UINT8           buf[kBUFFER_SIZE];
    DL_UINT16          bufSize;
    
    DL_UINT8            isotpdu[kBUFFER_TPDU];
    DL_UINT8            isohead[kBUFFER_HEAD];
}

@end

@implementation PZMiddleMessage

- (id)init {
    if (self = [super init]) {
        DL_ISO8583_DEFS_POS_GetHandler(&isoHandler);
        /* initialise ISO message */
//        DL_ISO8583_MSG_Init(sBuf,kBUFFER_SIZE,&isoMsg);
        DL_ISO8583_MSG_Init(NULL,0,&isoMsg);
        _msgHead = nil;
        _msgTpdu = nil;
        bufSize = 0;
        //默认是不包含tpdu和head的
        _hasHead = NO;
        _hasTpdu = NO;
        
        _posFields = [PZPosField new];
    }
    
    return self;
}

- (void)dealloc {
    /* destroy ISO Msg */
    DL_ISO8583_MSG_Free(&isoMsg);
}

/**
 * @brief 解包
 * @param bytes	字节数组形态的8583报文，从消息类型开始，包括mac字段。
 * @param dataSize 字节长度
 */
- (BOOL)decode:(NSData *)bytes {

    bufSize =  [bytes length];
    const char    *deBytes = [bytes bytes];
    NSInteger     index = 0;
    
    if (self.hasTpdu) {
        memcpy(isotpdu, deBytes, kBUFFER_TPDU);
        NSData  *tmpData = [NSData dataWithBytes:isotpdu length:kBUFFER_TPDU];
        self.msgTpdu  = [PZMessageUtils hexStringFromData:tmpData];
        index += kBUFFER_TPDU;
    }
    
    if (self.hasHead) {
        memcpy(isohead, deBytes + index, kBUFFER_HEAD);
        NSData  *tmpData = [NSData dataWithBytes:isohead length:kBUFFER_HEAD];
        self.msgHead  = [PZMessageUtils hexStringFromData:tmpData];
        index += kBUFFER_HEAD;
    }

    bufSize -= index;
    memcpy(buf, deBytes+index, bufSize);
    DL_ERR result = DL_ISO8583_MSG_Unpack(&isoHandler,buf,bufSize,&isoMsg);
    if (result == kDL_ERR_NONE) {
        [self decodeToPosFields];
        return YES;
    }
    
    return NO;
}

/**
 * @brief 打包成8583格式报文
 * @return 转换网络传输的字节
 */
- (NSData *)encode {
    
    [self encodeFromPosFields];

    DL_ERR result = DL_ISO8583_MSG_Pack(&isoHandler,&isoMsg,buf,&bufSize);
    if (result != kDL_ERR_NONE) {
        return nil;
    }
    NSMutableData *msgBuf = [NSMutableData dataWithCapacity:0];
    if (self.hasTpdu) {
        [msgBuf appendData:[PZMessageUtils hexToBytes:self.msgTpdu]];
    }
    
    if (self.hasHead) {
        [msgBuf appendData:[PZMessageUtils hexToBytes:self.msgHead]];
    }
    
    [msgBuf appendData:self.msgData];
    
    return msgBuf;
}

#pragma mark - util
- (BOOL)setFieldValueWithString:(NSString *)content atIndex:(NSInteger)index {
    NSData *valueData = [content dataUsingEncoding:NSUTF8StringEncoding];
    return [self setFieldValueWithData:valueData atIndex:index];
}

- (BOOL)setFieldValueWithData:(NSData *)content atIndex:(NSInteger)index {
    
    DL_UINT16 fieldIndex = (DL_UINT16)index;
    const DL_UINT8 *fieldValue = [content bytes];
    DL_UINT16 iValueLength = [content length];
    DL_ERR result = DL_ISO8583_MSG_SetField_Bin(fieldIndex,fieldValue,iValueLength,&isoMsg);
    if (result == kDL_ERR_NONE) {
        return YES;
    }
    
    return NO;
}

- (NSString *)getFieldValueStringAtIndex:(NSInteger)index {
    NSData *dataValue = [self getFieldValueDataAtIndex:index];
    if (!dataValue) {
        return nil;
    }
    
    NSString *strValue = [[NSString alloc] initWithData:dataValue encoding:NSUTF8StringEncoding];
    if (!strValue) {
        strValue = [PZMessageUtils hexStringFromData:dataValue];
    }
    
    return strValue;
}

- (NSData *)getFieldValueDataAtIndex:(NSInteger)index {
    
    DL_UINT16 fieldIndex = (DL_UINT16)index;
    int result = DL_ISO8583_MSG_HaveField(fieldIndex,&isoMsg);
    if (result == 0) {
        return nil;
    }
    DL_UINT8    *data;
    DL_UINT16  iDataLength = 0;
    DL_ISO8583_MSG_GetField_Bin(fieldIndex,&isoMsg,&data,&iDataLength);
    
    return [NSData dataWithBytes:data length:iDataLength];
}

- (NSData *)msgData {
    return [NSData dataWithBytes:buf length:bufSize];
}

- (NSInteger)dataSize {
    return bufSize;
}

- (void)decodeToPosFields {
    NSInteger  index = 0;
    for (; index < kDL_ISO8583_MAX_FIELD_IDX + 1; index++) {
        NSString  *value = nil;
        if (index == 1 || index == 64) {
            NSData *data = [self getFieldValueDataAtIndex:index];
            value = [PZMessageUtils hexStringFromData:data];
        } else {
            value = [self getFieldValueStringAtIndex:index];
        }
        
        if (value) {
            NSString  *dictKey = [NSString stringWithFormat:@"%lu",(long)index];
            NSString  *key = self.posFields.mapDict[dictKey];
            [self.posFields setValue:value forKey:key];
        }
    }

#ifdef DEBUG
    NSLog(@"-----------------------");
    [self.posFields description];
#endif
}

- (void)encodeFromPosFields {
    
    NSDictionary    *dict = self.posFields.mapDict;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop){
        NSInteger   index = [key integerValue];
        id  value = [self.posFields valueForKey:obj];
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [self setFieldValueWithString:value atIndex:index];
            } else {
                [self setFieldValueWithData:value atIndex:index];
            }
            
#ifdef DEBUG
             NSLog(@"%@:%@:%@",obj,key,value);
#endif
        }
    }];
}

#pragma mark - Utils
- (void)showMessageDump {
    /* output ISO message content */
    DL_ISO8583_MSG_Dump(stdout,NULL,&isoHandler,&isoMsg);
}

- (void)showMessageHex {
    DL_OUTPUT_Hex(stdout,NULL,buf,bufSize);
}

@end
