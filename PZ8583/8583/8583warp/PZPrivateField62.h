//
//  PZPrivateField62.h
//  PaylabMPos
//
//  Created by mark zheng on 15/6/18.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZPrivateField62 : NSObject

@property (nonatomic,strong) NSString   *keyIndex;
@property (nonatomic,strong) NSString   *pinKey;
@property (nonatomic,strong) NSString   *pinKeyValue;
@property (nonatomic,strong) NSString   *macKey;
@property (nonatomic,strong) NSString   *macKeyValue;
@property (nonatomic,strong) NSString   *trkKey;
@property (nonatomic,strong) NSString   *trkKeyValue;

- (id)initWithData:(NSString *)prvData;

@end
