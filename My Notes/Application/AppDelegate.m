//
//  AppDelegate.m
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "AppDelegate.h"

static NSString* const kMixpanelAPIToken = @"df49dbcdde0aee6a525935db89b2dd4c";
static NSString* const kMixpanelAPITokenDebug = @"af74f6e26c2359363ff046b1540ea575";
static NSString* const kIsFirstAppLaunch = @"kIsFirstAppLaunch";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[JFCoreDataManager sharedInstance] managedObjectContext];
    [[JFCoreDataManager sharedInstance] registerForContextSavedNotifications];
    if ([Environment isDebug]) {
        [Mixpanel sharedInstanceWithToken:kMixpanelAPITokenDebug];
    } else {
        [Mixpanel sharedInstanceWithToken:kMixpanelAPIToken];
    }
    
    if (self.isFirstRun) {
        [[Mixpanel sharedInstance] track:@"Is first application launch"];
    }
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[JFNetworkObserver sharedInstance] startMonitoringNetwork];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [AFAppWebServiceClient registerClientWithAPI];
    [AFAppWebServiceClient synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[JFNetworkObserver sharedInstance] stopMonitoringNetwork];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[JFCoreDataManager sharedInstance] saveContext];
}

- (BOOL)isFirstRun
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kIsFirstAppLaunch]) return NO;
    
    [defaults setObject:[NSDate date] forKey:kIsFirstAppLaunch];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

@end
