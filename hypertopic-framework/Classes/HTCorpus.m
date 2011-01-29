//
//  HTCorpus.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTCorpus.h"
#import "HTItem.h"
#import "HTDatabase.h"
#import "JSON.h"

@implementation HTCorpus

- (NSArray *)listUsers
{
	NSDictionary *view = [self getView];
	return [view objectForKey:@"user"];
}
- (NSArray *)getItems
{
	NSMutableArray *result = [NSMutableArray new];
	NSArray *keys = [[self getView] allKeys];
	for(NSString *key in keys)
		if (![HTDatabase isReserved:key])
			[result addObject:[self getItem:key]];
	
	return [result autorelease];
}
- (BOOL)rename:(NSString *)name
{
	NSMutableDictionary *doc = [self getRaw];
	[doc setObject:name forKey:@"corpus_name"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (HTItem *)getItem:(NSString *)itemID
{
	return [[[HTItem alloc] initWithCorpus: self withID: itemID] autorelease];
}
- (HTItem *)createItem:(NSString *)name
{
	NSMutableDictionary *doc = [[NSMutableDictionary alloc] initWithCapacity:2];
	[doc setObject:name forKey: @"item_name"];
	[doc setObject:objectID forKey:@"item_corpus"];
	NSDictionary *new = [[doc copy] autorelease];
	[doc release];
	DLog(@"item: %@", new);
	NSDictionary *result = [self.database httpPost: new];
	DLog(@"returned: %@", result);
	NSString *resultID = [result objectForKey:@"id"];
	DLog(@"new created item id: %@", resultID);
	return [self getItem:resultID];
}

//Override destroy method
- (BOOL)destroy
{
	NSArray *items = [self getItems];
	for(HTItem *item in items)
		[item destroy];
	return [super destroy];
}
@end
