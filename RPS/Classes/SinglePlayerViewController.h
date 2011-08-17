//
//  MainViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define iPad                    ([UIScreen mainScreen].bounds.size.height == 1024)

#define kAnimationDurationShow  2.0
#define kAnimationDurationHide  0.75

#define VIEW_WIDTH              self.view.bounds.size.width
#define VIEW_HEIGHT             self.view.bounds.size.height
#define NOTIFICATION_WIDTH      theNotification.view.frame.size.width
#define NOTIFICATION_HEIGHT     theNotification.view.frame.size.height

#import <UIKit/UIKit.h>
#import "MessageNotificationView.h"

@class MessageNotificationController;
@class MainViewController;

@interface SinglePlayerViewController : UIViewController <MessageNotificationViewDelegate>{
    
    UIImageView            *_firstPlayerImageView;
    UIImageView            *_COMImageView;
    UISegmentedControl     *_segmentControl;
    UILabel                *_scoreboard;
    UILabel                *_currentResult;
    
    MessageNotificationController   *theNotification;
    
    MessageNotificationView *aNotification;
    
    MainViewController              *mainController;
    
    NSInteger                       playerPoints;
    NSInteger                       iDevicePoints;
    NSInteger                       maxPoints;
    BOOL                            gameIsReset;
    BOOL                            userDidWin;
}

@property (nonatomic, retain) IBOutlet UIImageView          *firstPlayerImageView;
@property (nonatomic, retain) IBOutlet UIImageView          *COMImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl   *segmentControl;
@property (nonatomic, retain) IBOutlet UILabel              *scoreboard;
@property (nonatomic, retain) IBOutlet UILabel              *currentResult;

- (IBAction)play:(id)sender;
- (void)share;

- (void)setupUserInterface;
- (void)setupNotifications;
- (void)setupGameLogic;

@end
