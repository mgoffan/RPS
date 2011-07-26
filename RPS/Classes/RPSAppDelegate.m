//
//  RPSAppDelegate.m
//  RPS
//
//  Created by Martin on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RPSAppDelegate.h"
#import "MainViewController.h"

@implementation RPSAppDelegate


@synthesize window;
@synthesize mainViewController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gameDidFinish"];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gameDidFinish"];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
//    mainViewController.firstPlayerImageView = nil;
//    mainViewController.COMImageView         = nil;
//    mainViewController.segmentControl       = nil;
//    mainViewController.scoreboard           = nil;
//    mainViewController.currentResult        = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    
    [window addSubview:self.mainViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
