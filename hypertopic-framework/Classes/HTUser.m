//
//  HTUser.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTUser.h"
#import "HTDatabase.h"

@implementation HTUser

@synthesize database;

#pragma mark -
#pragma mark List corpus and viewpoint
- (NSArray *)listCorpora
{
	NSDictionary *doc = [self getView];
	return [doc objectForKey:@"corpus"];
}
- (NSArray *)listViewpoints
{
	NSDictionary *doc = [self getView];
	return [doc objectForKey:@"viewpoint"];
}

#pragma mark -
#pragma mark Create corpus and viewpoint
- (HTViewpoint *)createViewpoint:(NSString *)name
{
	NSMutableDictionary *doc = [[NSMutableDictionary alloc] initWithCapacity:2];
	[doc setObject:name forKey: @"viewpoint_name"];
	[doc setObject:[[NSArray alloc] initWithObjects:objectID, nil] forKey:@"users"];
	NSDictionary *new = [[doc copy] autorelease];
	[doc release];
	DLog(@"viewpoint: %@", new);
	NSDictionary *result = [self.database httpPost: new];
	DLog(@"returned: %@", result);
	NSString *resultID = [result objectForKey:@"id"];
	//return self.database getViewpoint
	DLog(@"new created viewpoint id: %@", resultID);
	return [self.database getViewpoint:resultID];
}
- (HTCorpus *)createCorpus:(NSString *)name
{
	NSMutableDictionary *doc = [[NSMutableDictionary alloc] initWithCapacity:2];
	[doc setObject:name forKey: @"corpus_name"];
	[doc setObject:[[NSArray alloc] initWithObjects:objectID, nil] forKey:@"users"];
	NSDictionary *new = [[doc copy] autorelease];
	[doc release];
	DLog(@"viewpoint: %@", new);
	NSDictionary *result = [self.database httpPost: new];
	DLog(@"returned: %@", result);
	NSString *resultID = [result objectForKey:@"id"];
	//return self.database getViewpoint
	DLog(@"new created viewpoint id: %@", resultID);
	return [self.database getCorpus:resultID];
}
@end
