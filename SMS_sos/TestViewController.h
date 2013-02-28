//
//  TestViewController.h
//  SMS_sos
//
//  Created by tju tju on 13-2-28.
//  Copyright (c) 2013年 zhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface ViewController : UIViewController<AVAudioRecorderDelegate>

@property (nonatomic, retain) NSString *PCMFilePath;
//@property (nonatomic, retain) AVAudioPlayer *audioPlayer;