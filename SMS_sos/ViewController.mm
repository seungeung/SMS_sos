//
//  ViewController.m
//  SMS_sos
//
//  Created by GU ZHE on 12-2-12.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import "ViewController.h"

static NSString *kAddressName = @"addressNameKey";
static NSString *kAddressNumber = @"addressNumberKey";

static NSString *mapabcKey = @"c2b0f58a6f09cafd1503c06ef08ac7aeb7ddb91a7f10ecb2c9e4a36ca9ca54799075ef376d0835e0";

@implementation ViewController

@synthesize latitude,longitude,accuracy;
@synthesize tbrButton;
@synthesize mapView;
@synthesize addressArray;
@synthesize adrArray;
@synthesize locManager;
//@synthesize geoHeXie;
//@synthesize poiXY;
//@synthesize options;



#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addressArray = [NSMutableArray arrayWithCapacity:100];

    
//    经纬度坐标显示
    
    self.mapView.showsUserLocation = YES;
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.distanceFilter = 1.0f;
        
        [self.locManager startUpdatingLocation];
        
        MKCoordinateSpan theSpan;
        //地图的范围 越小越精确
        theSpan.latitudeDelta=0.05;
        theSpan.longitudeDelta=0.05;
        MKCoordinateRegion theRegion;
        theRegion.center=[[locManager location] coordinate];
        theRegion.span=theSpan;
        [mapView setRegion:theRegion];
        [mapView setCenterCoordinate:locManager.location.coordinate animated:YES];
//        [locationManager release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位功能尚未开启，是否开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
        alert.tag = 1004;
        [alert show];
    }

    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.addressArray = nil;    
}

#pragma mark - SMS

-(IBAction)showSMSPicker:(id)sender {
    //	The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later. 
    //	So, we must verify the existence of the above class and log an error message for devices
    //		running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support 
    //		MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil)
    { 			
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) 
        {
			[self displaySMSComposerSheet];
		}
		else 
        {	
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的设备不支持短信功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的设备不支持短信功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//短信内容确定

-(void)displaySMSComposerSheet 
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    //    确定联系人和短信内容
    if (addressArray == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请添加报警联系人" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        picker.recipients = addressArray;
    }
    
    
    picker.body = @"test";
    if (accuracy.text != nil) {
        picker.body =   [NSString stringWithFormat:@"我在:%@附近(位置不精确)坐标%@,%@求帮助!",accuracy.text,self,latitude.text,self.longitude.text]; 
    }
	
	[self presentModalViewController:picker animated:YES];
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
    //    短信状态的筛选
	switch (result)
	{
		case MessageComposeResultCancelled:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否取消发送" delegate:self  cancelButtonTitle:@"继续发送" otherButtonTitles:@"取消发送", nil];
            alert.tag = 1001;
            [alert show];
            break;
        }
		case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的短信成功发送" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 1002;
            [alert show];
			
            break;
        }
		case MessageComposeResultFailed:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的短信发送失败，是否重新发送" delegate:self cancelButtonTitle:@"取消发送" otherButtonTitles:@"重新发送", nil];
            [alert show];
            break;
        }
		default:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的短信发送失败，是否重新发送" delegate:self cancelButtonTitle:@"取消发送" otherButtonTitles:@"重新发送", nil];
            [alert show];
            break;
        }
	}
	
}
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001)
    {
        if (buttonIndex == 1) 
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 1002) 
    {
        if (buttonIndex == 0 ) {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 1003 ||alertView.tag == 1004)
    {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];

        }
    }
    else
    {
        if (buttonIndex == 1) 
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

#pragma mark -arrayFeedBack

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"delegateIsReady"])
    {
//        [[segue destinationViewController] setDelegate:self];
//        NSLog(@"%@",adrArray);
//        [[segue destinationViewController] setAddressAra:adrArray];
        
        EditViewController *viewController = [segue destinationViewController];
        viewController.delegate = self;
        viewController.addressAra = self.adrArray;
    }
}



