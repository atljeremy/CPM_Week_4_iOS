//
//  Environment.h
//  SnapTo
//
//  Created by Jeremy Fox on 1/3/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AppEnvironmentDebug,
    AppEnvironmentProduction
} AppEnvironment;

typedef enum {
    IOSVersion50,
    IOSVersion51,
    IOSVersion60,
    IOSVersion61,
    IOSVersion70
} IOSVersion;

#define IS_568_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IOS7_OR_GREATER [Environment isIOSVersionOrGreater:IOSVersion70]

@interface Environment : NSObject

+ (BOOL)isRetina;
+ (BOOL)isDebug;
+ (BOOL)isiPad;
+ (BOOL)isIOSVersionOrGreater:(IOSVersion)version;

@end
