//
//  MainViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SHK.h"
#import "SHKFacebook.h"

#import "LocalizedStrings.h"

#import "SinglePlayerViewController.h"
#import "SettingsViewController.h"
#import "MessageNotificationController.h"
#import "LoginViewController.h"
#import "MainViewController.h"

@implementation SinglePlayerViewController

@synthesize firstPlayerImageView = _firstPlayerImageView;
@synthesize COMImageView = _COMImageView;
@synthesize segmentControl = _segmentControl;
@synthesize scoreboard = _scoreboard;
@synthesize currentResult = _currentResult;

    //View Methods
#pragma mark View Methods

    // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    mainController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    [self setupNotifications];
    [self setupGameLogic];
    
	[super viewDidLoad];
    NSLog(@"sP view did load");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    maxPoints = [[NSUserDefaults standardUserDefaults] integerForKey:@"maxPoints"];
    
    NSLog(@"sP view will appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    NSLog(@"sP view will dissapear");
    
        //    [self viewDidUnload];
}

- (void)didReceiveMemoryWarning {
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
        // Release any cached data, images, etc. that aren't in use.
}

- (void)flush:(id)anObject {
    NSLog(@"sP flush");
    [anObject release];
    anObject = nil;
}

- (void)viewDidUnload {
    [self flush:self.firstPlayerImageView];
    [self flush:self.COMImageView];
    [self flush:self.scoreboard];
    [self flush:self.currentResult];
    [self flush:theNotification];
    
    NSLog(@"sP view unload");
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    
	[self becomeFirstResponder];
    
    NSLog(@"sP viewDidApperar");
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//App Setup
#pragma mark App Setup
- (void)setupGameLogic {
    playerPoints    = 0;
    iDevicePoints   = 0;
}

- (void)setupNotifications {
    theNotification = (iPad) ? [[[MessageNotificationController alloc] initWithNibName:@"Notification-iPad" bundle:[NSBundle mainBundle]] autorelease] : [[[MessageNotificationController alloc] initWithNibName:@"Notification" bundle:[NSBundle mainBundle]] autorelease];
    
    theNotification.view.frame = CGRectMake(0, -20, NOTIFICATION_WIDTH, NOTIFICATION_WIDTH);
    theNotification.view.alpha = 0.0;
    
    [self.view addSubview:theNotification.view];
}

//Game methods
#pragma mark Game methods

- (void)reset {
    playerPoints = iDevicePoints = userDidWin = 0;
    self.COMImageView.image          = nil;
    self.firstPlayerImageView.image  = nil;
    self.scoreboard.text             = @"0 - 0";
    self.currentResult.text          = nil;
    gameIsReset                 = YES;
    theNotification.myMessage   = nil;
    theNotification.winnerLooserImageView.image = nil;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
}

- (void)hideNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDurationHide];
    theNotification.view.frame = CGRectMake(0, -20, NOTIFICATION_WIDTH, NOTIFICATION_WIDTH);
    theNotification.view.alpha = 0.0;
    [UIView commitAnimations];
    [self performSelector:@selector(reset)];
}

- (void)presentNotification {
    if (userDidWin) {
        theNotification.myMessage = [NSString stringWithFormat:resultWon, [[NSUserDefaults standardUserDefaults] integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]];
        [theNotification image:[UIImage imageNamed:@"trophy.png"]];
    }
    else {
        theNotification.myMessage = [NSString stringWithFormat:resultLost, [[NSUserDefaults standardUserDefaults] integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]];
        [theNotification image:[UIImage imageNamed:@"trophy.png"]];
        [theNotification image:[UIImage imageNamed:@"lost_inverted.png"]];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDurationShow];
    theNotification.view.alpha = 1.0;
    theNotification.view.center = CGPointMake((VIEW_WIDTH / 2), (VIEW_HEIGHT / 2));
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideNotification) withObject:nil afterDelay:5.0];
}

- (void)playerWon {
    playerPoints++;
    self.scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
    self.currentResult.text  = statusWon;
}

- (void)playerLost {
    iDevicePoints++;
    self.scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
    self.currentResult.text  = statusLost;
}

- (void)updateDataToPlayer:(NSInteger)playerScore andDevice:(NSInteger)deviceScore {
    switch (playerScore) {
        case 0:
            switch (deviceScore) {
                case 0: self.currentResult.text = statusTie;
                    break;
                case 1: [self playerLost];
                    break;
                case 2: [self playerWon];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (deviceScore) {
                case 0: [self playerWon];
                    break;
                case 1: self.currentResult.text = statusTie;
                    break;
                case 2: [self playerLost];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (deviceScore) {
                case 0: [self playerLost];
                    break;
                case 1: [self playerWon];
                    break;
                case 2: self.currentResult.text  = statusTie;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)play:(id)sender {
    NSInteger choice        = self.segmentControl.selectedSegmentIndex;
    NSInteger rnd           = arc4random() % 3;
    
    [[NSUserDefaults standardUserDefaults] setBool:kGameStatusPlaying forKey:@"gameStatus"];
    
    self.firstPlayerImageView.image = (choice == 0) ? [UIImage imageNamed:@"rock"] : (choice == 1) ? [UIImage imageNamed:@"paper"] : [UIImage imageNamed:@"scissor"];
    
    self.COMImageView.image = (rnd == 0) ? [UIImage imageNamed:@"rock"] : (rnd == 1) ? [UIImage imageNamed:@"paper"] : [UIImage imageNamed:@"scissor"];
    self.COMImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    if (playerPoints < maxPoints || iDevicePoints < maxPoints) {
        
        [self updateDataToPlayer:choice andDevice:rnd];
        if (playerPoints == maxPoints || iDevicePoints == maxPoints) goto loop;
    }
    else {
    loop:
        [[NSUserDefaults standardUserDefaults] setInteger:playerPoints forKey:@"playerPoints"];
        [[NSUserDefaults standardUserDefaults] setInteger:iDevicePoints forKey:@"iDevicePoints"];
        userDidWin = (playerPoints > iDevicePoints) ? YES : NO;
        [self presentNotification];
    }
}

- (void)share {
    if (userDidWin) [SHKFacebook shareText:[NSString stringWithFormat:shareWon, [[NSUserDefaults standardUserDefaults] integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]]];
    else [SHKFacebook shareText:[NSString stringWithFormat:shareLost, [[NSUserDefaults standardUserDefaults] integerForKey:@"playerPoints"], [[NSUserDefaults standardUserDefaults] integerForKey:@"iDevicePoints"]]];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) [self play:nil];
}

//Dealloc
#pragma mark Dealloc
- (void)dealloc {
    NSLog(@"sP dealloc");
    [super dealloc];
}

@end