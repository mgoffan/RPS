//
//  FlipsideViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"


@implementation SettingsViewController

@synthesize segmentedControl, mainController, navItem;

- (void)viewWillAppear:(BOOL)animated {
    segmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"indexPoints"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"gameIsReset"]) segmentedControl.enabled = YES;
    else {
        segmentedControl.enabled = NO;
        [myAlertView show];
    }
    
    [super viewWillAppear:animated];
}

- (IBAction)segmentedControlValueChanged:(UIEvent *)event {
    [[NSUserDefaults standardUserDefaults] setInteger:segmentedControl.selectedSegmentIndex forKey:@"indexPoints"];
    if (segmentedControl.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"reachablePoints"];
    }
    else if (segmentedControl.selectedSegmentIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"reachablePoints"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"reachablePoints"];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)flush:(id)anObject {
    [anObject release];
    anObject = nil;
}

- (void)viewDidUnload {
    [self flush:mainController];
    [self flush:segmentedControl];
    [self flush:navItem];
}

- (void)goBack {
    mainController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    
    UIView *currentView = self.view;
    UIView *theWindow = [currentView superview];
    UIView *newView = mainController.view;
    newView.center = CGPointMake(self.view.frame.size.width / 2 + 20, self.view.frame.size.height / 2 + 40);
    
    [currentView removeFromSuperview];
    [theWindow addSubview:newView];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[theWindow layer] addAnimation:animation forKey:@"SwitchBack"];
    
    [mainController release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    myAlertView = [[UIAlertView alloc] initWithTitle:gameLocalization message:notificationPointChange delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(goBack)];
    self.navItem.leftBarButtonItem = backItem;
    [backItem release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
