//
//  AudioRecorderController.m
//  SMS_sos
//
//  Created by GU ZHE on 12-3-23.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import "AudioRecorderController.h"

@implementation AudioRecorderController

@synthesize btnPlay,btnRecord,btnSend;
@synthesize proUpload;
@synthesize queue;


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


/*
-(void)changeLable:(id)sender
{
    [lblTime setText:[NSString stringWithFormat:@"录音个数%i",[audioArray count]]];
//    loopCount++;
}

-(void)recordFile:(NSTimer *)timer
{
        NSLog(@"计时！");
        [self changeLable:nil];
//    [NSThread detachNewThreadSelector:@selector(addFileToArray:) toTarget:self withObject:nil];
    if (loopCount != 0) {
        [recorder stop]; 
        NSData *dataRecord = [[NSData alloc] initWithContentsOfURL:tmpFile];
        [audioArray addObject:dataRecord];
   
        [self pressedRecordButton:nil];
    }

    
    ++loopCount;



}
-(void)addFileToArray:(id)sender
{
   
    
    if (loopCount != 0) {
        
        [recorder stop]; 
        NSData *dataRecord = [[NSData alloc] initWithContentsOfURL:tmpFile];
        [audioArray addObject:dataRecord];
        [self changeLable:nil];
        
        [self pressedRecordButton:nil];
        
    }
    ++loopCount;
      

 
  
    
    
}
 
  */
