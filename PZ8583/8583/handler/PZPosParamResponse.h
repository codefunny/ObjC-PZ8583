//
//  PZPosParamResponse.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageResponse.h"
#import "PZPublicKeyObject.h"

@interface PZPosParamResponse : PZMessageResponse

@property (nonatomic,strong) NSString   *tagOf62;
@property (nonatomic,strong) NSMutableArray    *tlvArray;

@property (nonatomic,strong) PZPublicKeyObject *pubKey;

- (void)parsePosField62:(NSString *)field62;

- (void)parsePosField62ToPublicKey:(NSString *)field62;

@end
