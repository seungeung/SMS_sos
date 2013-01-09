//
//  EditViewController.h
//  SMS_sos
//
//  Created by GU ZHE on 12-2-12.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressSelected.h"

@class EditViewController;

@protocol addressArrayDelegate <NSObject>

-(void)didFinishedAddressArrayDelegate:(EditViewController *)controller:(NSMutableArray*)mutableArray;

@end

@interface EditViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>{
    NSMutableArray *addressAra;

}
@property (nonatomic,weak) IBOutlet id<addressArrayDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *addressAra;
@property (nonatomic,strong)IBOutlet UITableView *iStableView;

-(IBAction)popover;
-(IBAction)addNumber;
-(IBAction)reloadTableView:(id)sender;

-(void)showPeoplePickerController;





@end
