//
//  AddressSelected.m
//  SMS_sos
//
//  Created by GU ZHE on 12-2-20.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import "AddressSelected.h"

@implementation AddressSelected

+ (NSString *)getFullName:(ABRecordRef)person

{
    
    
    
    
    
    CFStringRef name = ABRecordCopyCompositeName(person);
    
    if (name == NULL){
        
        return [NSString stringWithString:@""];
        
    }
    
    
    
    NSString* ret = [NSString stringWithString:(__bridge_transfer  NSString*)name];
    
    
    
//    CFRelease(name);
    
    
    
    return ret;
    
}

+ (NSArray *)getPhones:(ABRecordRef)person

{
    
    NSMutableArray* phoneList = [[NSMutableArray alloc] init] ;
    
    
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);    
    
    if (phones){
        
        int count = ABMultiValueGetCount(phones);
        
        for (CFIndex i = 0; i < count; i++) {
            
            NSString *phoneLabel       = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            
            NSString *phoneNumber      = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            
            
            
           NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
            
            
            
            [phoneList addObject:phoneNumber];
            
            
            

            
        }
        
    }
    
    CFRelease(phones);
    
    return phoneList;
    
}

@end
