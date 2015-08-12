//
//  TlvTagValue.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/14.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TlvTagValue : NSObject

@property (nonatomic,strong) NSString   *tlvTag;
@property (nonatomic,strong) NSString   *tlvValue;

- (instancetype)initWithTag:(NSString *)tagStr ;

@end
