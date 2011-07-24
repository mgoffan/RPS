//
//  MainViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

#import <GameKit/GameKit.h>

#import "MessageNotificationController.h"
#import "LoginViewController.h"

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
@class LoginViewController;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, GKMatchmakerViewControllerDelegate> {
    UIImageView            *firstPlayerImageView;
    UIImageView            *COMImageView;
    UISegmentedControl     *segmentControl;
    UILabel                *scoreboard;
    UILabel                *currentResult;
    UILabel                *appTitle;
    UIButton               *buttonThrow;
    UIButton               *multiplayerButton;
    
	FlipsideViewController          *optionsController;
    MessageNotificationController   *newNotification;
    LoginViewController             *loginViewController;
    
    NSInteger                       playerPoints;
    NSInteger                       iDevicePoints;
    NSInteger                       reachablePoints;
    BOOL                            gameIsReset;
    BOOL                            userDidWin;
    
    GKSession		*gameSession;
	int				gameUniqueID;
	int				gamePacketNumber;
	NSString		*gamePeerId;
	NSDate			*lastHeartbeatDate;
	
	UIAlertView		*connectionAlert;
}

@property (nonatomic, retain) IBOutlet UIImageView          *firstPlayerImageView;
@property (nonatomic, retain) IBOutlet UIImageView          *COMImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;
@property (nonatomic, retain) IBOutlet UILabel              *scoreboard;
@property (nonatomic, retain) IBOutlet UILabel              *appTitle;
@property (nonatomic, retain) IBOutlet UILabel              *currentResult;
@property (nonatomic, retain) IBOutlet UIButton             *buttonThrow;
@property (nonatomic, retain) IBOutlet UIButton             *multiplayerButton;

@property (nonatomic, retain) FlipsideViewController        *optionsController;
@property (nonatomic, retain, getter = newNotification) MessageNotificationController *newNotification;

- (IBAction)showInfo:(id)sender;
- (IBAction)play:(id)sender;
- (void)share;
- (IBAction)hostMatch:(id)sender;

- (void)setupUserInterface;
- (void)setupNotifications;
- (void)setupGameLogic;
- (void)setupLogin;

@end
