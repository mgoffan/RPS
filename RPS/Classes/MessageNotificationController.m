//
//  MessageNotificationController.m
//  iPhoneXMPP
//
//  Created by Martin Goffan on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageNotificationController.h"
#import "SinglePlayerViewController.h"

@implementation MessageNotificationController

@synthesize lMessage;
@synthesize winnerLooserImageView;
@synthesize myMessage;
@synthesize shareButton;
@synthesize mainController;

- (NSString *)message{
    return myMessage;
}

- (void)setMyMessage:(NSString *)myMessages {
    lMessage.text = myMessages;
}

- (void)image:(UIImage *)anImage{
    winnerLooserImageView.image = anImage;
}

- (void)share:(id)sender {
    [self.mainController share];
}

- (void)dealloc {
    [winnerLooserImageView release];
    [lMessage release];
    [myMessage release];
    
    [super dealloc];
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    lMessage = [[UILabel alloc] init];
    myMessage = [[NSString alloc] init];
    winnerLooserImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
    [winnerLooserImageView setContentMode:UIViewContentModeScaleToFill];
    SinglePlayerViewController *aMainViewController = [[SinglePlayerViewController alloc] init];
    self.mainController = aMainViewController;
    [aMainViewController release];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
