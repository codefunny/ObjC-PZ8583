//
//  PZPublicKeyObject.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/2.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TlvTagValue.h"

extern NSString    *const kRidKey ;
extern NSString    *const kIndexKey ;          //索引
extern NSString    *const kExpireKey ;        //有效期
extern NSString    *const kHashTagKey ;       //hash算法标识
extern NSString    *const kAlgorithmTagKey ;  //算法标识
extern NSString    *const kModeKey ;          //模值
extern NSString    *const kIndicesKey ;       //指数
extern NSString    *const kCheckValueKey ;

@interface PZPublicKeyObject : NSObject

@property (nonatomic,strong) TlvTagValue    *rid;
@property (nonatomic,strong) TlvTagValue    *pubKeyIndex;
@property (nonatomic,strong) TlvTagValue    *pubKeyExpire;
@property (nonatomic,strong) TlvTagValue    *pubKeyHashTag;
@property (nonatomic,strong) TlvTagValue    *pubKeyAlgorithmTag;
@property (nonatomic,strong) TlvTagValue    *pubKeyMode;
@property (nonatomic,strong) TlvTagValue    *pubKeyIndices;
@property (nonatomic,strong) TlvTagValue    *pubKeyCheckValue;

- (NSDictionary *)tagMap;

@end
