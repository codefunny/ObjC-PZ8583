//
//  PZBaseMessage.h
//  PaylabMPos
//
//  Created by mark zheng on 15/6/30.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZPosField.h"
#import "PZMessageUtils.h"

@interface PZBaseMessage : NSObject

/*报文头，TPDU、Head*/
@property (nonatomic,strong) NSString   *messageTpdu;
@property (nonatomic,strong) NSString   *messageHead;

/*基本公共参数*/
@property (nonatomic,strong) NSString   *merchantId;
@property (nonatomic,strong) NSString   *terminalId;
@property (nonatomic,strong) NSString   *mposNumber;
@property (nonatomic,strong) NSString   *merchantName;
@property (nonatomic,strong) NSString   *batchNumber;
@property (nonatomic,strong) NSString   *tranTtc;

/*消息类型*/
@property (nonatomic,strong) NSString   *messageType;

@property (nonatomic,strong) PZPosField *posFields;

/**
 * @brief 解包
 * @param bytes	字节数组形态的8583报文，从消息类型开始，包括mac字段。
 */
- (BOOL)decode:(NSData *)mes ;

/**
 * @brief 打包成8583格式报文
 * @return 转换网络传输的字节
 */
- (NSData *)encode;

@end
