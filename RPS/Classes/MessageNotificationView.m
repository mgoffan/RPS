//
//  MessageNotificationView.m
//  RPS
//
//  Created by Martin Goffan on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageNotificationView.h"

@implementation MessageNotificationView

@synthesize theImageView;
@synthesize background;
@synthesize notification;
@synthesize delegate;
@synthesize isWon;
@synthesize label;
@synthesize shareButton;

- (void)flush:(id)anObject {
    [anObject release];
    anObject = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.isWon = NO;
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
        UIImage *bImage = [UIImage imageNamed:@"Notification_iPhone.png"];
        self.background.image = bImage;
        [self flush:bImage];
        self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        self.notification = nil;
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(71, 0, 320 - (68 * 2), 68)];
        self.label = aLabel;
        self.label.minimumFontSize = 22.0;
        self.label.numberOfLines = 3;
        UIColor *whiteColor = [UIColor whiteColor];
        self.label.textColor = whiteColor;
        [whiteColor release];
        [aLabel release];
        UIButton *aButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 68, 0, 68, 68)];
        self.shareButton = aButton;
        self.shareButton.titleLabel.text = @"Share";
        UIImage *anImage = [UIImage imageNamed:@"button.png"];
        [self.shareButton setBackgroundImage:anImage forState:UIControlStateNormal];
        [anImage release];
        [aButton release];
    }
    return self;
}

- (void)dealloc {
    [self flush:self.theImageView];
    [self flush:self.background];
    [self flush:self.notification];
}

- (void)setIsWon:(BOOL)isWon {
    self.isWon = isWon;
    
    if (isWon) self.theImageView.image = [UIImage imageNamed:@"trophy.png"];
    else self.theImageView.image = [UIImage imageNamed:@"lost.png"];
}

- (void)setNotification:(NSString *)notification {
    self.notification = notification;
    self.label.text = notification;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat x = [[touches anyObject] locationInView:self].x;
    if (x > 252) {
        [_delegate messageNotificationDidShare:self];
    }
}

@end