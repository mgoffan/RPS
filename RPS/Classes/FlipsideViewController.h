//
//  FlipsideViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizedStrings.h"

@protocol FlipsideViewControllerDelegate;

@class MainViewController;

@interface FlipsideViewController : UIViewController <UIAlertViewDelegate>{
	id <FlipsideViewControllerDelegate> delegate;
    UISegmentedControl *segmentedControl;
    UIAlertView *myAlertView;
    UINavigationItem *navItem;
    UILabel *pointsLabel;
    MainViewController *mainController;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) MainViewController *mainController;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;

- (IBAction)segmentedControlValueChanged:(UIEvent *)event;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

