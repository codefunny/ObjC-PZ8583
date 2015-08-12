//
//  PZCRSA.h
//  PaylabMPos
//
//  Created by mark zheng on 15/7/2.
//  Copyright (c) 2015年 codefunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZCRSA : NSObject {
    SecKeyRef publicKey;
    SecKeyRef privateKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
- (id)initWithKey:(NSData *)keydata;
- (instancetype)initWithPubKey:(NSData *)data ;

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;

@end

@interface PZCRSA (privatekey)

- (instancetype)initWithPrvKey:(NSData *)data ;

- (NSData *)decryptWithData:(NSData *)cipherString;

@end
