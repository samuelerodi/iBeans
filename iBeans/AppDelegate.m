//
//  AppDelegate.m
//  iBeans
//
//  Created by Sam on 11/24/14.
//  Copyright (c) 2014 Sam. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Register the preference defaults early.
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"sounds"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    appDefaults = [NSDictionary dictionaryWithObject:@"Human" forKey:@"player1Name"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    appDefaults = [NSDictionary dictionaryWithObject:@"Computer" forKey:@"player2Name"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.5] forKey:@"animationSpeed"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    appDefaults = [NSDictionary dictionaryWithObject:@"Theme1" forKey:@"theme"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    
    //init Statistics array
    NSMutableArray *stats=[[NSMutableArray alloc] initWithCapacity:0];
    appDefaults = [NSDictionary dictionaryWithObject:stats forKey:@"stats"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    NSMutableArray *victory=[[NSMutableArray alloc] initWithCapacity:2];
    appDefaults = [NSDictionary dictionaryWithObject:victory forKey:@"victory"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
