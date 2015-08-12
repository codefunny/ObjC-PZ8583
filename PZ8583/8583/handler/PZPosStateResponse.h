//
//  PZPosStateResponse.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZMessageResponse.h"

@interface PZPosStateResponse : PZMessageResponse

@property (nonatomic,strong) NSString   *tagOf62;
@property (nonatomic,assign) NSInteger  numberOfRecive;
@property (nonatomic,strong) NSArray    *reciveData;

- (void)parsePosStateField62:(NSString *)field62;

@end
