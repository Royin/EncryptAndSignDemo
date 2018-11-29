//
//  Base64.h
//  IDealBorrow
//
//  Created by yes on 2017/4/13.
//  Copyright © 2017年 ideal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+(NSString *)encode:(NSData *)data;

+(NSData *)decode:(NSString *)data;
@end
