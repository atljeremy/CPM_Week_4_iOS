//
//  TempNote.h
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempNote : NSObject

@property (nonatomic, strong) NSNumber* apiNoteId;
@property (nonatomic, strong) NSString* createdAt;
@property (nonatomic, strong) NSString* updatedAt;
@property (nonatomic, strong) NSString* details;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) User *user;

@end
