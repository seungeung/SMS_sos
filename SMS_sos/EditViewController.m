//
//  EditViewController.m
//  SMS_sos
//
//  Created by GU ZHE on 12-2-12.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import "EditViewController.h"



static NSString *kAddressName = @"addressNameKey";
static NSString *kAddressNumber = @"addressNumberKey";

@implementation EditViewController
@synthesize addressAra;
@synthesize delegate;
@synthesize iStableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    NSLog(@"%@",addressAra);
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (addressAra == nil) {
        self.addressAra = [NSMutableArray arrayWithCapacity:100];
        
    }
    
    /*
    self.addressAra = [NSMutableArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:
                            @"我",kAddressName,
                            @"13516271116",kAddressNumber,
                            nil]
                       , nil];
     */
    
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.addressAra = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - buttonAction

-(IBAction)popover
{
    [self.delegate didFinishedAddressArrayDelegate:self :addressAra];
}
-(IBAction)addNumber
{
    [self showPeoplePickerController];
}
-(IBAction)reloadTableView:(id)sender
{
//    NSLog(@"");
}

#pragma mark - tableSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([addressAra count] == 0 ) 
    {
        return 1;
    }
    return [addressAra count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    static NSString *MyIdentifier = @"MyIdentifier";
	
	// Try to retrieve from the table view a now-unused cell with the given identifier.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	// If no cell is available, create a new one using the given identifier.
	if (cell == nil) {
		// Use the default cell style.
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

        cell.showsReorderControl = YES;
        
    
    }
	
	// Set up the cell.
    if ([addressAra count] == 0) 
    {
        cell.textLabel.text = [NSString stringWithFormat:@"请添加报警联系人"];
    }
    else
    {
        cell.textLabel.text = [[addressAra objectAtIndex:indexPath.row] objectForKey:kAddressNumber];
        cell.detailTextLabel.text = [[addressAra objectAtIndex:indexPath.row]objectForKey:kAddressName];
    }
	
	return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"报警联系人"];
}


#pragma mark -手指拖动删除

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    NSLog(@"点击了编辑"); 
    [addressAra removeObjectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.iStableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
} 
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    // 
    NSLog(@"手指撮动了"); 
    return UITableViewCellEditingStyleDelete; 
} 
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    return  @"删除"; 
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    return YES; 
} 
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath { 
    return YES; 
} 


#pragma mark - addressContact

-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    picker.title = [NSString stringWithFormat:@"添加联系人"];
    
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonFirstNameProperty],
                               [NSNumber numberWithInt:kABPersonLastNameProperty],
                               [NSNumber numberWithInt:kABPersonMiddleNameProperty],nil];
	
	
	picker.displayedProperties = displayedItems;
	// Show the picker 
	[self presentModalViewController:picker animated:YES];

}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
{

//    NSString *name = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    

    /*
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    ABMultiValueRef Firstname = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//    ABMultiValueRef Familyname = ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    
    if (phones){
//        int count = ABMultiValueGetCount(phones);
//        NSLog(@"%i",count);
       
            NSString *phoneLabel       = (__bridge  NSString *)Firstname;
        
            NSString *phoneNumber      = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
            
            NSLog(@"phone label (%@), number (%@)", phoneLabel, phoneNumber);
            
        [self.addressAra addObject:[NSDictionary dictionaryWithObjectsAndKeys:phoneLabel,kAddressName,
                                    phoneNumber,kAddressNumber, nil]];


    }


    [peoplePicker dismissModalViewControllerAnimated:YES];
    [self.iStableView reloadData];
     */
    return YES;
}
// 确定联系人的名称和号码
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    NSString *name = [AddressSelected getFullName:person];
    
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(CFIndex i = 0; i < ABMultiValueGetCount(multiPhones); i++) {
            if(identifier == ABMultiValueGetIdentifierAtIndex (multiPhones, i)) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
//                CFRelease(multiPhones);
                NSString *phoneNumber = (__bridge_transfer NSString *) phoneNumberRef;
//                CFRelease(phoneNumberRef);
                
                [self.addressAra addObject:[NSDictionary dictionaryWithObjectsAndKeys:name,kAddressName,
                                                                                      [NSString stringWithFormat:@"%@",phoneNumber],kAddressNumber,nil]];
//                NSLog(@"3:%@",[NSString stringWithFormat:@"%@", phoneNumber]);
                
            }
        }
    }
    
    
    
//    NSLog(@"%@",name);
    

   /* 
    ABMultiValueRef phoneProperty = ABRecordCopyValue(person,property);
	NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneProperty,identifier);
	
    NSLog(@"2:%@",phone);
    */
    [self.iStableView reloadData];
               
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}
@end

















