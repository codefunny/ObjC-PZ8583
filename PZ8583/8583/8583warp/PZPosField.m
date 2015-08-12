//
//  PZField.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPosField.h"

@implementation PZPosField

- (NSDictionary*)mapDict {
    return @{@"0":@"messageType",
             @"1":@"bitmap",
             @"2":@"cardPan",
             @"3":@"processCode",
             @"4":@"tranAmount",
             @"11":@"tranTtc",
             @"12":@"tranTime",
             @"13":@"tranDate",
             @"14":@"expireDate",
             @"15":@"settDate",
             @"22":@"serverMode",
             @"25":@"conditionMode",
             @"26":@"pinCode",
             @"32":@"acqCode",
             @"35":@"track2Data",
             @"36":@"track3Data",
             @"37":@"referenceNum",
             @"38":@"authCode",
             @"39":@"responseCode",
             @"41":@"terminalId",
             @"42":@"merchantId",
             @"44":@"aditionRespData",
             @"48":@"private48",
             @"49":@"currentCode",
             @"52":@"pinData",
             @"53":@"securityCode",
             @"54":@"balanceAmount",
             @"55":@"icCardData",
             @"60":@"private60",
             @"61":@"originMessage",
             @"62":@"private62",
             @"63":@"private63",
             @"64":@"messageMac"};
}

- (id)copyWithZone:(NSZone *)zone {
    PZPosField  *fields = [[PZPosField allocWithZone:zone] init];
    fields.messageType = self.messageType;
    fields.bitmap = self.bitmap;
    fields.cardPan  = self.cardPan;
    fields.processCode  = self.processCode;
    fields.tranAmount = self.tranAmount;
    fields.tranTtc = self.tranTtc;
    fields.tranTime = self.tranTime;
    fields.tranDate = self.tranDate;
    fields.expireDate = self.expireDate;
    fields.settDate = self.settDate;
    fields.serverMode = self.serverMode;
    fields.conditionMode = self.conditionMode;
    fields.pinCode = self.pinCode;
    fields.acqCode = self.acqCode;
    fields.track2Data = self.track2Data;
    fields.track3Data =  self.track3Data;
    fields.referenceNum = self.referenceNum;
    fields.authCode = self.authCode;
    fields.responseCode = self.responseCode;
    fields.terminalId = self.terminalId;
    fields.merchantId = self.merchantId;
    fields.aditionRespData = self.aditionRespData;
    fields.private48 = self.private48;
    fields.currentCode = self.currentCode;
    fields.pinData = self.pinData;
    fields.securityCode = self.securityCode;
    fields.balanceAmount = self.balanceAmount;
    fields.icCardData = self.icCardData;
    fields.private60 = self.private60;
    fields.originMessage = self.originMessage;
    fields.private62 = self.private62;
    fields.private63 = self.private63;
    fields.messageMac = self.messageMac;
    
    return fields;
}

- (NSString *)description {
    NSDictionary    *dict = self.mapDict;
    NSArray *keySort = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        NSInteger key1 = [(NSString *)obj1 integerValue];
        NSInteger key2 = [(NSString *)obj2 integerValue];
        
        return key1 <= key2 ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    NSMutableString *mutablesStr = [NSMutableString new];
    for (NSString *key in keySort) {
        NSString    *obj = dict[key];
        if ([self valueForKey:obj]) {
            NSLog(@"%@:%@:%@",obj,key,[self valueForKey:obj]);
            [mutablesStr appendFormat:@"%@:%@:%@\n",obj,key,[self valueForKey:obj]];
        }
    }
    
    return mutablesStr;
}

@end
