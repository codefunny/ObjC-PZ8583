//
//  PZTransService.m
//  PaylabMPos
//
//  Created by mark zheng on 15/6/18.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZTransService.h"

#import "PZMessageUtils.h"
#import "PZCustomConstant.h"
#import "PZSignInRequest.h"
#import "PZSignInResponse.h"
#import "PZPrivateField60.h"

#import "PZPosStateRequest.h"
#import "PZPosStateResponse.h"

#import "PZPosParamRequest.h"
#import "PZPosParamResponse.h"

#import "PZPurchaseRequest.h"
#import "PZPurchaseResponse.h"

#import "PZReverseRequest.h"
#import "PZReverseResponse.h"

#import "NSString+ThreeDes.h"

NSString    *const  kTrkData = @"6227123456180183067=41045204601020000";
NSString    *const  kPanCard = @"6227123456180183067";

@interface PZTransService ()

@property (nonatomic,strong) NSString   *terminalId;
@property (nonatomic,strong) NSString   *merchantId;

@property (nonatomic,strong) NSString   *transTtc;
@property (nonatomic,strong) NSString   *batchNumber;

@end

@implementation PZTransService

+ (instancetype)instance {
    static PZTransService *instanced = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanced = [[PZTransService alloc] init];
    });
    
    return instanced;
}

- (id)init {
    if (self = [super init]) {
        _sockMgr = [PLSocketCenter defaultCenter];
        _terminalId = @"12345678";
        _merchantId = @"123456789123456";
        
        _batchNumber = @"000000";
    }
    
    return self;
}

- (NSString *)transTtc {
    if (!_transTtc) {
        _transTtc = @"000001";
    } else {
        NSInteger   num = [_transTtc integerValue] + 1 ;
        _transTtc = [NSString stringWithFormat:@"%06ld",(long)num];
    }
    
    return _transTtc;
}

- (NSString *)masterKey {
    if (!_masterKey) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"posMasterKey"])
        {
            _masterKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"posMasterKey"];
        }
    }
    
    return _masterKey;
}

- (NSString *)posKey {
    if (!_posKey) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"posKey"])
        {
            _posKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"posKey"];
        }
    }
    
    return _posKey;
}

- (void)mposGetWorkKeyFromServerWithBlock:(void(^)(NSString *text))display {
    display(@"----------------签到-------------");
//    NSString *lmk = @"a2dff4e59289a82fc740f4f4e5d997e6";
    NSString *lmk = self.masterKey;
    BOOL ret =[self.sockMgr startStop];
    if (ret ) {
        PZSignInRequest *request = [PZSignInRequest new];
        [request.posFields setTranTtc:self.transTtc];
        [request.posFields setTerminalId:self.terminalId];
        [request.posFields setMerchantId:self.merchantId];
        PZPrivateField60 *field60 = [PZPrivateField60 new];
        field60.msgType = kSignInField60MsgType;
        field60.batchNumber = self.batchNumber;
        field60.networkCode = kSignInField60Network;
        [request.posFields setPrivate60:[field60 encode]];
        [request setOprNumber:@"01 "];
        
        NSData *data = [request encode];
        NSLog(@"send:%@",data);
        
        display(request.posFields.description);
        
        __block NSData *recvData = nil;
        [self.sockMgr sendDataToServer:data finishCallBack:^(NSData *pospData,NSError *error){
            if (!error) {
                recvData = [pospData subdataWithRange:NSMakeRange(2, pospData.length -2)];
                
                PZSignInResponse  *signResp = [PZSignInResponse new];
                [signResp decode:recvData];
                
                display(signResp.posFields.description);
                
                if ([signResp.respCode isEqualToString:kResponseCodeSuccess00]) {
                    NSLog(@"%@",[signResp.private62 description]);
                    PZPrivateField62    *field62 = signResp.private62;
                    NSString *pinKey = [NSString decrypt3Des:field62.pinKey withKey:lmk];
                    NSString *macKey = [NSString decrypt3Des:field62.macKey withKey:lmk];
                    NSString *trkKey = [NSString decrypt3Des:field62.trkKey withKey:lmk];
                    
                    NSString    *pinCheck = [NSString encrypt3Des:@"0000000000000000" withKey:pinKey];
                    NSString    *macCheck = [NSString encrypt3Des:@"0000000000000000" withKey:macKey];
                    NSString    *trkCheck = [NSString encrypt3Des:@"0000000000000000" withKey:trkKey];
                    
                    NSLog(@"pinkey:%@,check:%@;macKey:%@,check:%@;trkKey:%@,check:%@",pinKey,pinCheck,macKey,macCheck,trkKey,trkCheck);
                    NSString    *log = [NSString stringWithFormat:@"%@\npinkey:%@,check:%@;macKey:%@,check:%@;trkKey:%@,check:%@",[signResp.private62 description],pinKey,pinCheck,macKey,macCheck,trkKey,trkCheck];
                    display(log);
                    
                    self.pinKey = pinKey;
                    self.macKey = macKey;
                    self.trkKey = trkKey;
                    
                } else {
                    NSLog(@"response:%@",signResp.respCode);
                }
            }
            [self.sockMgr didDisconnected];
        }];
    }
}

