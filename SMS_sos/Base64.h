//
//  Base64.h
//  SMS_sos
//
//  Created by GU ZHE on 12-6-12.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
/*
 * Data转换为字符串
 */
+(NSString *) data2String:(NSData *)data;

/*
 * 字符串转换为Data
 */
+(NSData *) string2Data:(NSString *)string;
@end



