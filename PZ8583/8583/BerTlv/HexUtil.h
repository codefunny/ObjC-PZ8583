//
// Created by Evgeniy Sinev on 04/08/14.
// Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HexUtil : NSObject

+ (NSString *) format:(NSData *)aData;
+ (NSString *) prettyFormat:(NSData *)aData;

+ (NSData *) parse:(NSString *)aHex;

+ (NSString *)format:(NSData *)data offset:(uint)offset len:(NSUInteger)len;
@end