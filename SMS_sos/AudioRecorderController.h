//
//  AudioRecorderController.h
//  SMS_sos
//
//  Created by GU ZHE on 12-3-23.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "NSTimerController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Base64.h"
#import "DataProvider.h"
//#import "SpeexCodec.h"

@interface AudioRecorderController : UIViewController<ASIHTTPRequestDelegate,ASIProgressDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>

{
    
    NSURL *tmpFile;
    NSString *strDocPath;
    NSError *error;
    AVAudioRecorder *recorder;
    AVAudioPlayer   *player;  
    
    NSMutableArray *audioArray;
    NSTimer *timer;
    
//    tmp
    BOOL toggle;
    int loopCount;
    int loopCountTest;
    
    IBOutlet UIButton *btnRecord;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnSend;
    IBOutlet UILabel  *lblTime;
    IBOutlet UILabel  *lblTimeTest;
    IBOutlet UIProgressView *prvUpload;
    ASINetworkQueue *queue;

}
@property (nonatomic,strong)UIButton *btnRecord;
@property (nonatomic,strong)UIButton *btnPlay;
@property (nonatomic,strong)UIButton *btnSend;
@property (nonatomic,strong)UIProgressView *proUpload;
@property (strong)ASINetworkQueue *queue;


-(IBAction)pressedRecordButton:(id)sender;
-(IBAction)pressedPlayButton:(id)sender;
-(IBAction)pressedSendButton:(id)sender;
@end