- (void)mposGetPosICKeyFromServer {
    [self mposGetPosStateFromServerWithNetwork:@"372"];
}

- (void)mposGetPosICParamFromServer {
    [self mposGetPosStateFromServerWithNetwork:@"382"];
}

- (void)mposGetPosStateFromServerWithNetwork:(NSString *)network {
    BOOL ret =[self.sockMgr startStop];
    if (ret ) {
        PZPosStateRequest *request = [PZPosStateRequest new];
        [request.posFields setTerminalId:self.terminalId];
        [request.posFields setMerchantId:self.merchantId];
        PZPrivateField60 *field60 = [PZPrivateField60 new];
        field60.msgType = @"98";
        field60.batchNumber = @"000000";
        field60.networkCode = network;
        [request.posFields setPrivate60:[field60 encode]];
        [request.posFields setPrivate62:@"100"];
        [request setMessageHead:@"610101000000"];
        
        NSData *data = [request encode];
        NSLog(@"send:%@",data);
        
        __block NSData *recvData = nil;
        [self.sockMgr sendDataToServer:data finishCallBack:^(NSData *pospData,NSError *error){
            if (!error) {
                recvData = [pospData subdataWithRange:NSMakeRange(2, pospData.length -2)];
                
                PZPosStateResponse  *signResp = [PZPosStateResponse new];
                [signResp decode:recvData];
                if ([signResp.respCode isEqualToString:kResponseCodeSuccess00]) {
                    NSLog(@"%@",[signResp.posFields private62]);
                    
                    NSString    *field62 = signResp.posFields.private62 ;
                    [signResp parsePosStateField62:field62];
                    
                } else {
                    NSLog(@"response:%@",signResp.respCode);
                }
            }
            [self.sockMgr didDisconnected];
        }];
    }
}

- (void)mposGetICKeyFromServer {
    BOOL ret =[self.sockMgr startStop];
    if (ret ) {
        PZSignInRequest *request = [PZSignInRequest new];
        [request.posFields setTranTtc:self.transTtc];
        [request.posFields setTerminalId:self.terminalId];
        [request.posFields setMerchantId:self.merchantId];
        PZPrivateField60 *field60 = [PZPrivateField60 new];
        field60.msgType = @"00";
        field60.batchNumber = @"000003";
        field60.networkCode = @"372";
        [request.posFields setPrivate60:[field60 encode]];
        [request.posFields setPrivate62:@"100"];
        
        NSData *data = [request encode];
        NSLog(@"send:%@",data);
        
        __block NSData *recvData = nil;
        [self.sockMgr sendDataToServer:data finishCallBack:^(NSData *pospData,NSError *error){
            if (!error) {
                recvData = [pospData subdataWithRange:NSMakeRange(2, pospData.length -2)];
                
                PZSignInResponse  *signResp = [PZSignInResponse new];
                [signResp decode:recvData];
                if ([signResp.respCode isEqualToString:kResponseCodeSuccess00]) {
                    NSLog(@"%@",[signResp.private62 description]);
                } else {
                    NSLog(@"response:%@",signResp.respCode);
                }
            }
            [self.sockMgr didDisconnected];
        }];
    }
}

