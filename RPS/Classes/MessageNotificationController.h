//
//  MessageNotificationController.h
//  iPhoneXMPP
//
//  Created by Martin Goffan on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinglePlayerViewController;

@interface MessageNotificationController : UIViewController {
    IBOutlet UILabel *lMessage;
    IBOutlet UIImageView *winnerLooserImageView;
    IBOutlet UIButton *shareButton;
    NSString *myMessage;
}

@property (nonatomic, strong) IBOutlet UILabel *lMessage;
@property (nonatomic, strong) IBOutlet UIImageView *winnerLooserImageView;
@property (nonatomic, strong) NSString *myMessage;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) SinglePlayerViewController *mainController;

- (void)image:(UIImage *)anImage;
- (IBAction)share:(id)sender;

@end
