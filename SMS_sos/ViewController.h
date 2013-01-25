//
//  ViewController.h
//  SMS_sos
//
//  Created by GU ZHE on 12-2-12.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "MSearch.h"
#import "DataProvider.h"

@interface ViewController : UIViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,addressArrayDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
//    lable group
    IBOutlet UILabel *latitude;
    IBOutlet UILabel *longitude;
    IBOutlet UILabel *accuracy;
    
//    toolbar
    IBOutlet UIToolbar *tbrButton;
    
//    map
    IBOutlet MKMapView *mapView;
//    地址簿
    NSArray *addressArray;
    NSMutableArray *adrArray;
    CLLocationManager *locManager;
    
//    deoCoder
//    MSearch *geoHeXie;
//    MLONLAT poiXY;
}

@property (nonatomic,retain) UILabel *latitude;
 
@property (nonatomic,retain) UILabel *longitude;
@property (nonatomic,retain) UILabel *accuracy;

@property (nonatomic,retain) UIToolbar *tbrButton;

@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic,strong) NSArray *addressArray;
@property (nonatomic,strong) NSMutableArray *adrArray;

@property (strong) CLLocationManager *locManager;
//@property (nonatomic,strong) MSearch *geoHeXie;
//@property MLONLAT poiXY;

-(void)displaySMSComposerSheet;
-(IBAction)showSMSPicker:(id)sender;
-(IBAction)reloadLocation:(id)sender;
-(void)geoRecode:(id)sender;


//火星坐标私有API
- (CLLocation*)_applyChinaLocationShift:(CLLocation*)arg;   
- (BOOL)chinaShiftEnabled;   
+ (id)sharedLocationManager;

@end
