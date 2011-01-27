//
//  HTTopic.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTTopic.h"


@implementation HTTopic

@synthesize viewpoint;

- (id)initWithViewpoint: (HTViewpoint *) v withID: (NSString *) i
{
	if(self = [super init])
	{
		viewpoint = [v retain];
		objectID = [i copy];
		database = [c.database retain];
	}
	return self;
}
- (NSString *)getViewpointID
{
	return self.viewpoint.objectID;
}
- (NSArray *)getNarrower
{
	return nil;
}
- (NSArray *)getBroader
{
	return nil;
}
- (NSArray *)getItems
{
	return nil;
}

-(BOOL)rename:(NSString *)name;
-(BOOL)destroy;
-(BOOL)moveTopics: (HTTopic *)narrowerTopic, ...;
-(BOOL)unlink;
-(BOOL)linkTopics: (HTTopic *)narrowerTopic, ...;
@end
