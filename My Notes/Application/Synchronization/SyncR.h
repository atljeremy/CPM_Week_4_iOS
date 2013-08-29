//
//  SyncR.h
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncR : NSObject

+ (void)getNotesFromAPIWithSuccess:(void (^)(NSArray *notes))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)sendUnsyncedNotesToAPIWithCompletionBlock:(void (^)(NSError* error))completionBlock;

+ (void)sendNoteToAPI:(Note*)note
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)deleteNotesFromAPI:(NSArray*)notes withCompletionBlock:(void (^)(NSError* error))completionBlock;

+ (void)updateNoteInAPI:(Note*)note
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
