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
	NSDictionary *view = [[self getView] autorelease];
	NSArray *narrowers = [[view objectForKey:@"narrower"] autorelease];
	NSArray *result = [[NSArray alloc] array];
					   
	for(NSString *narrower in narrowers)
		[result arrayByAddingObject: [viewpoint getTopic:narrower]];
	
	return [result autorelease];
}
- (NSArray *)getBroader
{
	NSDictionary *view = [[self getView] autorelease];
	NSArray *broaders = [[view objectForKey:@"broader"] autorelease];
	NSArray *result = [[NSArray alloc] array];
	
	for(NSString *broader in broaders)
		[result arrayByAddingObject: [viewpoint getTopic:broader]];
	
	return [result autorelease];
}
- (NSArray *)getItems
{
	NSMutableArray *result = [[[NSMutableArray alloc] array] autorelease];
	NSArray *items = [[[self getView] objectForKey:@"item"] autorelease];
	for(NSDictionary *item in items)
	{
		[result arrayByAddingObject:[database getItem: item]];
	}
	NSArray *narrowers = [[self getNarrower] autorelease];
	for(HTTopic *topic in narrowers)
		[result addObjectsFromArray: [topic getItems]];
	return [[result copy] autorelease];
}

- (BOOL)rename:(NSString *)name
{
	NSMutableDictionary *doc = [[viewpoint getRaw] autorelease];
	NSMutableDictionary *topics = [[doc objectForKey:@"topics"] autorelease];
	NSMutableDictionary *topic = [[topics objectForKey:objectID] autorelease];
	[topic setObject:name forKey:@"name"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)destroy
{
	NSMutableDictionary *doc = [[viewpoint getRaw] autorelease];
	[[doc objectForKey:@"topics"] removeObjectForKey: objectID];
	NSMutableDictionary *topics = [[doc objectForKey:@"topics"] autorelease];
	NSArray *topicIDs = [topics allKeys];
	for(NSString *topicID in topicIDs)
	{
		NSMutableArray *broader = [[topics objectForKey:topicID] autorelease];
		[broader removeObject:objectID];
	}
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)moveTopics:(HTTopic *)narrowerTopic, ...
{
	va_list args;
	NSMutableDictionary *doc = [[viewpoint getRaw] autorelease];
	NSMutableDictionary *topics = [[doc objectForKey:@"topics"] autorelease];
	NSArray *broader = [[[NSArray alloc] initWithObjects:objectID,nil] autorelease];
	
	NSArray *narrowerTopics = [[[NSArray alloc] array] autorelease];
	if (narrowerTopic)
	{
		[narrowerTopics arrayByAddingObject:narrowerTopic];
		va_start(args, narrowerTopic);
		NSString *topicID;
		while (topicID = va_arg(args, NSString *))
			[narrowerTopics arrayByAddingObject:topicID];
		va_end(args);
	}
	for(NSString *topicID in narrowerTopics)
		[[topics objectForKey:topicID] setObject:broader forKey:@"broader"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)unlink
{
	NSMutableDictionary *doc = [[viewpoint getRaw] autorelease];
	NSMutableDictionary *topics = [[doc objectForKey:@"topics"] autorelease];
	[[topics objectForKey:objectID] setObject:[[[NSArray alloc] array] autorelease] forKey:@"broader"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)linkTopics: (HTTopic *)narrowerTopic, ...
{
	va_list args;
	NSMutableDictionary *doc = [[viewpoint getRaw] autorelease];
	NSMutableDictionary *topics = [[doc objectForKey:@"topics"] autorelease];
	NSArray *narrowerTopics = [[[NSArray alloc] array] autorelease];
	if (narrowerTopic)
	{
		[narrowerTopics arrayByAddingObject:narrowerTopic];
		va_start(args, narrowerTopic);
		NSString *topicID;
		while (topicID = va_arg(args, NSString *))
			[narrowerTopics arrayByAddingObject:topicID];
		va_end(args);
	}
	for(NSString *topicID in narrowerTopics)
		if ([[topics objectForKey:topicID] objectForKey:@"broader"]) 
			[[[topics objectForKey:topicID] objectForKey:@"broader"] arrayByAddingObject: objectID];
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
