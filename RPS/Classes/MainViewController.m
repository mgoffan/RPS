//
//  MainViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "FlipsideViewController.h"


@implementation MainViewController

@synthesize firstPlayerImageView, COMImageView, segmentControl, optionsController, scoreboard, currentResult, buttonThrow, appTitle;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    playerPoints    = 0;
    iDevicePoints   = 0;
    
    gameIsReset     = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    
    NSURL *url      = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bgmusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
	audioPlayer     = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    
	[audioPlayer play];
    
    [buttonThrow setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [buttonThrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appTitle.text = title;
    
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
    NSAutoreleasePool *pool     = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:1.3];
    playerPoints                = 0;
    iDevicePoints               = 0;
    COMImageView.image          = nil;
    firstPlayerImageView.image  = nil;
    scoreboard.text             = @"0 - 0";
    currentResult.text          = nil;
    gameIsReset = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    [pool release];
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
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"RPS"
                                      message:[NSString stringWithFormat:@"%@ %d - %d", wonWon,playerPoints,iDevicePoints]
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"RPS"
                                      message:[NSString stringWithFormat:@"%@ %d - %d", lostLost,iDevicePoints,playerPoints]
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        
        [NSThread detachNewThreadSelector:@selector(reset) toTarget:self withObject:nil];
    }
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
}


@end
