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
					   
	for(NSString *narrower in narrowers)
		[result addObject: [viewpoint getTopic:narrower]];
	
	return [result autorelease];
}
- (NSArray *)getBroader
{
	NSDictionary *view = [self getView];
	NSArray *broaders = [[view objectForKey:@"broader"] autorelease];
	NSMutableArray *result = [NSMutableArray new];
	
	for(NSString *broader in broaders)
		[result addObject: [viewpoint getTopic:broader]];
	
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
		[result addObject: [topic getItems]];
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
	[[doc objectForKey:@"topics"] removeObjectForKey: objectID];
	NSMutableDictionary *topics = [doc objectForKey:@"topics"];
	NSArray *topicIDs = [topics allKeys];
	for(NSString *topicID in topicIDs)
	{
		NSMutableArray *broader = [topics objectForKey:topicID];
		[broader removeObject:objectID];
	}
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
	return [[[self fetchView] objectForKey:viewpoint.objectID] objectForKey:objectID];
}
- (NSString *)getViewUrl
{
	return [NSString stringWithFormat:@"%@/viewpoint/%@", database.serverUrl, viewpoint.objectID];
}
@end
