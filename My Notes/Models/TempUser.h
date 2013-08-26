//
//  TempUser.h
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempUser : NSObject

@property (nonatomic, strong) NSString* apiToken;
@property (nonatomic, strong) NSNumber* apiUserId;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSDate* lastSyncDate;
@property (nonatomic, strong) NSSet *notes;

@end
