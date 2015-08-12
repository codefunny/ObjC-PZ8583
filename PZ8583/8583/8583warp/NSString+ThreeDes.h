//
//  NSString+ThreeDes.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/10.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ThreeDes)

//Des
+ (NSString*)encryptDes:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decryptDes:(NSString*)plainText withKey:(NSString*)key ;

//3Des
+ (NSString *)decrypt3Des:(NSString *)plainText withKey:(NSString *)key ;
+ (NSString *)encrypt3Des:(NSString *)plainText withKey:(NSString *)key ;

//数据异或
+ (NSString *)dataXor:(NSString *)data1 withData:(NSString *)data2 ;

//sha-1
- (NSString*) sha1;

//md5
-(NSString *) md5;

//base64运算
+ (NSString *)base64StringFromText:(NSData *)data;
+ (NSData *)textFromBase64String:(NSString *)string;

//mac计算
+ (NSString *)macBlock:(NSString *)pack withMacKey:(NSString *)macKey;
+ (NSString *)genMacWithMacBlock:(NSString *)block withMacKey:(NSString *)macKey;

//52#加密
+ (NSString *)pinBlock:(NSString *)password withCard:(NSString *)panNum withPinKey:(NSString *)pinkey;

//磁道加密
+ (NSString *)trkStr:(NSString *)trkStr withTrkKey:(NSString *)trkKey;

@end
