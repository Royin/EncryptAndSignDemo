//
//  EncryptSignTool.h
//  EncryptAndSignDemo
//
//  Created by LRY on 2018/10/8.
//  Copyright © 2018年 LRY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptSignTool : NSObject

// MD5
+(NSString *)MD5StringFrom:(NSString *)text;

// MD5 + 拼接字符 + 再次MD5
+(NSString *)doubleMD5WithAppend:(NSString *)string from:(NSString *)text;

// DES加密方法
+(NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;
// DES解密方法
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;

// DES + 拼接字符 + DES
+(NSString *)doubleEncryptUseDES:(NSString *)plainText key:(NSString *)key append:(NSString *)string;

// 双DES解密方法
+(NSString *)doubleDecryptUseDES:(NSString *)cipherText key:(NSString *)key delect:(NSString *)string;


// SHA256
+(NSString *)SHA256From:(NSString *)plainText;

// SHA256 + 拼接字符 + 再次SHA256
+(NSString *)doubleSHA256WithAppend:(NSString *)string from:(NSString *)text;

@end