//消费
- (void)mposPurchaseFromServerWithBlock:(void(^)(NSString *text))display {
    display(@"----------------消费-------------");
    if (!self.pinKey || !self.macKey || !self.trkKey) {
        display(@"请先签到");
        return;
    }
    NSString    *pinkey = self.pinKey;
    NSString    *macKey = self.macKey;
    NSString    *trkKey = self.trkKey;
    
    BOOL  isPinRequire = NO;
    BOOL  isICCard = YES;

    BOOL ret =[self.sockMgr startStop];
    if (ret ) {
        PZPurchaseRequest *request = [PZPurchaseRequest new];
        [request.posFields setProcessCode:kPurchaseField3ProcessCode];
        [request.posFields setCardPan:kPanCard];
        [request.posFields setTranAmount:@"000000000123"];
        [request.posFields setTranTtc:self.transTtc];
        if (isPinRequire) {
            [request.posFields setServerMode:@"021"];
            if (isICCard) {
                [request.posFields setServerMode:@"051"];
            }
            
            [request.posFields setPinCode:@"12"];
        } else {
            [request.posFields setServerMode:@"022"];
            if (isICCard) {
                [request.posFields setServerMode:@"052"];
            }
        }
        
        [request.posFields setConditionMode:@"82"];
        NSString *trk2 = kTrkData;
        NSString *enTrk2 = [NSString trkStr:trk2 withTrkKey:trkKey];
        [request.posFields setTrack2Data:[PZMessageUtils hexToBytes:enTrk2]];
        [request.posFields setTerminalId:self.terminalId];
        [request.posFields setMerchantId:self.merchantId];
        if (isPinRequire) {
            NSString *pin = [NSString pinBlock:@"111111" withCard:kPanCard withPinKey:pinkey];
            [request.posFields setPinData:[PZMessageUtils hexToBytes:pin]];
            [request.posFields setSecurityCode:@"2600000000000000"];
        }
        
        [request.posFields setCurrentCode:@"156"];
        PZPrivateField60 *field60 = [PZPrivateField60 new];
        field60.msgType = kPurchaseField60MsgType;
        field60.batchNumber = self.batchNumber;
        [request.posFields setPrivate60:[field60 encode]];
        [request.posFields setPrivate63:@"0  1234567890123456789812345678901234567898"];
        [request.posFields setMessageMac:@"12345678"];
        
        NSMutableData *data = [[request encode] mutableCopy];
        NSLog(@"send:%@",data);
        
        self.fields = [request.posFields copy];
        
        NSData  *block = [data subdataWithRange:NSMakeRange(11, data.length-11)];
        block = [block subdataWithRange:NSMakeRange(0, block.length-8)];
        NSString    *blockStr = [PZMessageUtils hexStringFromData:block];
        NSString    *macStr = [NSString macBlock:blockStr withMacKey:macKey];
        NSData  *macData = [PZMessageUtils hexToBytes:macStr];
        [data replaceBytesInRange:NSMakeRange(data.length-8, 8) withBytes:[macData bytes] length:8];
        
        NSLog(@"sen1:%@",data);
        __block NSData *recvData = nil;
        [self.sockMgr sendDataToServer:data finishCallBack:^(NSData *pospData,NSError *error){
            if (!error) {
                recvData = [pospData subdataWithRange:NSMakeRange(2, pospData.length -2)];
                
                PZPurchaseResponse  *signResp = [PZPurchaseResponse new];
                [signResp decode:recvData];
                display(signResp.posFields.description);
                
                if ([signResp.respCode isEqualToString:kResponseCodeSuccess00]) {
//                    NSLog(@"%@",[signResp.private62 description]);
                    self.uploadSign = [signResp.posFields copy];
                    
                } else {
                    NSLog(@"response:%@",signResp.respCode);
                }
            }
            [self.sockMgr didDisconnected];
        }];
    }
}

