//
//  PZPosParamRequest.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageRequest.h"

@interface PZPosParamRequest : PZMessageRequest

@property (nonatomic,strong) NSString    *transKey;

- (BOOL)decode:(NSData *)mes ;

- (NSData *)encode;

@end
