//
//  HTViewpoint.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <stdarg.h>
#import "HTViewpoint.h"
#import "HTDatabase.h"

@implementation HTViewpoint

#pragma mark -
#pragma mark GET topics or items
-(NSArray *) getUpperTopics
{
	NSDictionary *view = [[self getView] autorelease];
	NSArray *upper = [view objectForKey:@"upper"];
	if (upper)
		return upper;
	return [[[NSArray alloc] array] autorelease];
}
-(NSArray *) getTopics
{
	NSDictionary *view = [[self getView] autorelease];
	NSArray *keys = [view allKeys];
	return keys;
}
-(NSArray *) getItems
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

#pragma mark List users
-(NSArray *) listUsers
{
	NSDictionary *view = [[self getView] autorelease];
	NSArray *users = [view objectForKey:@"user"];
	if (users)
		return users;
	return [[[NSArray alloc] array] autorelease];
}

#pragma mark Rename and create topics
- (BOOL)rename: (NSString *)name
{
	NSMutableDictionary *doc = [self getRaw];
	[doc setObject:name forKey:@"viewpoint_name"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
-(BOOL) createTopic: (NSString *)parentTopicID, ...
{
	NSString *uuid = [HTDatabase GetUUID];
	NSMutableDictionary *doc = [[self getRaw] autorelease];
	NSMutableDictionary *topics = [[doc objectForKey:@"topics"] autorelease];
	NSMutableDictionary *topic = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
	
	va_list args;
	NSArray *broader = [[[NSArray alloc] array] autorelease];
	if (parentTopicID)
	{
		[broader arrayByAddingObject:parentTopicID];
		va_start(args, parentTopicID);
		NSString *broaderID;
		while (broaderID = va_arg(args, NSString *))
			[broader arrayByAddingObject:broaderID];
		va_end(args);
	}
	[topic setObject:broader forKey:@"broader"];
	[topics setObject:topic forKey:uuid];
	[doc setObject:topics forKey:@"topics"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
@end
