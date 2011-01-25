//
//  HTDatabase.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTDatabase.h"
#import "HTUser.h"

@implementation HTDatabase

@synthesize serverUrl = _serverUrl;

- (id) initWithServerUrl:(NSString *)s
{
	if(self = [super init])
	{
		_serverUrl = [s copy];
	}
	return self;
}

- (void)dealloc
{
    [_serverUrl release];
    [super dealloc];
}

- (id)init
{
    return [self initWithServerUrl:@"http://localhost:5984"];
}

- (HTUser*)getUser:(NSString*)u
{
    return [[[HTUser alloc] initWithServer:self user:u] autorelease];
}
@end
