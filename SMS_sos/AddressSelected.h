//
//  AddressSelected.h
//  SMS_sos
//
//  Created by GU ZHE on 12-2-20.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressSelected : NSObject

// get full name of contact

+ (NSString *)getFullName:(ABRecordRef)person;

// get all phone numbers of one contact

+ (NSArray *)getPhones:(ABRecordRef)person;

@end