/*
-(void)changeLableTest:(id)sender
{
    [lblTimeTest setText:[NSString stringWithFormat:@"%i",loopCountTest]];
    loopCountTest++;
}
-(void)threadTimer:(id)sender
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeLable:) userInfo:self repeats:YES];
    [timer fire];
}

*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    proUpload.progress = 0.0f;
    toggle = YES;
    loopCount = 0;
    queue = [[ASINetworkQueue alloc] init];
    [queue setDelegate:self];
    [queue setMaxConcurrentOperationCount:1];
//    loopCountTest = 0;
    
//    error = [[NSError alloc] init];
    audioArray = [[NSMutableArray alloc] initWithCapacity:100];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
    [audioSession setActive:YES error:nil];
    
//    nsthread&nstimer
 	NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
	[myFormatter setDateFormat:@"yyyyMMddhhmmss"];
	NSString *strTime = [myFormatter stringFromDate:[NSDate date]] ;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strTime];
	strDocPath = [[NSString alloc] initWithString:strPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:strDocPath withIntermediateDirectories:NO attributes:nil error:nil];
}

-(IBAction)pressedRecordButton:(id)sender   
{
    btnPlay.enabled = !toggle;
    
    if (NO  == toggle) {
        
        [btnRecord setTitle:[NSString stringWithFormat:@"录音"] forState:UIControlStateNormal];
        
        [recorder stop];
        toggle = YES;
        [timer  invalidate];
        //        [timer invalidate];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //        NSLog(@"Using File called: %@",tmpFile);
        //        NSData *dataRecord = [[NSData alloc] initWithContentsOfURL:tmpFile];
        //        [audioArray addObject:tmpFile];
        //        NSFileManager *file = [NSFileManager defaultManager];
        //        btnRecord.titleLabel.text = [NSString stringWithFormat:@"停止"];
        
    }
    else
    {

        
        [btnRecord setTitle:[NSString stringWithFormat:@"停止"] forState:UIControlStateNormal];
        
        //初始化命名方式        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMddhhmmss"];
        NSString *str = [formatter stringFromDate:[NSDate date] ];
        NSString *strName = [str stringByAppendingString:@".caf"];
        
        NSString *fullPath = [strDocPath stringByAppendingPathComponent:strName];
        
        NSURL *url = [NSURL fileURLWithPath:fullPath];
        tmpFile = url;
        
        //    setting
        
        
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:8000.0f] forKey:AVSampleRateKey]; 
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        
        
        recorder =[[AVAudioRecorder alloc] initWithURL:tmpFile settings:recordSetting error:nil];
        
        
        recorder.delegate = self;
        
        [recorder prepareToRecord];
        [recorder record];
        //        toggle = NO;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [audioArray addObject:fullPath];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(recordFile:) userInfo:recorder repeats:NO];
        //        [timer fire];
//        timer =[NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> invocation:<#(NSInvocation *)#> repeats:<#(BOOL)#>];
        
        
        //        toggle = YES;
        
        
    }
    

}
-(void)autoRecord:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [btnRecord setTitle:[NSString stringWithFormat:@"停止"] forState:UIControlStateNormal];
    
    //初始化命名方式        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMddhhmmss"];
    NSString *str = [formatter stringFromDate:[NSDate date] ];
    NSString *strName = [str stringByAppendingString:@".caf"];
    
    NSString *fullPath = [strDocPath stringByAppendingPathComponent:strName];
    
    NSURL *url = [NSURL fileURLWithPath:fullPath];
    tmpFile = url;
    
    //    setting
    
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:8000.0f] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    
    recorder =[[AVAudioRecorder alloc] initWithURL:tmpFile settings:recordSetting error:nil];
    
    
    recorder.delegate = self;
    
    [recorder prepareToRecord];
    [recorder record];
    //        toggle = NO;
    
    
    [audioArray addObject:fullPath];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(recordFile:) userInfo:recorder repeats:NO];
    //        [timer fire];

}
-(void)recordFile:(id)sender
{
    toggle = NO;
    [recorder stop];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"发送准备！！！！");
    [self pressedSendButton:nil];
   
    
    NSLog(@"重新开始！！！");
    [self autoRecord:nil];

//    //初始化命名方式        
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = [NSString stringWithFormat:@"yyyyMMddhhmmss"];
//    NSString *str = [formatter stringFromDate:[NSDate date] ];
//    NSString *strName = [str stringByAppendingString:@".caf"];
//    
//    NSString *fullPath = [strDocPath stringByAppendingPathComponent:strName];
//    
//    NSURL *url = [NSURL fileURLWithPath:fullPath];
//    tmpFile = url;
//    
//    //    setting
//    
//    
//    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
//    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:8000.0f] forKey:AVSampleRateKey]; 
//    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//    
//    
//    recorder =[[AVAudioRecorder alloc] initWithURL:tmpFile settings:recordSetting error:nil];
//    
//    
//    recorder.delegate = self;
//    
//    [recorder prepareToRecord];
//    [recorder record];
////    toggle = NO;
//    
////    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [audioArray addObject:fullPath];
     

    
}

-(IBAction)pressedPlayButton:(id)sender
{
//    NSError *error = [[NSError alloc]init];
//            NSData *tmpData = [audioArray objectAtIndex:1];
//    NSURL *url = [audioArray objectAtIndex:0];
    int count = [audioArray count];
            NSURL*url = [NSURL fileURLWithPath:[audioArray objectAtIndex:count-1]];
        
        //    NSFileManager *fileManger = [NSFileManager defaultManager ];
        //    NSURL *url   = [fileManger ]
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        player.delegate = self;
        player.volume = 1.0f;
        
        [player prepareToPlay];
        
        
        [player play];
    
    


    
   
}

-(IBAction)pressedSendButton:(id)sender
{
    int count = [audioArray count];
    
    NSURL*url = [NSURL fileURLWithPath:[audioArray objectAtIndex:count-1]];
    NSData *voiceData = [NSData dataWithContentsOfURL:url];
    NSString *strVoice = [Base64 data2String:voiceData];
//    NSString *currentPhoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithObjects:@"39.105632，117.1652065",strVoice, nil];
    
    
    ASIHTTPRequest * request = [DataProvider getASISOAP11Request:nil webServiceFile:nil xmlNameSpace:nil webServiceName:@"vocie" wsParameters:tmpArray];
    
    [request setDelegate:self]; 
//    [request startAsynchronous];
    [request setUploadProgressDelegate:self];
    request.showAccurateProgress = YES;
    [queue addOperation:request];
 
    [queue go];
    

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Recorder Delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
//    NSLog(@"%@",recorder);
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [self    dismissModalViewControllerAnimated:YES];
//    if ([audioArray count] >= 2) {
//        for (int i = 1; i <= [audioArray count]; i++) {
//            NSData *tmpData = [audioArray objectAtIndex:1];
//            AVAudioPlayer *player1 = [[AVAudioPlayer alloc] initWithData:tmpData error:nil];
//            player1.delegate = self;
//            player1.volume = 1.0f;
//            
//            [player1 prepareToPlay];
//            
//            
//            [player1 play];
//        player set
            
//        }

//    }
        NSLog(@"Over!");
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Vocie Failed!");
}
-(IBAction)pressedBack
{
    [self dismissModalViewControllerAnimated:YES]; 
}

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;

{
    NSString *tmp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",tmp);
}

- (void)setProgress:(float)newProgress
{
    proUpload.progress = newProgress;
}

@end


