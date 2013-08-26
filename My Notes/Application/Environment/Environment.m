//
//  Environment.m
//  SnapTo
//
//  Created by Jeremy Fox on 1/3/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "Environment.h"

static NSInteger const kIOSVersion50 = 5.0;
static NSInteger const kIOSVersion51 = 5.1;
static NSInteger const kIOSVersion60 = 6.0;
static NSInteger const kIOSVersion61 = 6.1;
static NSInteger const kIOSVersion70 = 7.0;

#ifdef DEBUG
static AppEnvironment env = AppEnvironmentProduction;
#else
static AppEnvironment env = AppEnvironmentProduction;
#endif

@interface Environment()
@property (nonatomic, readonly) int shareInterval;
@end

@implementation Environment

+ (BOOL)isRetina
{
    BOOL retval = NO;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        retval = YES;
    }
    return retval;
}

+ (BOOL)isDebug
{
    return env != AppEnvironmentProduction;
}

+ (BOOL)isiPad
{
    BOOL retVal = NO;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            retVal = YES;
        }
        else{
            retVal = NO;
        }
    }
    
    return retVal;
}

+ (BOOL)isIOSVersionOrGreater:(IOSVersion)version
{
    BOOL retVal = NO;
    
    float systemVersion = [Environment softwareVersion];
    
    switch (version) {
        case IOSVersion50:
            if (systemVersion >= kIOSVersion50) retVal = YES;
            break;
            
        case IOSVersion51:
            if (systemVersion >= kIOSVersion51) retVal = YES;
            break;
            
        case IOSVersion60:
            if (systemVersion >= kIOSVersion60) retVal = YES;
            break;
            
        case IOSVersion61:
            if (systemVersion >= kIOSVersion61) retVal = YES;
            break;
            
        case IOSVersion70:
            if (systemVersion >= kIOSVersion70) retVal = YES;
            break;
            
        default:
            break;
    }
    
    return retVal;
}

+(float)softwareVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

@end
