//
//  MenuViewController.h
//  RPS
//
//  Created by Martin Goffan on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "LoginViewController.h"

@class SinglePlayerViewController;
@class SettingsViewController;
@class MultiplayerViewController;

@class LoginViewController;

@interface MainViewController : UIViewController {
    SinglePlayerViewController *sPlayerViewController;
    LoginViewController        *loginController;
    SettingsViewController     *settingsController;
    MultiplayerViewController  *multiplayerController;
}

@property (nonatomic, retain) SinglePlayerViewController *sPlayerViewController;
@property (nonatomic, retain) LoginViewController        *loginController;
@property (nonatomic, retain) SettingsViewController     *settingsController;
@property (nonatomic, retain) MultiplayerViewController  *multiplayerController;

- (IBAction)goSinglePlayer:(id)sender;
- (IBAction)goMultiplayer:(id)sender;
- (IBAction)goSettings:(id)sender;

- (void)setupLogin;

@end
