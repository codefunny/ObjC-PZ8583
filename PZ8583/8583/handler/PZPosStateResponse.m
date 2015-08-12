//
//  PZPosStateResponse.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPosStateResponse.h"

#import "BerTlvComm.h"

@implementation PZPosStateResponse

- (void)parsePosStateField62:(NSString *)field62 {
    NSData *data = [HexUtil parse:field62];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlvs *tlvs = [parser parseTlvs:data];
    NSLog(@"%lu",(long)tlvs.list.count);
    NSLog(@"tlvs=\n%@",[tlvs dump:@" "]);
}

@end
