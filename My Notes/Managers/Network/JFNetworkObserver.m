//
//  PRMNetworkObserver.m
//  ios_primedia
//
//  Created by Jeremy Fox on 9/4/12.
//
//

#import "JFNetworkObserver.h"
#import "AppDelegate.h"

#define kRequestTimeoutWIFI 10.0
#define kRequestTimeoutWWAN 20.0

@implementation JFNetworkObserver

+ (instancetype)sharedInstance {
    static JFNetworkObserver *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (JFNetworkState)determineNetworkReachability {

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    JFNetworkState retVal = JFNetworkStateNotConnected;
    
    switch (networkStatus) {
        case ReachableViaWWAN:
        {
            retVal = JFNetworkStateWWAN;
            break;
        }
        case ReachableViaWiFi:
        {
            retVal = JFNetworkStateWIFI;
            break;
        }
        case NotReachable:
        {
            retVal = JFNetworkStateNotConnected;
            break;
        }
    }
    
    return retVal;
}

+ (BOOL)isConnected {
    return JFNetworkStateNotConnected != [[JFNetworkObserver sharedInstance] determineNetworkReachability];
}

+ (BOOL)isConnectedWIFI {
    return JFNetworkStateWIFI == [[JFNetworkObserver sharedInstance] determineNetworkReachability];
}

+ (BOOL)isConnectedWWAN {
    return JFNetworkStateWWAN == [[JFNetworkObserver sharedInstance] determineNetworkReachability];
}

- (void)startMonitoringNetwork {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
	hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
	[hostReach startNotifier];
}

- (void)stopMonitoringNetwork {
    [hostReach stopNotifier];
}

- (void)reachabilityChanged:(NSNotification*)notification
{
	Reachability* curReach = [notification object];
	if (curReach && [curReach isKindOfClass: [Reachability class]]) {
        NetworkStatus networkStatus = [curReach currentReachabilityStatus];
        
        switch (networkStatus) {
            case ReachableViaWWAN:
            {
                _connectedWIFI = NO;
                _connectedWWAN = YES;
                break;
            }
            case ReachableViaWiFi:
            {
                _connectedWIFI = YES;
                _connectedWWAN = NO;
                break;
            }
            case NotReachable:
            {
                _connectedWIFI = NO;
                _connectedWWAN = NO;
                break;
            }
        }
    }
}

@end
