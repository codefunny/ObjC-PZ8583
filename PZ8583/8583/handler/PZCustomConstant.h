//
//  PZCustomConstant.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/16.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
//签到的60.1和60.3域
extern NSString    *const  kSignInField60MsgType ;
extern NSString    *const  kSignInField60Network ;

//消费的60.1和3域
extern NSString    *const  kPurchaseField60MsgType ;
extern NSString    *const  kPurchaseField3ProcessCode ;

//余额查询的60.1和3域
extern NSString    *const  kBalanceField60MsgType ;
extern NSString    *const  kBalanceField3ProcessCode ;

//IC卡参数/公钥下载结束60.1和60.3域
extern NSString    *const  kICParamOverField60MsgType;
extern NSString    *const  kICPubKeyOverField60Network ;
extern NSString    *const  kICParamOverField60Network ;

//POS状态上送60.1和60.3域
extern NSString    *const  kPosStateField60MsgType ;
extern NSString    *const  kPosStateMagcardField60Network ;
extern NSString    *const  kPosStateICPubKeyField60Network ;
extern NSString    *const  kPosStateICParamField60Network ;

//Pos参数传递
extern NSString    *const  kPosParamField60MsgType ;
extern NSString    *const  kPosParamMagcardField60Network ;
extern NSString    *const  kPosParamICPubKeyField60Network ;
extern NSString    *const  kPosParamICParamField60Network ;

/******************************************************************************/

//响应码
extern NSString    *const  kResponseCodeSuccess00 ;
extern NSString    *const  kResponseCodeCheckIssBankError01;
extern NSString    *const  kResponseCodeInvalidCardError14 ;
extern NSString    *const  kResponseCodeNoFoundError25 ;
extern NSString    *const  kResponseCodePinError55 ;
extern NSString    *const  kResponseCodeError98 ;
extern NSString    *const  kResponseCodePinError99 ;
extern NSString    *const  kResponseCodeMacErrorA0 ;

/******************************************************************************/
@interface PZCustomConstant : NSObject

@end
