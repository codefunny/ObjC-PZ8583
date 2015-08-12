//
//  PZSignInResponse.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageResponse.h"
#import "PZPrivateField62.h"

@interface PZSignInResponse : PZMessageResponse

@property (nonatomic,strong) PZPrivateField62   *private62;

@end
