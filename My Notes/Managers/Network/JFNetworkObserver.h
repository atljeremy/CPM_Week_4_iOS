//
//  PRMNetworkObserver.h
//  ios_primedia
//
//  Created by Jeremy Fox on 9/4/12.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef NS_ENUM(NSInteger, JFNetworkState) {
    JFNetworkStateNotConnected,
    JFNetworkStateWWAN,
    JFNetworkStateWIFI
};

@interface JFNetworkObserver : NSObject {
    Reachability* hostReach;
}

@property (nonatomic, assign) BOOL connectedWWAN;
@property (nonatomic, assign) BOOL connectedWIFI;

+ (instancetype)sharedInstance;
- (JFNetworkState)determineNetworkReachability;
+ (BOOL)isConnected;
+ (BOOL)isConnectedWIFI;
+ (BOOL)isConnectedWWAN;
- (void)startMonitoringNetwork;
- (void)stopMonitoringNetwork;

@end
