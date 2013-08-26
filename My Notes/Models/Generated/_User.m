// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.apiToken = @"apiToken",
	.apiUserId = @"apiUserId",
	.email = @"email",
	.lastSyncDate = @"lastSyncDate",
};

const struct UserRelationships UserRelationships = {
	.notes = @"notes",
};

const struct UserFetchedProperties UserFetchedProperties = {
};

@implementation UserID
@end

@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"apiUserIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"apiUserId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic apiToken;






@dynamic apiUserId;



- (int16_t)apiUserIdValue {
	NSNumber *result = [self apiUserId];
	return [result shortValue];
}

- (void)setApiUserIdValue:(int16_t)value_ {
	[self setApiUserId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveApiUserIdValue {
	NSNumber *result = [self primitiveApiUserId];
	return [result shortValue];
}

- (void)setPrimitiveApiUserIdValue:(int16_t)value_ {
	[self setPrimitiveApiUserId:[NSNumber numberWithShort:value_]];
}





@dynamic email;






@dynamic lastSyncDate;






@dynamic notes;

	
- (NSMutableSet*)notesSet {
	[self willAccessValueForKey:@"notes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"notes"];
  
	[self didAccessValueForKey:@"notes"];
	return result;
}
	






@end
