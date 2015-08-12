//
//  PZSignInRequest.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageRequest.h"

@interface PZSignInRequest : PZMessageRequest

@property (nonatomic,strong) NSString   *oprNumber;

- (BOOL)decode:(NSData *)mes ;

- (NSData *)encode;

@end
