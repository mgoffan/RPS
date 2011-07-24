//
//  MenuViewController.h
//  RPS
//
//  Created by Martin Goffan on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface MenuViewController : UIViewController {
    MainViewController *mainViewController;
}

@property (nonatomic, retain) MainViewController *mainViewController;

- (IBAction)goSinglePlayer:(id)sender;
- (IBAction)goMultiplayer:(id)sender;
- (IBAction)goSettings:(id)sender;

@end
