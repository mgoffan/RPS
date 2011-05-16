//
//  Singleton.m
//  RPS
//
//  Created by Martin Goffan on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"
#import "MainViewController.h"


@implementation Singleton

@synthesize reachablePoints, mVC, indexPoints;

static Singleton* _sharedSingleton = nil;

+(Singleton*)sharedSingleton
{
	@synchronized([Singleton class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
        
		return _sharedSingleton;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([Singleton class])
	{
		NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedSingleton = [super alloc];
		return _sharedSingleton;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        reachablePoints = 1;
        indexPoints = 0;
	}
    
	return self;
}

- (NSInteger)returnReachablePoints {
    return reachablePoints;
}

- (void)setReachablePoints:(NSInteger)points var:(NSInteger)opt {
    if (opt == 0) {
        if (points == 0) {
            if (mVC.playerPoints >= points+1 || mVC.iDevicePoints >= points+1) {
                NSLog(@"error detect");
            }
            else {
                reachablePoints = 1;
            }
        } else {
            if (points == 1) {
                if (mVC.playerPoints >= points+2 || mVC.iDevicePoints >= points+2) {
                    NSLog(@"error detect");
                }
                else {
                    reachablePoints = 3;
                }
            } else {
                if (mVC.playerPoints >= points+3 || mVC.iDevicePoints >= points+3) {
                    NSLog(@"error detect");
                }
                else {
                    reachablePoints = 5;
                }
            }
        }
    }
    else {
        indexPoints = points;
    }
}

- (NSInteger)returnIPoints {
    return indexPoints;
}

@end
