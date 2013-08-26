// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.m instead.

#import "_Note.h"

const struct NoteAttributes NoteAttributes = {
	.apiNoteId = @"apiNoteId",
	.createdAt = @"createdAt",
	.details = @"details",
	.title = @"title",
	.updatedAt = @"updatedAt",
};

const struct NoteRelationships NoteRelationships = {
	.user = @"user",
};

const struct NoteFetchedProperties NoteFetchedProperties = {
};

@implementation NoteID
@end

@implementation _Note

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Note";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc_];
}

- (NoteID*)objectID {
	return (NoteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"apiNoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"apiNoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic apiNoteId;



- (int16_t)apiNoteIdValue {
	NSNumber *result = [self apiNoteId];
	return [result shortValue];
}

- (void)setApiNoteIdValue:(int16_t)value_ {
	[self setApiNoteId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveApiNoteIdValue {
	NSNumber *result = [self primitiveApiNoteId];
	return [result shortValue];
}

- (void)setPrimitiveApiNoteIdValue:(int16_t)value_ {
	[self setPrimitiveApiNoteId:[NSNumber numberWithShort:value_]];
}





@dynamic createdAt;






@dynamic details;






@dynamic title;






@dynamic updatedAt;






@dynamic user;

	






@end
