//
//  MainViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>


#define iPad ([UIScreen mainScreen].bounds.size.height == 1024)
#define es ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"es"])

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIImageView *firstPlayerImageView;
	IBOutlet UIImageView *COMImageView;
	IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UILabel *scoreboard;
    IBOutlet UILabel *currentResult;
    IBOutlet UILabel *appTitle;
    IBOutlet UIButton *buttonThrow;
    
	FlipsideViewController *optionsController;
    
    NSInteger playerPoints;
    NSInteger iDevicePoints;
    NSInteger reachablePoints;
    
    BOOL gameIsReset;
    
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) IBOutlet UIImageView *firstPlayerImageView;
@property (nonatomic, retain) IBOutlet UIImageView *COMImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, retain) IBOutlet UILabel *scoreboard;
@property (nonatomic, retain) IBOutlet UILabel *appTitle;
@property (nonatomic, retain) IBOutlet UILabel *currentResult;
@property (nonatomic, retain) IBOutlet UIButton *buttonThrow;

@property (nonatomic, retain) FlipsideViewController *optionsController;

- (IBAction)showInfo:(id)sender;
- (IBAction)play:(id)sender;

@end