-(void)didFinishedAddressArrayDelegate:(EditViewController *)controller :(NSMutableArray *)mutableArray
{
    if ([mutableArray count] != 0) 
    { 
        NSMutableArray *temparray =[[NSMutableArray alloc] init];
        
        for (NSDictionary *element in mutableArray) 
        {
            [temparray addObject:[element objectForKey:kAddressNumber]];
            
        }
        
        self.addressArray = [NSArray arrayWithArray:temparray];
        self.adrArray = mutableArray;


    }
    
       
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - mapTools

-(IBAction)reloadLocation:(id)sender
{
    [self.locManager startUpdatingLocation];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:self.accuracy.text,@"test", nil];

    ASIHTTPRequest * request = [DataProvider getASISOAP11Request:nil webServiceFile:nil xmlNameSpace:nil webServiceName:nil wsParameters:tmpArray];
    
    [request setDelegate:self]; 
    [request startAsynchronous];
    
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
//    NSData *tmpData = [data];
    NSString * strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strData);

    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alertView show];
}
-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request description]);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    截图用：
//    newLocation.coordinate.latitude = 39.10563200;
    
    
//    self.longitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//    self.latitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
//    self.geoHeXie = [MSearch MSearchWithKey:mapabcKey delegate:self];
    self.accuracy.text = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
    
//    NSLog(@"%@",geoHeXie);
    
//    NSLog(@"原始坐标:%f,%f",manager.location.coordinate.latitude,manager.location.coordinate.longitude);
//    NSLog(@"newloaction:%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    

    
    
//    [self geoRecode:newLocation];
///    NSLog(@"%f",manager.location.coordinate.longitude);
//    NSLog(@"经纬度:%f",m);
    //    manager.location
    
//    MKLocationManager  
//    MSearch *search = [MSearch MSearchWithKey:mapabcKey delegate:self];
//    poiXY.X = newLocation.coordinate.longitude;
//    poiXY.Y = newLocation.coordinate.latitude;
    
//    MCOORDINATESEARCHOPTIONS search_option;
//    self.options = search_option;
//    NSLog(@"poiXY:%f,%f",poiXY.X,poiXY.Y);
//    [geoHeXie GPSToOffSetByPoint:self];
   
     
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location error is %@",[error description]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位功能尚未开启，是否开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开启", nil];
    alert.tag = 1003;
    [alert show];
    return;
}

-(void)geoRecode:(id)sender
{
    //    反地理编码
    CLGeocoder *geoCoder = [CLGeocoder new];
    
    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error)
    {
        
        for (CLPlacemark *placemark in place) {
            
            
            /*
			// [self setSubtitle: [placemark locality] ];             
            
            NSLog(@"name%@", [placemark name]);     
            
            NSLog(@"ISOcountryCode%@", [placemark ISOcountryCode]);     
            
            NSLog(@"administrativeArea%@", [placemark administrativeArea]);     
            
            NSLog(@"subAdministrativeArea%@", [placemark subAdministrativeArea]);     
            
            NSLog(@"subLocality%@", [placemark subLocality]);
            
            NSLog(@"locality%@", [placemark locality]);
            
            NSLog(@"thoroughfare%@", [placemark thoroughfare]);
            
            NSLog(@"subThoroughfare%@", [placemark subThoroughfare]);
            
            NSLog(@"region%@", [placemark region]);
            */
            
            
            self.accuracy.text = [NSString stringWithFormat:@"%@%@%@",[placemark locality],[placemark subLocality],[placemark name]];
            
            
            
        }
        
    };
    
    [geoCoder reverseGeocodeLocation:sender completionHandler:handler];

}



/*
//反和谐补丁，X对lon,Y对lat;

-(void)GPSToOffsetResponse:(MLONLAT)lonlat
{
    NSLog(@"%f,%f",lonlat.Y,lonlat.Y);
    
    
//    NSLog(@"和谐坐标:%f,%f",lonlat.Y,lonlat.X);
        CLLocation *heXieLocation = [[CLLocation alloc] initWithLatitude:lonlat.Y longitude:lonlat.X];
    if (heXieLocation.coordinate.latitude == 0.000000 ) {
        [geoCoder reverseGeocodeLocation:locManager.location completionHandler:handler];
    }else
    {
    [geoCoder reverseGeocodeLocation:heXieLocation completionHandler:handler];
    }

}
*/



@end
