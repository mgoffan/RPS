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
#import "LoginViewController.h"

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

- (IBAction)goSinglePlayer:(id)sender {
    sPlayerViewController = [[SinglePlayerViewController alloc] initWithNibName:@"SinglePlayerView" bundle:nil];
    
    UIView *currentView = self.view;
    UIView *theWindow = [currentView superview];
    UIView *newView = sPlayerViewController.view;
    newView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 20);
    
    [currentView removeFromSuperview];
    [theWindow addSubview:newView];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[theWindow layer] addAnimation:animation forKey:@"SwitchToSinglePlayer"];
    
    [sPlayerViewController setupGameLogic];
    [sPlayerViewController setupNotifications];
    [sPlayerViewController setupUserInterface];
    
    [sPlayerViewController release];
}

//GameKit Methods
#pragma mark GameKit Methods

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    [gameSession acceptConnectionFromPeer:peerID error:nil];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    [picker dismiss];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    [picker dismiss];
    return gameSession;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    [picker dismiss];
    gameSession = session;
}

- (IBAction)goMultiplayer:(id)sender {
    GKPeerPickerController *peerPickerController = [[[GKPeerPickerController alloc] init] autorelease];
    [peerPickerController show];
    
    [gameSession initWithSessionID:nil displayName:nil sessionMode:GKSessionModePeer];
    gameSession.available = YES;
    gameSession.delegate  = self;
    //    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
    //    request.minPlayers = 2;
    //    request.maxPlayers = 2;
    //    
    //    GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
    //    mmvc.matchmakerDelegate = self;
    //    
    //    [self presentModalViewController:mmvc animated:YES];
}

- (IBAction)goSettings:(id)sender {
    settingsController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    
    UIView *currentView = self.view;
    UIView *theWindow = [currentView superview];
    UIView *newView = settingsController.view;
    newView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + 20);
    
    [currentView removeFromSuperview];
    [theWindow addSubview:newView];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[theWindow layer] addAnimation:animation forKey:@"SwitchToSettings"];
    
    [settingsController release];
}
@end
