//
//  TestViewController.m
//  SMS_sos
//
//  Created by tju tju on 13-2-28.
//  Copyright (c) 2013年 zhe. All rights reserved.
//

#import "TestViewController.h"
#import "SpeexCodec.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize PCMFilePath = _PCMFilePath;
//@synthesize audioPlayer = _audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"caf"];
    NSData *PCMData = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"---------%d", [PCMData length]);
    
    NSData *SpeexData = EncodeWAVEToSpeex(PCMData, 1, 16);
    //    NSLog(@"---------%d", [SpeexData length]);
    SpeexHeader *header = (SpeexHeader *)[SpeexData bytes];
    CalculatePlayTime(SpeexData, header->reserved1);
    
    NSData *NewPCMData = DecodeSpeexToWAVE(SpeexData);
    self.PCMFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]];
    [NewPCMData writeToFile:self.PCMFilePath atomically:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    [_PCMFilePath release], _PCMFilePath = nil;
   
    [super dealloc];
}

@end
