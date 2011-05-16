//
//  Singleton.h
//  RPS
//
//  Created by Martin Goffan on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainViewController;

@interface Singleton : NSObject {
    NSInteger reachablePoints;
    NSInteger indexPoints;
    
    MainViewController* mVC;
}

@property (nonatomic, assign, readwrite) NSInteger reachablePoints;
@property (nonatomic, assign, readwrite) NSInteger indexPoints;
@property (nonatomic, retain) MainViewController *mVC;

+ (Singleton*)sharedSingleton;
- (NSInteger)returnReachablePoints;
- (void)setReachablePoints:(NSInteger)points var:(NSInteger)opt;
- (NSInteger)returnIPoints;

@end
