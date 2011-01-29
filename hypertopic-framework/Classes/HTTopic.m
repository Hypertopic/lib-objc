//
//  HTTopic.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTTopic.h"
#import <stdarg.h>
#import "HTItem.h"

@implementation HTTopic

@synthesize viewpoint;

- (id)initWithViewpoint:(HTViewpoint *)v withID:(NSString *)i
{
	if(self = [super init])
	{
		viewpoint = [v retain];
		objectID = [i copy];
		database = [v.database retain];
	}
	return self;
}

- (NSString *)getViewpointID
{
	return self.viewpoint.objectID;
}
- (NSArray *)getNarrower
{
	NSDictionary *view = [self getView];
	NSArray *narrowers = [view objectForKey:@"narrower"];
	NSMutableArray *result = [NSMutableArray new];
					   
	for(NSDictionary *narrower in narrowers)
		[result addObject: [viewpoint getTopic:[narrower objectForKey:@"id"]]];
	
	return [result autorelease];
}
- (NSArray *)getBroader
{
	NSDictionary *view = [self getView];
	NSArray *broaders = [[view objectForKey:@"broader"] autorelease];
	NSMutableArray *result = [NSMutableArray new];
	
	for(NSDictionary *broader in broaders)
		[result addObject: [viewpoint getTopic:[broader objectForKey:@"id"]]];
	
	return [result autorelease];
}
- (NSArray *)getItems
{
	NSMutableArray *result = [NSMutableArray new];
	NSArray *items = [[self getView] objectForKey:@"item"];
	for(NSDictionary *item in items)
	{
		[result addObject:[database getItem: item]];
	}
	NSArray *narrowers = [self getNarrower];
	for(HTTopic *topic in narrowers)
	{
		DLog(@"Topic name:%@", [topic getName]);
		NSArray *subItems = [topic getItems];
		if ([subItems count] > 0)
			[result addObjectsFromArray:subItems];
	}
	return [[result copy] autorelease];
}

- (BOOL)rename:(NSString *)name
{
	NSMutableDictionary *doc = [viewpoint getRaw];
	NSMutableDictionary *topics = [doc objectForKey:@"topics"];
	NSMutableDictionary *topic = [topics objectForKey:objectID];
	[topic setObject:name forKey:@"name"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)destroy
{
	NSMutableDictionary *doc = [viewpoint getRaw];
	DLog(@"%@", doc);
	[[doc objectForKey:@"topics"] removeObjectForKey: objectID];
	NSMutableDictionary *topics = [doc objectForKey:@"topics"];
	NSArray *topicIDs = [topics allKeys];
	DLog(@"objectID: %@", objectID);
	for(NSString *topicID in topicIDs)
	{
		DLog(@"topicID: %@", topicID);
		NSMutableArray *broader = [[topics objectForKey:topicID] objectForKey:@"broader"];
		if (broader && [broader count] > 0)
			DLog(@"broader:%@", [broader objectAtIndex:0]);
		
		if ([broader containsObject:objectID])
			[broader removeObject:objectID];
			
	}
	DLog(@"%@", doc);
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)moveTopics:(HTTopic *)narrowerTopic, ...
{
	va_list args;
	NSMutableDictionary *doc = [viewpoint getRaw];
	NSMutableDictionary *topics = [doc objectForKey:@"topics"];
	NSArray *broader = [[NSArray alloc] initWithObjects:objectID,nil];
	
	NSMutableArray *narrowerTopics = [NSMutableArray new];
	if (narrowerTopic)
	{
		[narrowerTopics addObject:[narrowerTopic getID]];
		va_start(args, narrowerTopic);
		HTTopic *t;
		while (t = va_arg(args, HTTopic *))
			[narrowerTopics addObject:[t getID]];
		va_end(args);
	}
	for(NSString *topicID in narrowerTopics)
		[[topics objectForKey:topicID] setObject:broader forKey:@"broader"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)unlink
{
	NSMutableDictionary *doc = [viewpoint getRaw];
	NSMutableDictionary *topics = [doc objectForKey:@"topics"];
	[[topics objectForKey:objectID] setObject:[NSArray new] forKey:@"broader"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)linkTopics: (HTTopic *)narrowerTopic, ...
{
	va_list args;
	NSMutableDictionary *doc = [viewpoint getRaw];
	NSMutableDictionary *topics = [doc objectForKey:@"topics"];
	NSMutableArray *narrowerTopics = [NSMutableArray new];
	if (narrowerTopic)
	{
		[narrowerTopics addObject:[narrowerTopic getID]];
		va_start(args, narrowerTopic);
		HTTopic *t;
		while (t = va_arg(args, HTTopic *))
			[narrowerTopics addObject:[t getID]];
		va_end(args);
	}
	for(NSString *topicID in narrowerTopics)
		if ([[topics objectForKey:topicID] objectForKey:@"broader"]) 
			[[[topics objectForKey:topicID] objectForKey:@"broader"] addObject: objectID];
		else
			[[topics objectForKey:topicID] setObject:[[[NSArray alloc] initWithObjects:objectID,nil] autorelease] forKey:@"broader"];
	return [self.database httpPut:[[doc copy] autorelease]];
}

#pragma mark Override getView and getViewUrl method
- (NSDictionary *)getView
{
	DLog(@"Viewpoint ID:%@", viewpoint.objectID);
	DLog(@"Topic ID:%@", objectID);
	
	return [[[self fetchView] objectForKey:viewpoint.objectID] objectForKey:objectID];
}
- (NSString *)getViewUrl
{
	return [NSString stringWithFormat:@"%@/viewpoint/%@", database.serverUrl, viewpoint.objectID];
}
@end
