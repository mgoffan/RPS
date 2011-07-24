//
//  MainViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <GameKit/GameKit.h>

#import "SHK.h"
#import "SHKFacebook.h"

#import "LocalizedStrings.h"

#define iPad                    ([UIScreen mainScreen].bounds.size.height == 1024)

#define kAnimationDurationShow  2.0
#define kAnimationDurationHide  0.75

#define VIEW_WIDTH              self.view.bounds.size.width
#define VIEW_HEIGHT             self.view.bounds.size.height
#define NOTIFICATION_WIDTH      newNotification.view.frame.size.width
#define NOTIFICATION_HEIGHT     newNotification.view.frame.size.height

@class MessageNotificationController;
@class MainViewController;

@interface SinglePlayerViewController : UIViewController {
    
    UIImageView            *firstPlayerImageView;
    UIImageView            *COMImageView;
    UISegmentedControl     *segmentControl;
    UILabel                *scoreboard;
    UILabel                *currentResult;
    
    MessageNotificationController   *newNotification;
    MainViewController              *mainController;
    
    NSInteger                       playerPoints;
    NSInteger                       iDevicePoints;
    NSInteger                       reachablePoints;
    BOOL                            gameIsReset;
    BOOL                            userDidWin;
    
    GKSession		*gameSession;
}

@property (nonatomic, retain) IBOutlet UIImageView          *firstPlayerImageView;
@property (nonatomic, retain) IBOutlet UIImageView          *COMImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;
@property (nonatomic, retain) IBOutlet UILabel              *scoreboard;
@property (nonatomic, retain) IBOutlet UILabel              *currentResult;

@property (nonatomic, retain) MainViewController *mainController;
@property (nonatomic, retain, getter = newNotification) MessageNotificationController *newNotification;

- (IBAction)play:(id)sender;
- (IBAction)goBack:(id)sender;
- (void)share;

- (void)setupUserInterface;
- (void)setupNotifications;
- (void)setupGameLogic;

@end
