//
//  MainViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "SettingsViewController.h"
#import "MessageNotificationController.h"
#import "LoginViewController.h"
#import "MainViewController.h"


@implementation SinglePlayerViewController

@synthesize firstPlayerImageView;
@synthesize COMImageView;
@synthesize segmentControl;
@synthesize scoreboard;
@synthesize currentResult;
@synthesize newNotification;
@synthesize mainController;

- (void)flush:(id)anObject {
    [anObject release];
    anObject = nil;
}

//App Setup
#pragma mark App Setup
- (void)setupGameLogic {
    playerPoints    = 0;
    iDevicePoints   = 0;
    
    gameIsReset     = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
}

- (void)setupNotifications {
    newNotification = (iPad) ? [[MessageNotificationController alloc] initWithNibName:@"Notification-iPad" bundle:[NSBundle mainBundle]] : [[MessageNotificationController alloc] initWithNibName:@"Notification" bundle:[NSBundle mainBundle]];
    
    newNotification.view.frame = CGRectMake(0, -20, NOTIFICATION_WIDTH, NOTIFICATION_WIDTH);
    newNotification.view.alpha = 0.0;
    
    [self.view addSubview:newNotification.view];
}



- (void)setupUserInterface {
    //Background
    UIImageView *backgroundImage = [[UIImageView alloc] init];
    
    backgroundImage.frame = (iPad) ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, 480);
    backgroundImage.image = (iPad) ? [UIImage imageNamed:@"Background_iPad"] : [UIImage imageNamed:@"Background"];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [backgroundImage release];
}

//Game methods
#pragma mark Game methods

- (void)reset {
    playerPoints                = 0;
    iDevicePoints               = 0;
    COMImageView.image          = nil;
    firstPlayerImageView.image  = nil;
    scoreboard.text             = @"0 - 0";
    currentResult.text          = nil;
    gameIsReset                 = YES;
    userDidWin                  = NO;
    newNotification.myMessage   = nil;
    newNotification.winnerLooserImageView.image = nil;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
}

- (void)hideNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDurationHide];
    newNotification.view.frame = CGRectMake(0, -20, NOTIFICATION_WIDTH, NOTIFICATION_WIDTH);
    newNotification.view.alpha = 0.0;
    [UIView commitAnimations];
    [self performSelector:@selector(reset)];
}

- (void)presentNotification {
    if (userDidWin) {
        newNotification.myMessage = [NSString stringWithFormat:resultWon, [[NSUserDefaults standardUserDefaults] integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]];
        [newNotification image:[UIImage imageNamed:@"trophy.png"]];
    }
    else {
        newNotification.myMessage = [NSString stringWithFormat:resultLost, [[NSUserDefaults standardUserDefaults] integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]];
        [newNotification image:[UIImage imageNamed:@"trophy.png"]];
        [newNotification image:[UIImage imageNamed:@"lost_inverted.png"]];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDurationShow];
    newNotification.view.alpha = 1.0;
    newNotification.view.center = CGPointMake((VIEW_WIDTH / 2), (VIEW_HEIGHT / 2));
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideNotification) withObject:nil afterDelay:5.0];
}

- (void)play:(id)sender {
	NSInteger choice        = segmentControl.selectedSegmentIndex;
	int rnd                 = arc4random() % 3;
    
    gameIsReset             = NO;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    
    firstPlayerImageView.image = (choice == 0) ? [UIImage imageNamed:@"rock"] : (choice == 1) ? [UIImage imageNamed:@"paper"] : [UIImage imageNamed:@"scissor"];
    
    COMImageView.image = (rnd == 0) ? [UIImage imageNamed:@"rock"] : (rnd == 1) ? [UIImage imageNamed:@"paper"] : [UIImage imageNamed:@"scissor"];
    COMImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    if (playerPoints < reachablePoints || iDevicePoints < reachablePoints) {
        if (choice == 0) {
            if (rnd == 0) {
                currentResult.text = statusTie;
            } else {
                if (rnd == 1) {
                    iDevicePoints++;
                    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text  = statusLost;
                } else {
                    playerPoints++;
                    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text  = statusWon;
                }
            }
        } else {
            if (choice == 1) {
                if (rnd == 0) {
                    playerPoints++;
                    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text  = statusWon;
                } else {
                    if (rnd == 1) {
                        currentResult.text = statusTie;
                    } else {
                        iDevicePoints++;
                        scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text  = statusLost;
                    }
                }
            } else {
                if (choice == 2) {
                    if (rnd == 0) {
                        iDevicePoints++;
                        scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text  = statusLost;
                    } else {
                        if (rnd == 1) {
                            playerPoints++;
                            scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                            currentResult.text  = statusWon;
                        } else {
                            currentResult.text  = statusTie;
                        }
                    }
                }
            }
        }
        if (playerPoints == reachablePoints || iDevicePoints == reachablePoints) {
            goto loop;
        }
    }
    else {
    loop:
        [[NSUserDefaults standardUserDefaults] setInteger:playerPoints forKey:@"playerPoints"];
        [[NSUserDefaults standardUserDefaults] setInteger:iDevicePoints forKey:@"iDevicePoints"];
        userDidWin = (playerPoints > iDevicePoints) ? YES : NO;
        if (playerPoints > iDevicePoints) [self presentNotification];
        else [self presentNotification];
    }
}

- (IBAction)goBack:(id)sender {
    mainController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    
    UIView *currentView = self.view;
    UIView *theWindow = [currentView superview];
    UIView *newView = mainController.view;
    newView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 20);
    
    [currentView removeFromSuperview];
    [theWindow addSubview:newView];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[theWindow layer] addAnimation:animation forKey:@"SwitchBackToView"];
    
    [mainController release];
}

- (void)share {
    if (userDidWin) {
        [SHKFacebook shareText:[NSString stringWithFormat:shareWon, [[NSUserDefaults standardUserDefaults]
                                                                     integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]]];
    }
    [SHKFacebook shareText:[NSString stringWithFormat:shareLost, [[NSUserDefaults standardUserDefaults]
                                                                 integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]]];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
        [self play:nil];
	}
}

//View Methods
#pragma mark View Methods
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    reachablePoints = [[NSUserDefaults standardUserDefaults] integerForKey:@"reachablePoints"];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self flush:firstPlayerImageView];
    [self flush:COMImageView];
    [self flush:scoreboard];
    [self flush:currentResult];
    [self flush:newNotification];
    
    NSLog(@"view unload");
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    
	[self becomeFirstResponder];
    
    NSLog(@"view appeared");
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//Message Notification
#pragma mark Message Notification
- (MessageNotificationController *)newNotification {
    return [newNotification autorelease];
}

//Dealloc
#pragma mark Dealloc
- (void)dealloc {
    [super dealloc];
}

@end