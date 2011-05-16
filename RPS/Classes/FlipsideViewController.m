//
//  FlipsideViewController.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"
#import "Singleton.h"


@implementation FlipsideViewController

@synthesize delegate, segmentedControl, mainController;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    if (segmentedControl.selectedSegmentIndex != [[Singleton sharedSingleton] indexPoints]) {
        segmentedControl.selectedSegmentIndex = [[Singleton sharedSingleton] indexPoints];
    }
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)segmentedControlValueChanged:(UIEvent *)event {
    [[Singleton sharedSingleton] setReachablePoints:segmentedControl.selectedSegmentIndex var:0];
    [[Singleton sharedSingleton] setReachablePoints:segmentedControl.selectedSegmentIndex var:1];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
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
    
    [mainController release];
    [segmentedControl release];
}


@end
