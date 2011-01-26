//
//  HTIdentified.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTDatabase.h"
#import "HTIdentified.h"


@implementation HTIdentified

@synthesize database;
@synthesize objectID;

- (id) initWithServer:(HTDatabase *)d withID:(NSString *)i
{
	if( self = [super init])
	{
		database = [d retain];
		objectID = [i copy];
	}
	return self;
}

- (void)dealloc
{
    [database release];
    [objectID release];
    [super dealloc];
}

-(NSDictionary *) getView
{
	NSString *urlString = [self getViewUrl];
	if(urlString == nil) return nil;
	NSDictionary *view = [self.database httpGet: urlString];
	view = [self.database normalize:view];
	DLog(@"View :%@", view);
	return [view objectForKey:objectID];
}
-(NSString *) getViewUrl
{
	NSString *className = NSStringFromClass([self class]); 
	DLog(@"Classname: %@", className);
	if ([className isEqual: @"HTUser"])
		return [NSString stringWithFormat:@"%@/user/%@", self.database.serverUrl, objectID];
	return nil;
}
@end