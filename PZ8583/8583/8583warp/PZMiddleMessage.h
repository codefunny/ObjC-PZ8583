//
//  PZMiddleMessage.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/10.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZPosField.h"

/******************************************************************************/
@interface PZMiddleMessage : NSObject

/**
 * 打包之后，这里存放打包文件
 */
@property (nonatomic,readonly) NSData                 *msgData;
/**
 * 打包文件长度
 */
@property (nonatomic,readonly) NSInteger              dataSize;

@property (nonatomic,assign) BOOL                     hasTpdu;
@property (nonatomic,readwrite,copy) NSString         *msgTpdu;
@property (nonatomic,assign) BOOL                     hasHead;
@property (nonatomic,readwrite,copy) NSString         *msgHead;

@property (nonatomic,readwrite,strong) PZPosField             *posFields;

/**
 * @brief 解包
 * @param bytes	字节数组形态的8583报文，从消息类型开始，包括mac字段。
 */
- (BOOL)decode:(NSData *)bytes ;

/**
 * @brief 打包成8583格式报文
 * @return 转换网络传输的字节
 */
- (NSData *)encode;

/**
 * @brief 填充报文域内容
 * @param content 域内容
 * @param index   域位置
 * @param 成功与否
 */
- (BOOL)setFieldValueWithString:(NSString *)content atIndex:(NSInteger)index;
- (BOOL)setFieldValueWithData:(NSData *)content atIndex:(NSInteger)index;

- (NSString *)getFieldValueStringAtIndex:(NSInteger)index;
- (NSData *)getFieldValueDataAtIndex:(NSInteger)index;

@end

/******************************************************************************/

@interface PZMiddleMessage (Utils)

/**
 * 打印报文结构及内容
 */
- (void)showMessageDump ;

/**
 *打印报文16进制格式
 */
- (void)showMessageHex;

@end

/******************************************************************************/

