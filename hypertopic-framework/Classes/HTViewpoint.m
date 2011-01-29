//
//  HTViewpoint.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <stdarg.h>
#import "HTViewpoint.h"
#import "HTTopic.h"
#import "HTDatabase.h"

@implementation HTViewpoint

#pragma mark -
#pragma mark GET topics or items
- (NSArray *)getUpperTopics
{
	NSDictionary *view = [self getView];
	NSArray *upper = [view objectForKey:@"upper"];
	NSMutableArray *result = [NSMutableArray new];
	if (upper)
		for(NSDictionary *topic in upper)
		{
			DLog(@"topic id:%@", topic);
			[result addObject:[self getTopic:[topic objectForKey:@"id"]]];
		}
	return [[result copy] autorelease];
}
- (NSArray *)getTopics
{
	NSDictionary *view = [self getView];
	NSArray *keys = [view allKeys];
	NSMutableArray *result = [NSMutableArray new];
	for(NSString *key in keys)
		if (![HTDatabase isReserved:key]) 		
			[result addObject:[self getTopic:key]];
	return [[result copy] autorelease];
}
- (NSArray *)getItems
{
	//[self doesNotRecognizeSelector:_cmd];
	//return nil;
	NSMutableArray *result = [NSMutableArray new];
	NSArray *uppers = [self getUpperTopics];
	for(HTTopic *topic in uppers)
	{
		DLog(@"topic name:%@", [topic getName]);
		[result addObjectsFromArray: [topic getItems]];
	}
	return result;
}
- (HTTopic *)getTopic:(NSString *)topicID
{
	return [[[HTTopic alloc] initWithViewpoint:self withID:topicID] autorelease];
}

#pragma mark List users
- (NSArray *)listUsers
{
	NSDictionary *view = [self getView];
	NSArray *users = [view objectForKey:@"user"];
	if (users)
		return users;
	return [[NSArray new] autorelease];
}

#pragma mark Rename and create topics
- (BOOL)rename:(NSString *)name
{
	NSMutableDictionary *doc = [self getRaw];
	[doc setObject:name forKey:@"viewpoint_name"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (HTTopic *)createTopicWithName:(NSString *)name
{
	NSString *uuid = [HTDatabase GetUUID];
	NSMutableDictionary *doc = [self getRaw];
	NSMutableDictionary *topics = ([doc objectForKey:@"topics"]) ? [doc objectForKey:@"topics"] : [NSMutableDictionary new];
	NSMutableDictionary *topic = [NSMutableDictionary new];
	
	[topic setObject:[NSArray new] forKey:@"broader"];
	[topic setObject:name forKey:@"name"];
	[topics setObject:topic forKey:uuid];
	[doc setObject:topics forKey:@"topics"];
	if ([self.database httpPut:[[doc copy] autorelease]])
		return [[HTTopic alloc] initWithViewpoint:self withID:uuid];
	return nil;
}
- (HTTopic *)createTopic
{
	NSString *uuid = [HTDatabase GetUUID];
	NSMutableDictionary *doc = [self getRaw];
	DLog(@"topic wiil be created on viewpoint: %@", doc );
	NSMutableDictionary *topics = ([doc objectForKey:@"topics"]) ? [doc objectForKey:@"topics"] : [NSMutableDictionary new];
	NSMutableDictionary *topic = [NSMutableDictionary new];
	
	[topic setObject:[NSArray new] forKey:@"broader"];
	
	[topics setObject:topic forKey:uuid];
	[doc setObject:topics forKey:@"topics"];
	DLog(@"topic created on viewpoint: %@", doc);
	if ([self.database httpPut:[[doc copy] autorelease]])
		return [[HTTopic alloc] initWithViewpoint:self withID:uuid];
	return nil;
}
- (HTTopic *)createTopic:(HTTopic *)parentTopic, ...
{
	NSString *uuid = [HTDatabase GetUUID];
	NSMutableDictionary *doc = [self getRaw];
	NSMutableDictionary *topics = ([doc objectForKey:@"topics"]) ? [doc objectForKey:@"topics"] : [NSMutableDictionary new];
	NSMutableDictionary *topic = [NSMutableDictionary new];
	
	va_list args;
	NSMutableArray *broader = [NSMutableArray new];
	if (parentTopic)
	{
		[broader addObject:[parentTopic getID]];
		va_start(args, parentTopic);
		HTTopic *broaderTopic;
		while (broaderTopic = va_arg(args, HTTopic *))
			[broader addObject:[broaderTopic getID]];
		va_end(args);
	}
	[topic setObject:broader forKey:@"broader"];
	[topics setObject:topic forKey:uuid];
	[doc setObject:topics forKey:@"topics"];
	if ([self.database httpPut:[[doc copy] autorelease]])
		return [[HTTopic alloc] initWithViewpoint:self withID:uuid];
	return nil;
}
@end
