//
//  MenuViewController.h
//  RPS
//
//  Created by Martin Goffan on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>

#import "GameData.h"

@class LoginViewController;

@class SinglePlayerViewController;

@interface MainViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate> {
@private
    LoginViewController        *loginController;
    SinglePlayerViewController *SPController;
    
    GKSession *gameSession;
}

- (void)setupLogin;
- (void)allocateControllers;

@end
