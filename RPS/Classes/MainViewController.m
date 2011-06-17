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

static NSString* lost;
static NSString* tie;
static NSString* won;

static NSString* lostLost;
static NSString* wonWon;

@synthesize firstPlayerImageView, COMImageView, segmentControl, optionsController, scoreboard, currentResult, buttonThrow, appTitle;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    lost = NSLocalizedString(@"Lost", @"");
    tie = NSLocalizedString(@"Tie", @"");
    won = NSLocalizedString(@"Won", @"");
    
    lostLost = NSLocalizedString(@"Lost Lost", @"");
    wonWon = NSLocalizedString(@"Won Won", @"");
    
    playerPoints = 0;
    iDevicePoints = 0;
    
    gameIsReset = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bgmusic.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
    
	[audioPlayer play];
    
    if (es) {
        appTitle.text = NSLocalizedString(@"Title", @"");
        
        [segmentControl setTitle:NSLocalizedString(@"Rock", @"") forSegmentAtIndex:0];
        [segmentControl setTitle:NSLocalizedString(@"Paper", @"") forSegmentAtIndex:1];
        [segmentControl setTitle:NSLocalizedString(@"Scissors", @"") forSegmentAtIndex:2];
    }
    
    UIImageView *backgroundImage = [[UIImageView alloc] init];
    if (iPad) {
        backgroundImage.frame = CGRectMake(0, 0, 768, 1024);
        backgroundImage.image = [UIImage imageNamed:@"Background_iPad"];
    }
    else {
        backgroundImage.frame = CGRectMake(0, 0, 320, 480);
        backgroundImage.image = [UIImage imageNamed:@"Background.png"];
    }
    
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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:1.3];
    playerPoints = 0;
    iDevicePoints = 0;
    COMImageView.image = nil;
    firstPlayerImageView.image = nil;
    scoreboard.text = @"0 - 0";
    currentResult.text = @" ";
    gameIsReset = YES;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    [pool release];
}

- (void)play:(id)sender {
	NSInteger choice = segmentControl.selectedSegmentIndex;
	int rnd = arc4random() % 3;
    
    gameIsReset = NO;
    [[NSUserDefaults standardUserDefaults] setBool:gameIsReset forKey:@"gameIsReset"];
    
    if (choice == 0) firstPlayerImageView.image = [UIImage imageNamed:@"rock"];
    else if (choice == 1) firstPlayerImageView.image = [UIImage imageNamed:@"paper"];
    else firstPlayerImageView.image = [UIImage imageNamed:@"scissor"];
    
    if (rnd == 0) COMImageView.image = [UIImage imageNamed:@"rock"];
    else if (rnd == 1) COMImageView.image = [UIImage imageNamed:@"paper"];
    else COMImageView.image = [UIImage imageNamed:@"scissor"];
    
    if (playerPoints < reachablePoints || iDevicePoints < reachablePoints) {
        if (choice == 0) {
            if (rnd == 0) {
                currentResult.text = tie;
            } else {
                if (rnd == 1) {
                    iDevicePoints++;
                    scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text = lost;
                } else {
                    playerPoints++;
                    scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text = won;
                }
            }
        } else {
            if (choice == 1) {
                if (rnd == 0) {
                    playerPoints++;
                    scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                    currentResult.text = won;
                } else {
                    if (rnd == 1) {
                        currentResult.text = tie;
                    } else {
                        iDevicePoints++;
                        scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text = lost;
                    }
                }
            } else {
                if (choice == 2) {
                    if (rnd == 0) {
                        iDevicePoints++;
                        scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                        currentResult.text = lost;
                    } else {
                        if (rnd == 1) {
                            playerPoints++;
                            scoreboard.text = [NSString stringWithFormat:@"%d - %d", playerPoints, iDevicePoints];
                            currentResult.text = won;
                        } else {
                            currentResult.text = tie;
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
