//
//  PLSocketCenter.h
//  PaylabMPos
//
//  Created by mark zheng on 15/6/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^finishRecvDataFromPosp)(NSData *pospData,NSError *error);

@interface PLSocketCenter : NSObject

+ (instancetype)defaultCenter;

- (BOOL)startStop;

- (BOOL)isConnected;
- (void)didDisconnected;

- (void)sendDataToServer:(NSData *)data finishCallBack:(finishRecvDataFromPosp)block;

@end
