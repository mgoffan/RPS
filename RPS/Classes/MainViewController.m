//
//  MainViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "Singleton.h"


@implementation MainViewController

@synthesize firstPlayerImageView, COMImageView, segmentControl, optionsController, iDevicePoints, playerPoints, scoreboard, currentResult, buttonThrow;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    playerPoints = 0;
    iDevicePoints = 0;
    reachablePoints = 1;
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bgmusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    
	[audioPlayer play];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    [backgroundImage release];
    
    UIImage* btnImage = [UIImage imageNamed:@"Throw.png"];
    [buttonThrow setImage:btnImage forState:UIControlStateNormal];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
        [self play:nil];
	}
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
	optionsController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	optionsController.delegate = self;
	
	optionsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:optionsController animated:YES];
	
	[optionsController release];
}

- (void)reset {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:1.3];
    playerPoints = 0;
    iDevicePoints = 0;
    COMImageView.image = nil;
    firstPlayerImageView.image = nil;
    scoreboard.text = @"0 - 0";
    currentResult.text = @" ";
    [pool release];
}

- (void)play:(id)sender {
	NSInteger choice = segmentControl.selectedSegmentIndex;
	int rnd = arc4random() % 3;
    
    if (choice == 0) {
		firstPlayerImageView.image = [UIImage imageNamed:@"rock"];
	}
    else {
        if (choice == 1) {
            firstPlayerImageView.image = [UIImage imageNamed:@"paper"];
        }
        else {
            if (choice == 2) {
                firstPlayerImageView.image = [UIImage imageNamed:@"scissor"];
            }
        }
    }
    
    if (rnd == 0) {
		COMImageView.image = [UIImage imageNamed:@"rock"];
	}
    else {
        if (rnd == 1) {
            COMImageView.image = [UIImage imageNamed:@"paper"];
        }
        else {
            if (rnd == 2) {
                COMImageView.image = [UIImage imageNamed:@"scissor"];
                
            }
        }
    }
    
    if (playerPoints < [[Singleton sharedSingleton] returnReachablePoints] || iDevicePoints < [[Singleton sharedSingleton] returnReachablePoints]) {
        if (choice == 0) {
            if (rnd == 0) {
                currentResult.text = @"It's a tie";
            } else {
                if (rnd == 1) {
                    iDevicePoints++;
                    scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text = @"You've lost";
                } else {
                    playerPoints++;
                    scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text = @"You've won";
                }
            }
        } else {
            if (choice == 1) {
                if (rnd == 0) {
                    playerPoints++;
                    scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text = @"You've won";
                } else {
                    if (rnd == 1) {
                        currentResult.text = @"It's a tie";
                    } else {
                        iDevicePoints++;
                        scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text = @"You've lost";
                    }
                }
            } else {
                if (choice == 2) {
                    if (rnd == 0) {
                        iDevicePoints++;
                        scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text = @"You've lost";
                    } else {
                        if (rnd == 1) {
                            playerPoints++;
                            scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                            currentResult.text = @"You've won";
                        } else {
                            currentResult.text = @"It's a tie";
                        }
                    }
                }
            }
        }
        if (playerPoints == [[Singleton sharedSingleton] returnReachablePoints] || iDevicePoints == [[Singleton sharedSingleton] returnReachablePoints]) {
            goto loop;
        }
    }
    else {
    loop:
        if (playerPoints > iDevicePoints) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"RPS"
                                      message:[NSString stringWithFormat:@"Congratulations you've beat me. You won %d - %d",playerPoints,iDevicePoints]
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"RPS"
                                      message:[NSString stringWithFormat:@"Haha. You suck. I won %d - %d",iDevicePoints,playerPoints]
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
