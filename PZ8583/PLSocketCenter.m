//
//  PLSocketCenter.m
//  PaylabMPos
//
//  Created by mark zheng on 15/6/1.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PLSocketCenter.h"
#import "AsyncSocket.h"
#import "GCDAsyncSocket.h"

#import "PZMessageUtils.h"

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

static NSString     *const kPospServerIP = @"127.0.0.1";
static NSInteger    kPospServerPort = 10002;

@interface PLSocketCenter () <AsyncSocketDelegate>

@property(nonatomic,strong)AsyncSocket* socket;
@property(nonatomic,strong)NSCondition* condition;
@property(nonatomic,assign)BOOL isRecving;
@property(nonatomic,strong)NSData* recvData;

@property (nonatomic,copy) finishRecvDataFromPosp finishDataFromPosp;

@end

@implementation PLSocketCenter

+ (instancetype)defaultCenter {
    static PLSocketCenter *instance = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (id)init
{
    if((self = [super init]))
    {
        _socket = [[AsyncSocket alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [self.socket disconnect];
    self.socket = nil;
    
    _condition = nil;
}

- (void)logError:(NSString *)msg
{
    [self logMessage:msg];
}

- (void)logInfo:(NSString *)msg
{
    [self logMessage:msg];
}

- (void)logMessage:(NSString *)msg
{
    
    NSLog(@"log:%@",msg);
}

- (BOOL)startStop
{
    NSError *error;
    BOOL result = [self.socket connectToHost:kPospServerIP onPort:kPospServerPort error:&error];
    if (!result) {
        [self logError:FORMAT(@"%@",error)];
    }
    _condition = [[NSCondition alloc] init];
    
    return result;
}

- (BOOL)isConnected {
    return [self.socket isConnected];
}

- (void)didDisconnected {
//    if ([self.socket isConnected]) {
        [self.socket disconnect];
//    }
}

- (void)sendDataToServer:(NSData *)data finishCallBack:(finishRecvDataFromPosp)block {
    self.finishDataFromPosp = block;
    __weak typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^{
            NSInteger dataLen = data.length;
            NSString *hexStr = [NSString stringWithFormat:@"%04lx",(long)dataLen];
            NSData *msgLen = [PZMessageUtils hexToBytes:hexStr];
            
            NSMutableData *sendData = [NSMutableData data];
            [sendData appendData:msgLen];
            [sendData appendData:data];
            [weakSelf.socket writeData:sendData withTimeout:10 tag:0];
            [weakSelf.socket readDataWithTimeout:-1 tag:0];
        });
    });
    
    self.isRecving = true;
}

#pragma mark - AsyncSocketDelegate

/*将要建立连接*/
-(BOOL)onSocketWillConnect:(AsyncSocket *)sock {
    NSLog(@"onSocketWillConnect:");
    return YES;
}

/*成功建立连接*/
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost");
}

/*错误，断开连接*/
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError:%@",err);
}

/*断开连接*/
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"onSocketDidDisconnect");
    self.isRecving = NO;
}

/*
 * 成功接收数据
 */
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"接收数据:%@",data);
    if ([self isRecving]==YES) {
        self.recvData = data;
        self.isRecving = NO;
        if (self.finishDataFromPosp) {
            self.finishDataFromPosp(self.recvData,nil);
        }
    }
    
    NSString *readData = [PZMessageUtils hexStringFromData:data];
    [self logMessage:readData];
}

/*成功写入数据*/
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag:%ld",tag);
}

- (void)readDataWithTimeout:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"网络链接失败!");
    if (self.finishDataFromPosp) {
        self.finishDataFromPosp(nil,err);
    }
}

@end
