//
//  FlipsideViewController.h
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalizedStrings.h"
#import "GameData.h"

@class MainViewController;

@interface SettingsViewController : UIViewController <UIAlertViewDelegate> {
    UISegmentedControl *segmentedControl;
    UIAlertView *myAlertView;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlValueChanged:(UIEvent *)event;

@end