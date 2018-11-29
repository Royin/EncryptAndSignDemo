//
//  EncryptSignTool.m
//  EncryptAndSignDemo
//
//  Created by LRY on 2018/10/8.
//  Copyright © 2018年 LRY. All rights reserved.
//

#import "EncryptSignTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import "Base64.h"

@implementation EncryptSignTool

// MD5
+(NSString *)MD5StringFrom:(NSString *)text
{
    const char *cstr = [text UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// MD5 + 拼接字符 + 再次MD5
+(NSString *)doubleMD5WithAppend:(NSString *)string from:(NSString *)text {
    NSString *md5First = [self MD5StringFrom:text];
    NSString *md5AppendString = [md5First stringByAppendingString:string];
    NSString *md5Second = [self MD5StringFrom:md5AppendString];
    return md5Second;
}


const Byte iv[] = {1,2,3,4,5,6,7,8};

#pragma mark- DES加密算法
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [textData length];
    
    
    size_t dataOutAvailable = dataLength + kCCBlockSizeDES;
    
    unsigned char buffer[dataOutAvailable];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, dataOutAvailable,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        //        ciphertext = [DesEncrypt hexStringFromData:data];
        ciphertext = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        
        NSLog(@" %lu %lu", (unsigned long)dataLength, dataLength + kCCBlockSizeDES);
        
        NSLog(@"---%d %zu", cryptStatus, numBytesEncrypted);
    }
    return ciphertext;
}

#pragma mark- DES解密算法
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [Base64 decode:cipherText];
    unsigned char buffer[10240];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    // kCCOptionPKCS7Padding|kCCOptionECBMode 最主要在这步
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 10240,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
        //        NSLog(@"---------- %@", plaintext);
    }
    return plaintext;
}


// DES + 拼接字符 + DES
+(NSString *)doubleEncryptUseDES:(NSString *)plainText key:(NSString *)key append:(NSString *)string {
    NSString *des1 = [self encryptUseDES:plainText key:key];
    NSString *des1AppendString = [string stringByAppendingString:des1];
    NSString *des2 = [self encryptUseDES:des1AppendString key:key];
    return des2;
}

// 双DES解密方法
+(NSString *)doubleDecryptUseDES:(NSString *)cipherText key:(NSString *)key delect:(NSString *)string {
    NSString *decrypt1 = [self decryptUseDES:cipherText key:key];
    
    NSLog(@"decrypt1:\n%@", decrypt1);
    
    NSString *descryptDelectString = [decrypt1 stringByReplacingOccurrencesOfString:string withString:@""];
    
    NSString *decrypt2 = [self decryptUseDES:descryptDelectString key:key];
    return decrypt2;
}



+(NSString *)SHA256From:(NSString *)plainText
{
    const char *s = [plainText cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)]; // 还是slef.length？有中文两种结果不一样
    
    //    NSData *keyData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

// SHA256 + 拼接字符 + 再次SHA256
+(NSString *)doubleSHA256WithAppend:(NSString *)string from:(NSString *)text {
    NSString *shaFirst = [self SHA256From:text];
    NSString *shaAppendString = [shaFirst stringByAppendingString:string];
    NSString *shaSecond = [self SHA256From:shaAppendString];
    return shaSecond;
}

@end
