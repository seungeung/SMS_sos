//
//  NSTimerController.m
//  SMS_sos
//
//  Created by GU ZHE on 12-3-23.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import "NSTimerController.h"

@implementation NSTimerController

-(void)REco
{
    
}

+(void)nstimerRecorder:(id)sender
{
    
    NSTimeInterval timeInterval = 20.0;
    NSTimer * timeRecorder;
    timeRecorder = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(REco) userInfo:nil repeats:YES];
    
    [timeRecorder fire];
    
    
}




@end
