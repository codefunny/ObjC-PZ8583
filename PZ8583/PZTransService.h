//
//  PZTransService.h
//  PaylabMPos
//
//  Created by mark zheng on 15/6/18.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLSocketCenter.h"

@class PZPosField;
@interface PZTransService : NSObject

@property (nonatomic,strong) PLSocketCenter     *sockMgr;

@property (nonatomic,strong) NSString   *pinKey;
@property (nonatomic,strong) NSString   *macKey;
@property (nonatomic,strong) NSString   *trkKey;

@property (nonatomic,strong) NSString   *masterKey;
@property (nonatomic,strong) NSString   *posKey;

@property (nonatomic,strong) PZPosField *fields;
@property (nonatomic,strong) PZPosField *uploadSign;

+ (instancetype)instance;

//终端工作密钥
- (void)mposGetWorkKeyFromServerWithBlock:(void(^)(NSString *text))display;

//POS状态上送(IC公钥)
- (void)mposGetPosICKeyFromServer ;

//POS状态上送(IC参数)
- (void)mposGetPosICParamFromServer ;

//POS参数下载
- (void)mposGetICKeyFromServer;

//消费交易
- (void)mposPurchaseFromServerWithBlock:(void(^)(NSString *text))display;

//余额查询
- (void)mposBalanceFromServerWithBlock:(void(^)(NSString *text))display;

//冲正
- (void)mposReverseFromServerWithBlock:(void(^)(NSString *text))display;

@end
