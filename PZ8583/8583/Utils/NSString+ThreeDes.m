//
//  NSString+ThreeDes.m
//  iso8583_demo
//
//  Created by mark zheng on 15/6/10.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "NSString+ThreeDes.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#import "PZMessageUtils.h"

#define gIv  @""
#define kThreeDesKeyLength 24
#define kSimpleDesKeyLength 8
#define kXorLen     8

unsigned int FindOneInNumber(unsigned char x)
{
    unsigned int n = 0;
    while(x){
        if (x & 0x01) {
            n++;
        }
        x >>= 1;
    }
    
    return n;
}

@implementation NSString (ThreeDes)

+ (NSString*)encryptDes:(NSString*)plainText withKey:(NSString*)key{
    NSData *keyData = [PZMessageUtils hexToBytes:key];
    
    uint8_t *digest = (uint8_t*)[keyData bytes];
    
    uint8_t keyByte[kSimpleDesKeyLength];
    for (int i=0; i<kSimpleDesKeyLength; i++) {
        keyByte[i] = digest[i];
    }
    
    NSData* data = [PZMessageUtils hexToBytes:plainText ];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmDES,
                       kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    NSString *result = [PZMessageUtils hexStringFromData:myData];

    return result;
}

+ (NSString*)decryptDes:(NSString*)encryptText withKey:(NSString*)key {
    
    NSData *data = [PZMessageUtils hexToBytes:key];
    uint8_t *digest = (uint8_t*)[data bytes];
    
    uint8_t keyByte[kSimpleDesKeyLength];
    for (int i=0; i<kSimpleDesKeyLength; i++) {
        keyByte[i] = digest[i];
    }
    
    NSData *encryptData = [PZMessageUtils hexToBytes:encryptText];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];

    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmDES,
                       kCCOptionECBMode,
                       vkey,
                       kCCKeySizeDES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);

    
    NSData *dataresult = [NSData dataWithBytes:(const void *)bufferPtr
                                        length:(NSUInteger)movedBytes];
    free(bufferPtr);
    
    NSString *result = [PZMessageUtils hexStringFromData:dataresult];
    
    return result;
}

+ (NSString *)decrypt3Des:(NSString *)plainText withKey:(NSString *)key {
    NSData *data = [PZMessageUtils hexToBytes:key];
    uint8_t *digest = (uint8_t*)[data bytes];
    
    uint8_t keyByte[kThreeDesKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData *encryptData = [PZMessageUtils hexToBytes:plainText];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    NSData *dataresult = [NSData dataWithBytes:(const void *)bufferPtr
                                        length:(NSUInteger)movedBytes];
    free(bufferPtr);
    
    NSString *result = [PZMessageUtils hexStringFromData:dataresult];
    
    return result;
}

+ (NSString *)encrypt3Des:(NSString *)plainText withKey:(NSString *)key {
    NSData *keyData = [PZMessageUtils hexToBytes:key];
    
    uint8_t *digest = (uint8_t*)[keyData bytes];
    
    uint8_t keyByte[kThreeDesKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData* data = [PZMessageUtils hexToBytes:plainText ];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    NSString *result = [PZMessageUtils hexStringFromData:myData];
    
    return result;
}

+ (NSString *)dataXor:(NSString *)data1 withData:(NSString *)data2 {
    NSData *data = [PZMessageUtils hexToBytes:data1];
 
    char *dataPtr = (char *) [data bytes];

    char *keyData = (char *) [[PZMessageUtils hexToBytes:data2] bytes];

    char *keyPtr = keyData;
    
    char xorOut[kXorLen];

    for (int i = 0; i < kXorLen; i++)
    {
        xorOut[i] = *dataPtr++ ^ *keyPtr++;
    }
    
    NSData *result = [NSData dataWithBytes:xorOut length:kXorLen];
    return [[PZMessageUtils hexStringFromData:result] uppercaseString];
}

- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *) randomNumberWithLength:(NSInteger)length {
    NSArray  *hexNumber = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"A",@"B",@"C",@"D",@"E",@"F"];
    
    NSMutableString     *output = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        int x = arc4random() % 16;
        if (i > 0) {
            NSString    *preNumber = [output substringWithRange:NSMakeRange(i-1, 1)];
            if ([preNumber isEqualToString:hexNumber[x]]) {
                if ([hexNumber[x] isEqualToString:@"0"]) {
                    [output appendFormat:@"%@",hexNumber[x+1]];
                    continue;
                }
            }
        }
        [output appendFormat:@"%@",hexNumber[x]];
    }
    
    return output;
}

+ (NSString *) randomNumberWithLengthAndParityCheck:(NSInteger)length {
    if (length % 2) {
        return nil;
    }
    
    NSString    *output = [self randomNumberWithLength:length];
    output = [NSString stringWithFormat:@"EF%@",[output substringFromIndex:2]];
    NSData      *byteData = [PZMessageUtils hexToBytes:output];
    
    NSInteger len = byteData.length + 1;
    NSInteger oneNum = 0;
    char *bufferPtr = malloc(sizeof(char) * len);
    memset(bufferPtr, 0, len);
    memcpy(bufferPtr, [byteData bytes], len);
    for (int i = 0; i < len-1; i++) {
        char m = bufferPtr[i] & 0xFE;
        
        oneNum = FindOneInNumber(m);

        if (oneNum%2 == 0) {
            bufferPtr[i] |= 0x01;
        } else {
            bufferPtr[i] = m;
        }
        
//        NSLog(@"char:%0x,new:%0x,one:%d",m,bufferPtr[i],oneNum);
    }
    
    NSData  *retData = [NSData dataWithBytes:bufferPtr length:len-1];
    NSString    *result = [PZMessageUtils hexStringFromData:retData];
    free(bufferPtr);
    
    return result;
}

