//
//  PZPosParamResponse.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPosParamResponse.h"
#import "BerTlvParser.h"
#import "HexUtil.h"
#import "BerTlvs.h"
#import "BerTlv.h"
#import "BerTag.h"

@implementation PZPosParamResponse

- (void)parsePosField62:(NSString *)field62 {
    NSString    *field62Tag = [field62 substringToIndex:2];
    self.tagOf62 = [PZMessageUtils hexToAscii:field62Tag];
    
    NSString    *field62TlvStr = [field62 substringFromIndex:2];
    NSData *data = [HexUtil parse:field62TlvStr];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlvs *tlvs = [parser parseTlvs:data];
    NSLog(@"%lu",(long)tlvs.list.count);
    NSLog(@"tlvs=\n%@",[tlvs dump:@" "]);
    
    self.tlvArray = [NSMutableArray array];
    for (BerTlv *tlv in tlvs.list) {
        TlvTagValue  *tagValue = [[TlvTagValue alloc] init];
        tagValue.tlvTag = tlv.tag.hex;
        tagValue.tlvValue = tlv.hexValue;
        [self.tlvArray addObject:tagValue];
    }
}

- (void)parsePosField62ToPublicKey:(NSString *)field62 {
    NSString    *field62Tag = [field62 substringToIndex:2];
    self.tagOf62 = [PZMessageUtils hexToAscii:field62Tag];
    
    NSString    *field62TlvStr = [field62 substringFromIndex:2];
    NSData *data = [HexUtil parse:field62TlvStr];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlvs *tlvs = [parser parseTlvs:data];
    
    self.pubKey = [[PZPublicKeyObject alloc] init];
    NSDictionary    *tagMap = [self.pubKey tagMap];
    [tagMap enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSString *obj,BOOL *stop){
        NSString *tlvTag = key;
        BerTag *berTag = [BerTag parse:tlvTag];
        BerTlv *berTlv = [tlvs find:berTag];
        if (berTlv) {
            [self.pubKey setValue:berTlv.hexValue forKeyPath:obj];
        }
    }];
    
    [self.pubKey description];
}

@end
