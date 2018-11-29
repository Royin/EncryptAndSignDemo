//
//  ViewController.m
//  EncryptAndSignDemo
//
//  Created by LRY on 2018/10/8.
//  Copyright © 2018年 LRY. All rights reserved.
//

#import "ViewController.h"
#import "EncryptSignTool.h"
#import "NSString+SHA.h"

@interface ViewController ()

@end

@implementation ViewController

-(NSString *)str {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSDictionary *dic = @{
//                          @1:[self str],
//                          @2:@"",
//                          @3:@""
//                          };
    
    NSString *info = @"“info0”于”2018年3月18日 18点18分18秒”在”地球圈”发起借款项目标的号”1818”,借款”1000元”,”银河系可见”,年化”10%”,时间”60”天,募集”3”天后计算利息,借款用于”装修房子”,”接受担保”.";
    
    NSString *infoMD5 = [EncryptSignTool MD5StringFrom:info];
    NSLog(@"infoMD5:\n%@", infoMD5);
    
    NSString *doubleMD5 = [EncryptSignTool doubleMD5WithAppend:@"666" from:info];
    NSLog(@"doubleMD5:\n%@", doubleMD5);
    
    NSString *doubleDES = [EncryptSignTool doubleEncryptUseDES:info key:@"12345678" append:@"1234"];
    NSLog(@"doubleDES:\n%@", doubleDES);
    
    NSString *doubleDescrpt = [EncryptSignTool doubleDecryptUseDES:doubleDES key:@"12345678" delect:@"1234"];
    NSLog(@"doubleDescrpt:\n%@", doubleDescrpt);
    
    
    NSString *num = @"002";
    NSString *numMD5 = [EncryptSignTool MD5StringFrom:num];
    NSLog(@"numMD5:%@", numMD5);
    
    
    NSString *sha = @"hello world加上中文";
    NSString *shaStr = [sha sha256];
    NSString *shaStr2 = [sha SHA256];
    
    NSString *doubleShaStr = [EncryptSignTool doubleSHA256WithAppend:@"45679731" from:sha];
    
    NSLog(@"sha256:\n%@", shaStr);
    NSLog(@"SHA256:\n%@", shaStr2);
    NSLog(@"DoubleSHA256:\n%@", doubleShaStr);
    
//    NSString *zhongwen = @"脑立方";
//    NSString *yingwen = @"yin";
//    const char *cstr1 = [zhongwen cStringUsingEncoding:NSUTF8StringEncoding];
//    const char *cstr2 = [yingwen cStringUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"zhong wen length:%lu %lu", (unsigned long)zhongwen.length, strlen(cstr1));
//    NSLog(@"zhong wen length:%lu %lu", (unsigned long)yingwen.length, strlen(cstr2));
//    // length 个数  strlen byte字节  一个汉字对应三个字节  一个英文字母一个字节
//    NSData *zhongwenData = [zhongwen dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *yingwenData = [yingwen dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"zhongwenData:%lu yingwenData:%lu ", zhongwenData.length, yingwenData.length);
//    NSLog(@"zhongwenData:%lu yingwenData:%lu ", zhongwen.length, yingwen.length);
    // data.length 多少个字节
    // string.length 多少个（汉字、字母）
    // strlen(cstr1)) 多少个字节
    
//
//    NSArray *numbers = [self createArrayWithCount:1000];
//
//
//    var bytes = [Int8](repeating: 0, count: 10)
//    let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
//
//    if status == errSecSuccess { // Always test the status.
//        print(bytes)
//        // Prints something different every time you run.
//    }
    
    
    
    // RSA
    NSData* tag = [@"com.example.keys.mykey" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* attributes =
    @{ (id)kSecAttrKeyType:               (id)kSecAttrKeyTypeRSA,
       (id)kSecAttrKeySizeInBits:         @2048,
       (id)kSecPrivateKeyAttrs:
           @{ (id)kSecAttrIsPermanent:    @YES,
              (id)kSecAttrApplicationTag: tag,
              },
       };
    CFErrorRef error = NULL;
    SecKeyRef privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes,&error);
    if (!privateKey) {
        NSError *err = CFBridgingRelease(error);  // ARC takes ownership
        // Handle the error. . .
    }
    
    SecKeyRef publicKey = SecKeyCopyPublicKey(privateKey);
    
    SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSAEncryptionOAEPSHA512;
    
    NSData* plainText = [@"我是谁是谁是谁" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* cipherText = nil;
    cipherText = (NSData*)CFBridgingRelease(      // ARC takes ownership
                                            SecKeyCreateEncryptedData(publicKey,
                                                                      algorithm,
                                                                      (__bridge CFDataRef)plainText,
                                                                      &error));
    
    NSData* clearText = nil;
    clearText = (NSData*)CFBridgingRelease(       // ARC takes ownership
                                           SecKeyCreateDecryptedData(privateKey,
                                                                     algorithm,
                                                                     (__bridge CFDataRef)cipherText,
                                                                     &error));
    
    NSLog(@"%@", cipherText);
    NSLog(@"%@", [[NSString alloc] initWithData:clearText encoding:NSUTF8StringEncoding]);
    
    
    if (publicKey)  { CFRelease(publicKey);  }
    if (privateKey) { CFRelease(privateKey); }
}

-(NSArray *)createArrayWithCount:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        array[i] = @(i);
    }
    return array;
}

-(void)createRandomNumber {
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /*
     */
    
    NSString *msg = @"放假放假我佛家氛围街坊邻居未来房价未来房价了解了解立即分解为飞机无法接文件foe我家房屋交付了交付劳务费奖励经费金额分解为分离焦虑积分为来访记录文件而飞机文件发放金额为了附件为了房间里微积分";
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:cancle];
    [ac addAction:sure];
    
    [self presentViewController:ac animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
