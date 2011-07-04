//
//  MainViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "MessageNotificationController.h"


@implementation MainViewController

@synthesize firstPlayerImageView, COMImageView, segmentControl, optionsController, scoreboard, currentResult, buttonThrow, appTitle;

//App Setup
#pragma mark App Setup
- (void)setupGameLogic {
    playerPoints    = 0;
    iDevicePoints   = 0;
    
    gameIsReset     = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
}

- (void)setupGameSound {
    NSURL *url      = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bgsound.mp3", [[NSBundle mainBundle] resourcePath]]];
	audioPlayer     = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
	audioPlayer.numberOfLoops = -1;
    
	[audioPlayer play];
}

- (void)setupNotifications {
    newNotification = (iPad) ? [[MessageNotificationController alloc] initWithNibName:@"Notification-iPad" bundle:[NSBundle mainBundle]] : [[MessageNotificationController alloc] initWithNibName:@"Notification" bundle:[NSBundle mainBundle]];
    newNotification.view.frame = CGRectMake(0, self.view.bounds.size.height + newNotification.view.bounds.size.height, newNotification.view.frame.size.width, newNotification.view.frame.size.width);
    [self.view addSubview:newNotification.view];
}

- (void)setupUserInterface {
    [buttonThrow setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [buttonThrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appTitle.text = interfaceTitle;
    
    [segmentControl setTitle:interfaceRock forSegmentAtIndex:0];
    [segmentControl setTitle:interfacePaper forSegmentAtIndex:1];
    [segmentControl setTitle:interfaceScissors forSegmentAtIndex:2];
    
    [buttonThrow setTitle:interfaceThrow forState:UIControlStateNormal];
    
    UIImageView *backgroundImage = [[UIImageView alloc] init];
    
    backgroundImage.frame = (iPad) ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, 480);
    backgroundImage.image = (iPad) ? [UIImage imageNamed:@"Background_iPad"] : [UIImage imageNamed:@"Background"];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [backgroundImage release];
    
    [self performSelector:@selector(setupNotifications)];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
        [self play:nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
    reachablePoints = [[NSUserDefaults standardUserDefaults] integerForKey:@"reachablePoints"];
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {
	if (iPad) {
        optionsController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView-iPad" bundle:nil];
        optionsController.delegate = self;
        
        optionsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:optionsController animated:YES];
        
        [optionsController release];
    }
    else {
        optionsController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
        optionsController.delegate = self;
        
        optionsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:optionsController animated:YES];
        
        [optionsController release];
    }
}

- (void)reset {
    playerPoints                = 0;
    iDevicePoints               = 0;
    COMImageView.image          = nil;
    firstPlayerImageView.image  = nil;
    scoreboard.text             = @"0 - 0";
    currentResult.text          = nil;
    gameIsReset                 = YES;
    newNotification.myMessage   = nil;
    newNotification.winnerLooserImageView.image = nil;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
}

- (void)hideNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    newNotification.view.frame = CGRectMake(0, self.view.bounds.size.height + newNotification.view.bounds.size.height, newNotification.view.frame.size.width, newNotification.view.frame.size.width);
    [UIView commitAnimations];
    [self performSelector:@selector(reset)];
}

- (void)presentNotificationWithPlayerScore:(NSInteger)playerScore iDeviceScore:(NSInteger)COMScore hasWon:(BOOL)win {
    if (win) {
        newNotification.myMessage = [NSString stringWithFormat:resultWon, playerScore,COMScore];
        [newNotification image:[UIImage imageNamed:@"trophy.png"]];
    }
    else {
        newNotification.myMessage = [NSString stringWithFormat:resultLost, playerScore, COMScore];
        [newNotification image:[UIImage imageNamed:@"lost_inverted.png"]];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.75];
    newNotification.view.center = CGPointMake((self.view.bounds.size.width / 2), (self.view.bounds.size.height / 2));
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
        if (playerPoints > iDevicePoints) {
            [self presentNotificationWithPlayerScore:playerPoints iDeviceScore:iDevicePoints hasWon:YES];
        }
        else {
            [self presentNotificationWithPlayerScore:playerPoints iDeviceScore:iDevicePoints hasWon:NO];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:playerPoints forKey:@"playerPoints"];
        [[NSUserDefaults standardUserDefaults] setInteger:iDevicePoints forKey:@"iDevicePoints"];
    }
}

- (void)sharingMyScore:(NSInteger)pPoints device:(NSInteger)dPoints {
    NSString *message = (pPoints > dPoints) ? [NSString stringWithFormat:shareWon, pPoints, dPoints] : [NSString stringWithFormat:shareLost, pPoints, dPoints];
    
    SHKItem *item = [SHKItem text:message];
    [SHKFacebook shareItem:item];
    [item release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
    
    [firstPlayerImageView release];
    [COMImageView release];
    [buttonThrow release];
    [scoreboard release];
    [currentResult release];    
    [appTitle release];
    [buttonThrow release];
    [optionsController release];
    [newNotification release];
    [audioPlayer release];
}

@end