+ (NSString *)base64StringFromText:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }     
    return result;
}

+ (NSData *)textFromBase64String:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return theData;
}

+ (NSString *)macBlock:(NSString *)pack withMacKey:(NSString *)macKey {
    NSInteger   perNum = 16;
    NSInteger   padNum = perNum - [pack length]%perNum;
    NSString    *padStr = [@"0000000000000000" substringToIndex:padNum];
    NSString    *packBlock = [NSString stringWithFormat:@"%@%@",pack,padStr];
    
    NSInteger   blockNum = packBlock.length/perNum;
    
    NSString    *first = @"0000000000000000";
    for (int i = 0; i < blockNum; i++) {
        NSRange  range = NSMakeRange(i*perNum, perNum);
        NSString  *temp = [[packBlock substringWithRange:range] uppercaseString];
        first = [self dataXor:first withData:temp];
    }
    
    NSString    *blockStr = [PZMessageUtils asciiToHex:first];
    
    NSString    *blockStr1 = [blockStr substringWithRange:NSMakeRange(0, blockStr.length/2)];
    NSString    *blockStr2 = [blockStr substringWithRange:NSMakeRange(blockStr.length/2, blockStr.length/2)];
    
    
    NSString    *mac1 = [NSString encrypt3Des:blockStr1 withKey:macKey];
    NSString    *mac1Xor = [self dataXor:mac1 withData:blockStr2];
    NSString    *mac2 = [NSString encrypt3Des:mac1Xor withKey:macKey];
    
    NSString    *macStr = [PZMessageUtils asciiToHex:[[mac2 substringToIndex:8] uppercaseString]];
    
    return macStr;
}

+ (NSString *)genMacWithMacBlock:(NSString *)block withMacKey:(NSString *)macKey {
    NSString    *first = block;
    
    NSString    *blockStr = [PZMessageUtils asciiToHex:first];
    
    NSString    *blockStr1 = [blockStr substringWithRange:NSMakeRange(0, blockStr.length/2)];
    NSString    *blockStr2 = [blockStr substringWithRange:NSMakeRange(blockStr.length/2, blockStr.length/2)];
    
    
    NSString    *mac1 = [NSString encrypt3Des:blockStr1 withKey:macKey];
    NSString    *mac1Xor = [self dataXor:mac1 withData:blockStr2];
    NSString    *mac2 = [NSString encrypt3Des:mac1Xor withKey:macKey];
    
    NSString    *macStr = [PZMessageUtils asciiToHex:[[mac2 substringToIndex:8] uppercaseString]];
    
    return macStr;
}

+ (NSString *)pinBlock:(NSString *)password withCard:(NSString *)panNum withPinKey:(NSString *)pinkey {
    if (password.length < 6 || password.length > 12) {
        return nil;
    }
    
    if (panNum.length < 13) {
        return nil;
    }
    
    NSString *pin = [NSString stringWithFormat:@"06%@FFFFFFFF",password];
    
    NSRange range = NSMakeRange(panNum.length - 13, 12);
    NSString *pan = [NSString stringWithFormat:@"0000%@",[panNum substringWithRange:range]];
    
    NSString *xor = [[self dataXor:pin withData:pan] uppercaseString];
    
    NSString    *pindata = [NSString encrypt3Des:xor withKey:pinkey];
    
    return pindata;
}

+ (NSString *)trkStr:(NSString *)trkStr withTrkKey:(NSString *)trkKey {
    NSInteger   perNum = 16;
    NSInteger   trkLen = [trkStr length];
    NSInteger   padNum = perNum - trkLen%perNum - 2;
    NSString    *padStr = [@"0000000000000000" substringToIndex:padNum];
    NSString    *replaceTrkStr = [trkStr stringByReplacingOccurrencesOfString:@"=" withString:@"D"];
    NSString    *packBlock = [NSString stringWithFormat:@"%02d%@%@",(int)trkLen,replaceTrkStr,padStr];
    
    NSString    *encryptData = [NSString encrypt3Des:packBlock withKey:trkKey];
    
    return encryptData;
}

+ (NSString *)buildRsaPubKeyByModulus:(NSString *)modulus andExponent:(NSString *)exponent {
    //@"30818902818100%@0203010001"
    NSString  *expStr = exponent.length%2 ? [NSString stringWithFormat:@"0%@",exponent] : exponent;
    NSString  *expStrWithLen = [NSString stringWithFormat:@"02%02d%@",(int)expStr.length/2,expStr];
    
    NSString  *modStr = [NSString stringWithFormat:@"00%@",modulus];
    NSString  *modStrWithLen = [NSString stringWithFormat:@"0281%02x%@",(int)modStr.length/2,modStr];
    
    NSString  *modExpStr = [NSString stringWithFormat:@"%@%@",modStrWithLen,expStrWithLen];
    NSString  *result = [NSString stringWithFormat:@"3081%02x%@",(int)modExpStr.length/2,modExpStr];
    
    return result;
}

@end
