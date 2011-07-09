//
//  LoginViewController.h
//  RPS
//
//  Created by Martin Goffan on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    IBOutlet UIImageView *loginUp;
    IBOutlet UIImageView *loginDown;
}

@property (nonatomic, retain) IBOutlet UIImageView *loginUp;
@property (nonatomic, retain) IBOutlet UIImageView *loginDown;

@end