//
//  HTIdentified.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTDatabase.h"
#import "HTIdentified.h"


@implementation HTIdentified

@synthesize database;
@synthesize objectID;

- (id)initWithServer:(HTDatabase *)d withID:(NSString *)i
{
	if( self = [super init])
	{
		database = [d retain];
		objectID = [i copy];
	}
	return self;
}

- (void)dealloc
{
    [database release];
    [objectID release];
    [super dealloc];
}
- (NSString *)getID
{
	return self.objectID;
}
#pragma mark -
#pragma mark GET views
- (NSDictionary *)fetchView
{
	NSString *urlString = [self getViewUrl];
	if (urlString == nil) return nil;
	NSDictionary *result = [database getCache:urlString];
	if (result) return result;
	
	NSDictionary *view = [self.database httpGet: urlString];
	view = [self.database normalize:view];
	
	[database setCache:urlString withValue:view];
	DLog(@"View :%@", view);
	return view;
}
- (NSDictionary *)getView
{
	return [[self fetchView] objectForKey:objectID];
}
- (NSString *)getViewUrl
{
	NSString *className = NSStringFromClass([self class]); 
	DLog(@"Classname: %@", className);
	if ([className isEqual: @"HTUser"])
		return [NSString stringWithFormat:@"%@/user/%@", self.database.serverUrl, objectID];
	if ([className isEqual: @"HTCorpus"])
		return [NSString stringWithFormat:@"%@/corpus/%@", self.database.serverUrl, objectID];
	if ([className isEqual: @"HTViewpoint"])
		return [NSString stringWithFormat:@"%@/viewpoint/%@", self.database.serverUrl, objectID];
	
	return nil;
}
@end