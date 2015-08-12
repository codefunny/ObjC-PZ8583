//
//  PZPosStateRequest.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageRequest.h"

@interface PZPosStateRequest : PZMessageRequest

- (BOOL)decode:(NSData *)mes ;

- (NSData *)encode;

@end
