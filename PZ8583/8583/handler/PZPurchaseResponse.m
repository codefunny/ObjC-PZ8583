//
//  PZPurchaseResponse.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/13.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZPurchaseResponse.h"

@implementation PZPurchaseResponse

/*
 *余额
 * 账户类型(2)+数量类型(2)+货币代码(156)+余额符号(1)+余额(12) = 20
 */
- (void)parsePosField54:(NSString *)field54 {
    
    NSRange   range = NSMakeRange(0, 2);
    NSString    *accountType = [field54 substringWithRange:range];
    
    range = NSMakeRange(range.location+range.length, 2);
    NSString    *amountType = [field54 substringWithRange:range];
    
    range = NSMakeRange(range.location + range.length, 3);
    NSString    *currencyCode = [field54 substringWithRange:range];
    
    range = NSMakeRange(range.location+range.length, 1);
    NSString    *amountSign = [field54 substringWithRange:range];
    
    range = NSMakeRange(range.location+range.length, 12);
    NSString    *amount = [field54 substringWithRange:range];
    
    NSLog(@"accountType:%@,amountType:%@,currencyCode:%@,amountSign:%@,amount:%@",
          accountType,amountType,currencyCode,amountSign,amount);
}

@end
