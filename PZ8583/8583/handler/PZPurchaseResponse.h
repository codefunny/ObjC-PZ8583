//
//  PZPurchaseResponse.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/13.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageResponse.h"

@interface PZPurchaseResponse : PZMessageResponse

- (void)parsePosField54:(NSString *)field54;

@end
