//
//  MenuViewController.m
//  RPS
//
//  Created by Martin Goffan on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SinglePlayerViewController.h"
#import "SettingsViewController.h"
#import "MultiplayerViewController.h"

@implementation MainViewController

@synthesize sPlayerViewController;
@synthesize settingsController;
@synthesize multiplayerController;
@synthesize loginController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSLog(@"aa");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)flush:(id)anObject {
    [anObject release];
    anObject = nil;
}

- (void)animationDidStop:(NSString *)animID finished:(BOOL)didFinish context:(void *)context {
    [self flush:loginController];
}

- (void)setupLogin {
    loginController = (iPad) ? [[LoginViewController alloc] initWithNibName:@"LoginViewController-iPad" bundle:[NSBundle mainBundle]] : [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:loginController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDuration:1.5];
    
    loginController.loginUp.frame = CGRectMake(0, -loginController.loginUp.frame.size.width, loginController.loginUp.frame.size.width, loginController.loginUp.frame.size.height);
    loginController.loginDown.frame = CGRectMake(0, self.view.frame.size.height + loginController.loginDown.frame.size.height, loginController.loginDown.frame.size.width, loginController.loginDown.frame.size.height);
    
    loginController.view.alpha = 0.0;
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"aa");
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)goSinglePlayer:(id)sender {
    sPlayerViewController = [[SinglePlayerViewController alloc] initWithNibName:@"SinglePlayerView" bundle:nil];
    
    UIView *currentView = self.view;
    UIView *theWindow = [currentView superview];
    UIView *newView = sPlayerViewController.view;
    newView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 20);
    
    [currentView removeFromSuperview];
    [theWindow addSubview:newView];
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[theWindow layer] addAnimation:animation forKey:@"SwitchToNextView"];
    
    [sPlayerViewController setupGameLogic];
    //[sPlayerViewController setupLogin];
    [sPlayerViewController setupNotifications];
    [sPlayerViewController setupUserInterface];
}

- (IBAction)goMultiplayer:(id)sender {
}

- (IBAction)goSettings:(id)sender {
}
@end
