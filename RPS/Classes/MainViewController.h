//
//  MainViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MessageNotificationController.h"
#import "SHK.h"
#import "SHKFacebook.h"


#define iPad                    ([UIScreen mainScreen].bounds.size.height == 1024)

#define statusLost              NSLocalizedString(@"statusLost",nil)
#define statusTie               NSLocalizedString(@"statusTie",nil)
#define statusWon               NSLocalizedString(@"statusWon",nil)
#define resultLost              NSLocalizedString(@"resultLost",nil)
#define resultWon               NSLocalizedString(@"resultWon",nil)
#define interfaceTitle          NSLocalizedString(@"interfaceTitle",nil)
#define interfaceRock           NSLocalizedString(@"interfaceRock",nil)
#define interfacePaper          NSLocalizedString(@"interfacePaper",nil)
#define interfaceScissors       NSLocalizedString(@"interfaceScissors",nil)
#define interfaceThrow          NSLocalizedString(@"interfaceThrow",nil)
#define shareWon                NSLocalizedString(@"shareWon",nil)
#define shareLost               NSLocalizedString(@"shareLost",nil)

@class MessageNotificationController;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIImageView            *firstPlayerImageView;
	IBOutlet UIImageView            *COMImageView;
	IBOutlet UISegmentedControl     *segmentControl;
    IBOutlet UILabel                *scoreboard;
    IBOutlet UILabel                *currentResult;
    IBOutlet UILabel                *appTitle;
    IBOutlet UIButton               *buttonThrow;
    
	FlipsideViewController          *optionsController;
    MessageNotificationController   *newNotification;
    
    NSInteger                       playerPoints;
    NSInteger                       iDevicePoints;
    NSInteger                       reachablePoints;
    BOOL                            gameIsReset;
    
    AVAudioPlayer                   *audioPlayer;
}

@property (nonatomic, retain) IBOutlet UIImageView          *firstPlayerImageView;
@property (nonatomic, retain) IBOutlet UIImageView          *COMImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;
@property (nonatomic, retain) IBOutlet UILabel              *scoreboard;
@property (nonatomic, retain) IBOutlet UILabel              *appTitle;
@property (nonatomic, retain) IBOutlet UILabel              *currentResult;
@property (nonatomic, retain) IBOutlet UIButton             *buttonThrow;

@property (nonatomic, retain) FlipsideViewController        *optionsController;

- (IBAction)showInfo:(id)sender;
- (IBAction)play:(id)sender;
- (void)sharingMyScore:(NSInteger)pPoints device:(NSInteger)dPoints;

- (void)setupUserInterface;
- (void)setupNotifications;
- (void)setupGameSound;
- (void)setupGameLogic;


@end
