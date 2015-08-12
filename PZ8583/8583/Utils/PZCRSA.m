//
//  PZCRSA.m
//  PaylabMPos
//
//  Created by mark zheng on 15/7/2.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import "PZCRSA.h"

@implementation PZCRSA

- (id)initWithKey:(NSData *)keydata {
    self = [super init];
    
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key"
                                                              ofType:@"der"];
    if (publicKeyPath == nil) {
        NSLog(@"Can not find pub.der");
        return nil;
    }
    
    NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
    if (publicKeyFileContent == nil) {
        NSLog(@"Can not read from pub.der");
        return nil;
    }
    
    certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
    if (certificate == nil) {
        NSLog(@"Can not read certificate from pub.der");
        return nil;
    }
    
    policy = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        NSLog(@"SecTrustEvaluate fail. Error Code: %d", (int)returnCode);
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(trust);
    if (publicKey == nil) {
        NSLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
    return self;
}

- (instancetype)initWithPubKey:(NSData *)data {
    if (self = [super init]) {
        publicKey = [self addPublicKey:data];
        maxPlainLen = SecKeyGetBlockSize(publicKey) ;
    }
    
    return self;
}

- (instancetype)initWithPrvKey:(NSData *)data {
    if (self = [super init]) {
        privateKey = [self addPrivateKey:data];
        maxPlainLen = SecKeyGetBlockSize(privateKey) ;
    }
    
    return self;
}

- (SecKeyRef)addPublicKey:(NSData *)key{
    NSData *data = key;
    if(!data){
        return nil;
    }
    
    NSString *tag = @"what_the_fuck_is_this";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKeyDict = [[NSMutableDictionary alloc] init];
    [publicKeyDict setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKeyDict setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKeyDict setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKeyDict);
    
    // Add persistent version of the key to system keychain
    [publicKeyDict setObject:data forKey:(__bridge id)kSecValueData];
    [publicKeyDict setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKeyDict, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKeyDict removeObjectForKey:(__bridge id)kSecValueData];
    [publicKeyDict removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKeyDict setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKeyDict, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    
    NSLog(@"keyRef:%@",keyRef);
    return keyRef;
}

- (SecKeyRef)addPrivateKey:(NSData *)key{
    NSData *data = key;
    if(!data){
        return nil;
    }
    
    NSString *tag = @"private_key_peter";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKeyDict = [[NSMutableDictionary alloc] init];
    [privateKeyDict setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKeyDict setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKeyDict setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKeyDict);
    
    // Add persistent version of the key to system keychain
    [privateKeyDict setObject:data forKey:(__bridge id)kSecValueData];
    [privateKeyDict setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKeyDict, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKeyDict removeObjectForKey:(__bridge id)kSecValueData];
    [privateKeyDict removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKeyDict setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKeyDict setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKeyDict, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

- (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

- (NSData *) encryptWithData:(NSData *)content {
    size_t plainLen = [content length];
    if (plainLen > maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [content getBytes:plain
               length:plainLen];
    
    size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingNone, plain,
                                        plainLen, cipher, &cipherLen);
    
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    }
    else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

- (NSData *) encryptWithString:(NSString *)content {
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData *)decryptWithData:(NSData *)cipherString {
    size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
    uint8_t* plainBuffer = malloc(plainBufferSize);
    NSData* incomingData = cipherString;
    uint8_t* cipherBuffer = (uint8_t*)[incomingData bytes];
    size_t cipherBufferSize = SecKeyGetBlockSize(privateKey);
    OSStatus returnCode =  SecKeyDecrypt(privateKey,kSecPaddingPKCS1,
                                         cipherBuffer,cipherBufferSize,
                                         plainBuffer,&plainBufferSize);
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyDncrypt fail. Error Code: %d", (int)returnCode);
    } else {
        result = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
    }
    
    return result;
}

- (void)dealloc{
//    CFRelease(certificate);
//    CFRelease(trust);
//    CFRelease(policy);
    CFRelease(publicKey);
}

@end
