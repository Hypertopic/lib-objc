//
//  HTItem.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTItem.h"


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
- (NSString *)getCorpusID
{
	return self.corpus.objectID;
}

- (BOOL)rename:(NSString *)name
{
	NSMutableDictionary *doc = [self getRaw];
	[doc setObject:name forKey:@"item_name"];
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
