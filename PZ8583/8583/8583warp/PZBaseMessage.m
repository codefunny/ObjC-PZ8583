//
//  PZBaseMessage.m
//  PaylabMPos
//
//  Created by mark zheng on 15/6/30.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZBaseMessage.h"
#import "PZMiddleMessage.h"

NSString     *const tpdu = @"6000000000";
NSString     *const head = @"603100000000";

@implementation PZBaseMessage

- (id)init {
    if (self = [super init]) {
        _terminalId = nil;
        _merchantId = nil;
        _posFields = [PZPosField new];
        _messageTpdu = tpdu;
        _messageHead = head;
    }
    
    return self;
}

- (BOOL)decode:(NSData *)data {
    PZMiddleMessage *m8583 = [PZMiddleMessage new];
    m8583.hasTpdu = YES;
    m8583.hasHead = YES;
    [m8583 decode:data];
    
    self.posFields = m8583.posFields;
    
    self.terminalId = m8583.posFields.terminalId;
    self.merchantId = m8583.posFields.merchantId;
    self.tranTtc = m8583.posFields.tranTtc;
    
    self.messageTpdu = m8583.msgTpdu;
    self.messageHead = m8583.msgHead;
#ifdef DEBUG
    [m8583 showMessageDump];
#endif
    return YES;
}

/**
 * @brief 打包成8583格式报文
 * @return 转换网络传输的字节
 */
- (NSData *)encode {
    PZMiddleMessage *mes = [PZMiddleMessage new];

    mes.posFields = self.posFields;
    
    if (self.messageTpdu) {
        [mes setMsgTpdu:self.messageTpdu];
        mes.hasTpdu = YES;
    }
    
    if (self.messageHead) {
        [mes setMsgHead:self.messageHead];
        mes.hasHead = YES;
    }
    
    NSData  *sendData = [mes encode];
#ifdef DEBUG
    [mes showMessageDump];
#endif
    
    return sendData;
}

@end
