//
//  PZPrivateField60.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/12.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZPrivateField60 : NSObject

@property (nonatomic,strong) NSString   *msgType;
@property (nonatomic,strong) NSString   *batchNumber;
@property (nonatomic,strong) NSString   *networkCode;

- (BOOL)decode:(NSString *)field60;

- (NSString *)encode;

@end
