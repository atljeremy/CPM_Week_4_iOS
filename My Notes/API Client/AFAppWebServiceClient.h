//
//  AFAppWebServiceClient.h
//  SnapTo
//
//  Created by Jeremy Fox on 1/12/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "AFHTTPClient.h"

extern NSString* const kSyncDidStartNotification;
extern NSString* const kSyncDidFinishNotification;
extern NSString* const kAPIStoredPrivateKey;

@interface AFAppWebServiceClient : AFHTTPClient

+ (AFAppWebServiceClient*)sharedClient;
+ (void)registerClientWithAPI;
+ (void)synchronize;

@end
