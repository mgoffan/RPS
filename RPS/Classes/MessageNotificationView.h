//
//  MessageNotificationView.h
//  RPS
//
//  Created by Martin Goffan on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageNotificationView;

@protocol MessageNotificationViewDelegate
- (void)messageNotificationDidShare:(MessageNotificationView *)messageNotificationView;
@end

@interface MessageNotificationView : UIView {
    BOOL _isWon;
    
    UIImageView *theImageView;
    UIImageView *background;
    UILabel *label;
    UIButton *shareButton;
    NSString *_notification;
    
    id<MessageNotificationViewDelegate> _delegate;
}

@property BOOL isWon;

@property (strong) UIImageView *theImageView;
@property (strong) UIImageView *background;
@property (strong) UILabel *label;
@property (strong) UIButton *shareButton;
@property (strong) NSString *notification;
@property (assign) id<MessageNotificationViewDelegate> delegate;

@end