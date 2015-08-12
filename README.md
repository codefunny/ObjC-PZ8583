#ObjC-PZ8583

---
ObjC-PZ8583是基于BerTlv和Oscar-ISO8583的基础上进行的iOS封装，底层8583的打包和拆包使用了C语言的Oscar-ISO8583版本，为了适应开发需求，进行了Objective-C的封装，使得使用起来更方便一些，目前在国内这方面的资源还是非常罕见的，在对该代码开源的过程中，我进行了一些删减的工作，主要是一些非银联常见做法的接口，所以大家还是先了解自己的需求，进行一些微调之后再使用。

#开源

---
在开发过程中得益于开源的贡献，大大的帮助了我的开发，这几年在支付领域的开发经验，使我对这方面可能更熟悉一点，所以拿出来晒一晒，如果对你有帮助，欢迎收藏，如有一些好的意见，欢迎加我QQ：504299929讨论。

#使用说明

---
比如签到交易，大家可以在PZTransService中看到

```
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

```


# License

---

MTI