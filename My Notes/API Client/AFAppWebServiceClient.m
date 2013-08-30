//
//  AFAppWebServiceClient.m
//  SnapTo
//
//  Created by Jeremy Fox on 1/12/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "AFAppWebServiceClient.h"
#import "AFJSONRequestOperation.h"
#import "SyncR.h"

NSString* const kSyncDidStartNotification = @"SyncDidFinishNotification";
NSString* const kSyncDidFinishNotification = @"SyncDidFinishNotification";
NSString* const kAPIStoredPrivateKey = @"APIPrivateKey";

static NSString* const kAFAppWebServiceClientBaseURLString = @"https://young-cove-5823.herokuapp.com/";
static NSString* const kAFAppWebServiceClientBaseURLStringDebug = @"http://192.168.1.109:3000/";
static NSString* const kAPIPrivateKeySalt = @"M440dOx2105dwLkp18T82dhEo794C17a";
static NSString* const kHasRegisteredWithAPI = @"HasRegisteredWithAPI";
static NSString* const kUUIDKey = @"UUIDKey";

@interface AFAppWebServiceClient()
@property (nonatomic, strong) NSString* apiKey;
@end

@implementation AFAppWebServiceClient

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Accept-Encoding" value:nil];
    
    return self;
}

+ (AFAppWebServiceClient *)sharedClient
{
    static AFAppWebServiceClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL* url = [NSURL URLWithString:kAFAppWebServiceClientBaseURLString];
        if ([Environment isDebug]) {
            url = [NSURL URLWithString:kAFAppWebServiceClientBaseURLStringDebug];
        }
        _sharedClient = [[AFAppWebServiceClient alloc] initWithBaseURL:url];
    });
    
    return _sharedClient;
}

+ (void)registerClientWithAPI
{
    User* user = [User userWithNotesSortedBy:NoteSortOptionCREATED ascending:YES];
    if (!user && [JFNetworkObserver isConnected]) {
        [[AFAppWebServiceClient sharedClient] postPath:@"users.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"RESPONSE: %@", responseObject);
            NSNumber* Id = [responseObject objectForKey:kUserIdKey];
            NSString* uniqueId = [responseObject objectForKey:kUserUniqueIdKey];
            if (Id && uniqueId) {
                uniqueId = [uniqueId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                TempUser* user = [[TempUser alloc] init];
                user.apiToken = uniqueId;
                user.apiUserId = Id;
                [User addUser:user];
                
                [[NSUserDefaults standardUserDefaults] setObject:uniqueId forKey:kAPIStoredPrivateKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[Mixpanel sharedInstance] registerSuperProperties:@{@"User API Key": uniqueId}];
                [[Mixpanel sharedInstance] track:@"Successfully registered client with API"];
                
                [AFAppWebServiceClient synchronize];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"ERROR: %@", [error localizedDescription]);
            [[AFAppWebServiceClient sharedClient] performSelector:@selector(retry) withObject:nil afterDelay:15.0];
            [[Mixpanel sharedInstance] track:@"Could not register client with API"];
        }];
    } else {
        NSString* apiToken = user.apiToken;
        if (apiToken && apiToken.length > 0) {
            [[Mixpanel sharedInstance] registerSuperProperties:@{@"User API Key": apiToken}];
        }
    }
}

- (void)retry
{
    [AFAppWebServiceClient registerClientWithAPI];
}

+ (void)synchronize
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSyncDidStartNotification object:nil];
    [SyncR sendUnsyncedNotesToAPIWithCompletionBlock:^(NSError *error) {
        if (!error) {
            NSArray* deletedNotes = [Note allNotesMarkedForDeletion];
            [SyncR deleteNotesFromAPI:deletedNotes withCompletionBlock:^(NSError *error) {
                NSLog(@"Deleted Notes From API Successfully!");
                [self getNotes];
            }];
        }
    }];
}

+ (void)getNotes
{
    [SyncR getNotesFromAPIWithSuccess:^(NSArray *notes) {
        NSLog(@"Retrieved Notes Successfully!");
        [[NSNotificationCenter defaultCenter] postNotificationName:kSyncDidFinishNotification object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed Retrieving Notes!");
        [[NSNotificationCenter defaultCenter] postNotificationName:kSyncDidFinishNotification object:nil];
    }];
}

@end
