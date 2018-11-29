//
//  NSString+SHA.m
//  EncryptAndSignDemo
//
//  Created by LRY on 2018/10/11.
//  Copyright © 2018年 LRY. All rights reserved.
//

#import "NSString+SHA.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SHA)

- (NSString*)sha256
{
//    [self mySha256];
    
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
//    // 这里应该用字节长度、不是字符串长度  self.length错误
    
    // 直接用该方法转化data即可
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]; // 8bit 256/8 = 32
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]]; // 8位二进制对应2位16进制,不足补0
    
    return output;
}

- (void)mySha256
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *digest = [[NSMutableData alloc] initWithLength:CC_SHA256_DIGEST_LENGTH]; // apple example的写法
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest.mutableBytes);
    NSString *str = [[NSString alloc] initWithData:digest encoding:NSUTF16StringEncoding];
    NSLog(@"str:%@", [self hexStringWithData:digest]);
}

- (NSString *)hexStringWithBytes:(const void *)bytes length:(NSUInteger)length {
    NSMutableString *   result;
    
    NSParameterAssert(bytes != nil);
    
    result = [[NSMutableString alloc] initWithCapacity:length * 2];
    for (size_t i = 0; i < length; i++) {
        [result appendFormat:@"%02x", ((const uint8_t *) bytes)[i]];
    }
    return result;
}

- (NSString *)hexStringWithData:(NSData *)data {
    NSParameterAssert(data != nil);
    return [self hexStringWithBytes:data.bytes length:data.length];
}


// *** 有中文，在线加密出来的结果都是这个
- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSUTF8StringEncoding];
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


@end