- (void)mposBalanceFromServerWithBlock:(void(^)(NSString *text))display {
    display(@"----------------余额查询-------------");
    if (!self.pinKey || !self.macKey || !self.trkKey) {
        display(@"请先签到");
        return;
    }
    NSString    *pinkey = self.pinKey;
    NSString    *macKey = self.macKey;
    NSString    *trkKey = self.trkKey;

    BOOL ret =[self.sockMgr startStop];
    if (ret ) {
        PZPurchaseRequest *request = [PZPurchaseRequest new];
        [request.posFields setProcessCode:kBalanceField3ProcessCode];
        [request.posFields setCardPan:kPanCard];
        [request.posFields setTranTtc:self.transTtc];
        [request.posFields setServerMode:@"021"];
        [request.posFields setConditionMode:@"00"]; //25#
        [request.posFields setPinCode:@"12"];
        NSString *trk2 = kTrkData;
        NSString *enTrk2 = [NSString trkStr:trk2 withTrkKey:trkKey];
        [request.posFields setTrack2Data:[PZMessageUtils hexToBytes:enTrk2]];
        [request.posFields setTerminalId:self.terminalId];
        [request.posFields setMerchantId:self.merchantId];
        NSString *pin = [NSString pinBlock:@"111111" withCard:kPanCard withPinKey:pinkey];
        [request.posFields setPinData:[PZMessageUtils hexToBytes:pin]];
        [request.posFields setSecurityCode:@"2600000000000000"];
        [request.posFields setCurrentCode:@"156"];
        PZPrivateField60 *field60 = [PZPrivateField60 new];
        field60.msgType = kBalanceField60MsgType;
        field60.batchNumber = self.batchNumber;
        [request.posFields setPrivate60:[field60 encode]];
        [request.posFields setMessageMac:@"12345678"];
        
        NSMutableData *data = [[request encode] mutableCopy];
        NSLog(@"send:%@",data);
        
        NSData  *block = [data subdataWithRange:NSMakeRange(11, data.length-11)];
        block = [block subdataWithRange:NSMakeRange(0, block.length-8)];
        NSString    *blockStr = [PZMessageUtils hexStringFromData:block];
        NSString    *macStr = [NSString macBlock:blockStr withMacKey:macKey];
        NSData  *macData = [PZMessageUtils hexToBytes:macStr];
        [data replaceBytesInRange:NSMakeRange(data.length-8, 8) withBytes:[macData bytes] length:8];
        
        NSLog(@"sen1:%@",data);
        __block NSData *recvData = nil;
        [self.sockMgr sendDataToServer:data finishCallBack:^(NSData *pospData,NSError *error){
            if (!error) {
                recvData = [pospData subdataWithRange:NSMakeRange(2, pospData.length -2)];
                
                PZPurchaseResponse  *signResp = [PZPurchaseResponse new];
                [signResp decode:recvData];
                display(signResp.posFields.description);
                
                if ([signResp.respCode isEqualToString:kResponseCodeSuccess00]) {
                    [signResp parsePosField54:signResp.posFields.balanceAmount];
                } else {
                    NSLog(@"response:%@",signResp.respCode);
                }
            }
            [self.sockMgr didDisconnected];
        }];
    }
}

- (void)mposReverseFromServerWithBlock:(void(^)(NSString *text))display {
    display(@"----------------冲正交易-------------");
    if (!self.macKey) {
        display(@"请先签到");
        return;
    }
    
    NSString    *macKey = self.macKey;
    
    if (!self.fields) {
        display(@"没有需要冲正交易");
        return;
    }

    BOOL ret =[self.sockMgr startStop];
    if (ret ) {
        PZReverseRequest *request = [PZReverseRequest new];
        [request.posFields setProcessCode:self.fields.processCode];
        [request.posFields setCardPan:self.fields.cardPan];
        [request.posFields setTranAmount:self.fields.tranAmount];
        [request.posFields setTranTtc:self.fields.tranTtc];
        [request.posFields setServerMode:self.fields.serverMode];
        [request.posFields setConditionMode:self.fields.conditionMode]; //25#
        [request.posFields setResponseCode:@"98"];
        [request.posFields setTerminalId:self.fields.terminalId];
        [request.posFields setMerchantId:self.fields.merchantId];
        [request.posFields setCurrentCode:self.fields.currentCode];
        [request.posFields setPrivate60:self.fields.private60];
        [request.posFields setMessageMac:@"12345678"];
        
        NSMutableData *data = [[request encode] mutableCopy];
        NSLog(@"send:%@",data);
        
        NSData  *block = [data subdataWithRange:NSMakeRange(11, data.length-11)];
        block = [block subdataWithRange:NSMakeRange(0, block.length-8)];
        NSString    *blockStr = [PZMessageUtils hexStringFromData:block];
        NSString    *macStr = [NSString macBlock:blockStr withMacKey:macKey];
        NSData  *macData = [PZMessageUtils hexToBytes:macStr];
        [data replaceBytesInRange:NSMakeRange(data.length-8, 8) withBytes:[macData bytes] length:8];
        
        NSLog(@"sen1:%@",data);
        __block NSData *recvData = nil;
        [self.sockMgr sendDataToServer:data finishCallBack:^(NSData *pospData,NSError *error){
            if (!error) {
                recvData = [pospData subdataWithRange:NSMakeRange(2, pospData.length -2)];
                
                PZReverseResponse  *signResp = [PZReverseResponse new];
                [signResp decode:recvData];
                display(signResp.posFields.description);
                
                if ([signResp.respCode isEqualToString:kResponseCodeSuccess00]) {
                    
                } else {
                    NSLog(@"response:%@",signResp.respCode);
                }
            }
            self.fields = nil;
            [self.sockMgr didDisconnected];
        }];
    }
}

@end
