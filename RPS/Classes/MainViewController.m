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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    playerPoints    = 0;
    iDevicePoints   = 0;
    wonOrLost       = NO;
    
    gameIsReset     = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    
    NSURL *url      = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bgsound.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
	audioPlayer     = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    
    [audioPlayer prepareToPlay];
	[audioPlayer play];
    
    [buttonThrow setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [buttonThrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appTitle.text = header;
    
    [segmentControl setTitle:rock forSegmentAtIndex:0];
    [segmentControl setTitle:paper forSegmentAtIndex:1];
    [segmentControl setTitle:scissors forSegmentAtIndex:2];
    
    [buttonThrow setTitle:throw forState:UIControlStateNormal];
    
    UIImageView *backgroundImage = [[UIImageView alloc] init];
    
    backgroundImage.frame = (iPad) ? CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, 480);
    backgroundImage.image = (iPad) ? [UIImage imageNamed:@"Background_iPad"] : [UIImage imageNamed:@"Background"];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [backgroundImage release];
    
    newNotification = (iPad) ? [[MessageNotificationController alloc] initWithNibName:@"Notification-iPad" bundle:[NSBundle mainBundle]] : [[MessageNotificationController alloc] initWithNibName:@"Notification" bundle:[NSBundle mainBundle]];
    newNotification.view.frame = CGRectMake(0, self.view.bounds.size.height + newNotification.view.bounds.size.height, newNotification.view.frame.size.width, newNotification.view.frame.size.width);
    [self.view addSubview:newNotification.view];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [facebook handleOpenURL:url]; 
//}

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
    [self performSelector:@selector(reset)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    newNotification.view.frame = CGRectMake(0, self.view.bounds.size.height + newNotification.view.bounds.size.height, newNotification.view.frame.size.width, newNotification.view.frame.size.width);
    [UIView commitAnimations];
}

- (void)presentNotificationWithPlayerScore:(NSInteger)playerScore iDeviceScore:(NSInteger)COMScore hasWon:(BOOL)win {
    [audioPlayer pause];
    //NSString *applausePath = [[NSBundle mainBundle] pathForResource:@"applause" ofType:@"mp3"];
    //NSString *booingPath = [[NSBundle mainBundle] pathForResource:@"booing" ofType:@"wav"];
    
    //SystemSoundID soundID;
    
    NSURL *url;
	NSError *error;
	AVAudioPlayer *soundFX;// 
	soundFX.numberOfLoops = 1;
    
    if (win) {
        newNotification.myMessage = [NSString stringWithFormat:@"%@ %d - %d", wonWon, playerScore,COMScore];
        [newNotification image:[UIImage imageNamed:@"trophy.png"]];
        
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/applause.mp3", [[NSBundle mainBundle] resourcePath]]];
        soundFX = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        [soundFX prepareToPlay];
        [soundFX play];
        //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:applausePath], &soundID);
        
        //AudioServicesPlaySystemSound(soundID);
    }
    else {
        newNotification.myMessage = [NSString stringWithFormat:@"%@ %d - %d", lostLost,playerScore, COMScore];
        [newNotification image:[UIImage imageNamed:@"lost_inverted.png"]];
        
        url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/booing.wav", [[NSBundle mainBundle] resourcePath]]];
        soundFX = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        [soundFX prepareToPlay];
        [soundFX play];
        //AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:booingPath], &soundID);
        
        //AudioServicesPlaySystemSound(soundID);
    }
    
    [soundFX release];
    
    //[applausePath release];
    //[booingPath release];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    newNotification.view.center = CGPointMake((self.view.bounds.size.width / 2), (self.view.bounds.size.height / 2));
    [UIView commitAnimations];
    
    [self performSelector:@selector(hideNotification) withObject:nil afterDelay:5.0];
    [audioPlayer play];
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
                currentResult.text = tie;
            } else {
                if (rnd == 1) {
                    iDevicePoints++;
                    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text  = lost;
                } else {
                    playerPoints++;
                    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text  = won;
                }
            }
        } else {
            if (choice == 1) {
                if (rnd == 0) {
                    playerPoints++;
                    scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text  = won;
                } else {
                    if (rnd == 1) {
                        currentResult.text = tie;
                    } else {
                        iDevicePoints++;
                        scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text  = lost;
                    }
                }
            } else {
                if (choice == 2) {
                    if (rnd == 0) {
                        iDevicePoints++;
                        scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text  = lost;
                    } else {
                        if (rnd == 1) {
                            playerPoints++;
                            scoreboard.text     = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                            currentResult.text  = won;
                        } else {
                            currentResult.text  = tie;
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
            wonOrLost = YES;
        }
        else {
            [self presentNotificationWithPlayerScore:playerPoints iDeviceScore:iDevicePoints hasWon:NO];
            wonOrLost = NO;
        }
        
    }
}

- (void)sharing {
    NSString *message;
    if (wonOrLost) {
        if (es) message = [NSString stringWithFormat:@"Le gane %d - %d a RPS.", playerPoints, iDevicePoints];
        else message = [NSString stringWithFormat:@"I beat RPS %d - %d.", playerPoints, iDevicePoints];
    }
    else {
        if (es) message = [NSString stringWithFormat:@"Perdi %d - %d con RPS.", iDevicePoints, playerPoints];
        else message = [NSString stringWithFormat:@"I lost %d - %d with RPS.", iDevicePoints, playerPoints];
    }
    
    SHKItem *item = [SHKItem text:message];
    
    [SHKFacebook shareItem:item];
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
}


@end