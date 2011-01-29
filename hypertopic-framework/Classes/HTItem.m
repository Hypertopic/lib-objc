//
//  HTItem.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTItem.h"
#import "HTTopic.h"

@implementation HTItem

@synthesize corpus;

- (id)initWithCorpus:(HTCorpus *)c withID:(NSString *)i
{
	if(self = [super init])
	{
		corpus = [c retain];
		objectID = [i copy];
		database = [c.database retain];
	}
	return self;
}
- (BOOL)rename:(NSString *)name
{
	NSMutableDictionary *doc = [self getRaw];
	[doc setObject:name forKey:@"item_name"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (NSString *)getCorpusID
{
	return self.corpus.objectID;
}
- (NSString *)getResource
{
	NSDictionary *view = [[self getView] autorelease];
	NSArray *resources = [view objectForKey:@"resource"];
	if ([resources count] > 0) {
		return [resources objectAtIndex:0];
	}
	return nil;
}
- (NSArray *)getTopics
{
	NSMutableArray *result = [NSMutableArray new];
	NSDictionary *view = [self getView];
	DLog(@"view: %@", view);
	NSArray *topics = [[self getView] objectForKey:@"topic"];
	DLog(@"topics: %@", topics);
	for(NSDictionary *topic in topics)
		[result addObject:[database getTopic:[topic objectForKey:@"id"] withViewpointID:[topic objectForKey:@"viewpoint"]]];
	
	return result;
}
- (NSDictionary *)getAttributes
{
	NSMutableDictionary *result = [NSMutableDictionary new];
	NSDictionary *view = [self getView];
	NSArray *keys = [view allKeys];
	for(NSString *key in keys)
		if (![HTDatabase isReserved:key]) {
			NSArray *values = [view objectForKey:key];
			if (values != nil && [values count] > 0) 
				if ([[values objectAtIndex:0] isKindOfClass:[NSString class]])
					[result setObject: values forKey: key];
				else
					[result setObject: [values objectAtIndex:0] forKey: key];
		}
	DLog(@"Attributes: %@", result);
	return result;
}
- (BOOL) describe:(NSString *)name withValue:(NSString *)value
{
	NSMutableDictionary *doc = [self getRaw];

	if([doc objectForKey:name] == nil)
		[doc setObject:value forKey:name];
	else
		if ([[doc objectForKey:name] isKindOfClass:[NSString class]]) {
			NSString *v = [doc objectForKey:name];
			if ([v isEqual:value]) return true;
			NSArray *values = [[NSArray alloc] initWithObjects:v, value, nil];
			[doc setObject:values forKey:name];
		}
		else {
			NSMutableArray *values = [doc objectForKey:name];
			if ([values containsObject:value]) return true;
			[values addObject: value];
			[doc setObject:values forKey:name];
		}
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL) undescribe:(NSString *)name withValue:(NSString *)value
{
	NSMutableDictionary *doc = [self getRaw];
	if (![doc objectForKey:name]) 
		return true;
	if ([[doc objectForKey:name] isKindOfClass:[NSString class]]) 
	{
		if ([[doc objectForKey:name] isEqual: value])
			[doc removeObjectForKey:name];
		else
			return true;
	}
	else {
		NSMutableArray *values = [doc objectForKey:name];
		[values removeObject: value];
		switch ([values count]) 
		{
			case 0:
				[doc removeObjectForKey:name];
				break;
			case 1:
				[doc setObject:[values objectAtIndex:0] forKey:name];
				break;
			default:
				[doc setObject:values forKey:name];
				break;
		}
	}
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL) tag:(HTTopic *)topic
{
	NSString *topicID = [topic getID];
	NSString *viewpointID = [topic getViewpointID];
	NSMutableDictionary *topicObj = [NSMutableDictionary new];
	[topicObj setObject:viewpointID forKey:@"viewpoint"];
	NSMutableDictionary *doc = [self getRaw];
	if ([doc objectForKey:@"topics"] == nil)
		[doc setObject: [NSMutableDictionary new] forKey:@"topics"];
	[[doc objectForKey:@"topics"] setObject:topicObj forKey:topicID];
	DLog(@"item document: %@", doc);
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL) untag:(HTTopic *)topic
{
	NSString *topicID = [topic getID];
	NSMutableDictionary *doc = [self getRaw];
	if ([[doc objectForKey:@"topics"] objectForKey:topicID])
		[[doc objectForKey:@"topics"] removeObjectForKey:topicID];
	return [self.database httpPut:[[doc copy] autorelease]];
}
#pragma mark -
#pragma mark Override getView and getViewUrl method
- (NSDictionary *)getView
{
	return [[[self fetchView] objectForKey:corpus.objectID] objectForKey:objectID];
}
- (NSString *)getViewUrl
{
	return [NSString stringWithFormat:@"%@/item/%@/%@", self.database.serverUrl, self.corpus.objectID, objectID];
}
@end
