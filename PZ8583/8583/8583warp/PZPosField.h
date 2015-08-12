//
//  PZField.h
//  iso8583_demo
//
//  Created by mark zheng on 15/6/11.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************************************/
@interface PZPosField : NSObject<NSCopying>

@property (nonatomic, strong) NSString  *messageType;  //0
@property (nonatomic, strong) NSString  *bitmap;    //1
@property (nonatomic, strong) NSString  *cardPan; //2
@property (nonatomic, strong) NSString  *processCode; //3
@property (nonatomic, strong) NSString  *tranAmount; //4
@property (nonatomic, strong) NSString  *tranTtc;  // 11
@property (nonatomic, strong) NSString  *tranTime;  //12
@property (nonatomic, strong) NSString  *tranDate;  //13
@property (nonatomic, strong) NSString  *expireDate; //14
@property (nonatomic, strong) NSString  *settDate;  //15
@property (nonatomic, strong) NSString  *serverMode;  //22
@property (nonatomic, strong) NSString  *conditionMode; //25
@property (nonatomic, strong) NSString  *pinCode;   //26
@property (nonatomic, strong) NSString  *acqCode;   //32
@property (nonatomic, strong) id        track2Data;    //35
@property (nonatomic, strong) id        track3Data;    //36
@property (nonatomic, strong) NSString  *referenceNum;  //37
@property (nonatomic, strong) NSString  *authCode;      //38
@property (nonatomic, strong) NSString  *responseCode;  //39
@property (nonatomic, strong) NSString  *terminalId;    //41
@property (nonatomic, strong) NSString  *merchantId;    //42
@property (nonatomic, strong) NSString  *aditionRespData; //44
@property (nonatomic, strong) NSString  *private48;         //48
@property (nonatomic, strong) NSString  *currentCode;       //49
@property (nonatomic, strong) id        pinData;           //52
@property (nonatomic, strong) NSString  *securityCode;      //53
@property (nonatomic, strong) NSString  *balanceAmount;     //54
@property (nonatomic, strong) id        icCardData;         //55
@property (nonatomic, strong) NSString  *private60;         //60
@property (nonatomic, strong) NSString  *originMessage;     //61
@property (nonatomic, strong) id        private62;     //62
@property (nonatomic, strong) NSString  *private63;     //63
@property (nonatomic, strong) NSString  *messageMac;    //64

@property (nonatomic,readonly,strong) NSDictionary   *mapDict;   //dictionary

@end
/******************************************************************************/
