//
//  MenuViewController.m
//  RPS
//
//  Created by Martin Goffan on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

#import "SinglePlayerViewController.h"

@implementation MainViewController

- (void)allocateControllers {
    NSLog(@"main allocate controllers");
}

- (void)flush:(id)anObject {
    [anObject release];
    anObject = nil;
    NSLog(@"main flush");
}

- (void)animationDidStop:(NSString *)animID finished:(BOOL)didFinish context:(void *)context {
    NSLog(@"main anim did stop");
    [self flush:loginController];
}

- (void)setupLogin {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunched"]) {
        loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.view addSubview:loginController.view];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDelay:1.5];
        [UIView setAnimationDuration:1.5];
        
        loginController.loginUp.frame = CGRectMake(0, -loginController.loginUp.frame.size.width, loginController.loginUp.frame.size.width, loginController.loginUp.frame.size.height);
        loginController.loginDown.frame = CGRectMake(0, self.view.frame.size.height + loginController.loginDown.frame.size.height, loginController.loginDown.frame.size.width, loginController.loginDown.frame.size.height);
        
        loginController.view.alpha = 0.0;
        
        [UIView commitAnimations];
        
        [[NSUserDefaults standardUserDefaults] setBool:kIsNotFirstTime forKey:@"hasLaunched"];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"main view load");
    
    SPController = [[SinglePlayerViewController alloc] initWithNibName:@"SinglePlayerView" bundle:nil];
    
    [self setupLogin];
    
    [super viewDidLoad];
}


- (void)viewDidUnload {
    NSLog(@"main view unload");
    [super viewDidUnload];
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

- (void)goMultiplayer:(id)sender {
    NSLog(@"main gomulti");
    GKPeerPickerController *peerPickerController = [[[GKPeerPickerController alloc] init] autorelease];
    [peerPickerController show];
    
    [gameSession initWithSessionID:nil displayName:nil sessionMode:GKSessionModePeer];
    gameSession.available = YES;
    gameSession.delegate  = self;
    /*GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
    mmvc.matchmakerDelegate = self;
    
    [self presentModalViewController:mmvc animated:YES]; */
}

@end
