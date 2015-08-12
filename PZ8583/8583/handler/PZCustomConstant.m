//
//  PZCustomConstant.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/16.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZCustomConstant.h"

/******************************************************************************/
//签到的60.1和60.3域
NSString    *const  kSignInField60MsgType = @"00";
NSString    *const  kSignInField60Network = @"003";

//消费的60.1和3域
NSString    *const  kPurchaseField60MsgType = @"00";
NSString    *const  kPurchaseField3ProcessCode = @"300000";

//余额查询的60.1和3域
NSString    *const  kBalanceField60MsgType = @"00";
NSString    *const  kBalanceField3ProcessCode = @"300000";

//IC卡参数/公钥下载结束60.1和60.3域
NSString    *const  kICParamOverField60MsgType = @"00";
NSString    *const  kICPubKeyOverField60Network = @"003";
NSString    *const  kICParamOverField60Network = @"003";

//POS状态上送60.1和60.3域
NSString    *const  kPosStateField60MsgType = @"00";
NSString    *const  kPosStateMagcardField60Network = @"003";
NSString    *const  kPosStateICPubKeyField60Network = @"003";
NSString    *const  kPosStateICParamField60Network = @"003";

//Pos参数传递
NSString    *const  kPosParamField60MsgType = @"96";
NSString    *const  kPosParamMagcardField60Network = @"003";
NSString    *const  kPosParamICPubKeyField60Network = @"003";
NSString    *const  kPosParamICParamField60Network = @"003";

/******************************************************************************/

//响应码
NSString    *const  kResponseCodeSuccess00 = @"00";
NSString    *const  kResponseCodeMacErrorA0 = @"A0";
NSString    *const  kResponseCodePinError99 = @"99";
NSString    *const  kResponseCodePinError55 = @"55";
NSString    *const  kResponseCodeError98 = @"98";
NSString    *const  kResponseCodeNoFoundError25 = @"25";
NSString    *const  kResponseCodeInvalidCardError14 = @"14";
NSString    *const  kResponseCodeCheckIssBankError01 = @"01";

/******************************************************************************/
@implementation PZCustomConstant

@end
