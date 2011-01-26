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

- (NSDictionary*)normalize:(NSDictionary *)doc
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSArray *rows = [doc objectForKey:@"rows"];
	for(NSDictionary *row in rows)
	{
		NSArray *keys = [row objectForKey:@"key"];
		NSMutableDictionary *current = result;
		for(NSString *key in keys)
		{
			if([current objectForKey:key] == nil)
				[current setObject:[[NSMutableDictionary alloc] init] forKey: key];			
			current = [current objectForKey:key];
		}
		NSDictionary *value = [row objectForKey:@"value"];
		for(NSString *attribute in value)
		{
			NSArray *v = [current objectForKey:attribute];
			if(v == nil)
				v = [NSArray arrayWithObject:[value objectForKey:attribute]];
			else
				[v arrayByAddingObject: [value objectForKey:attribute]];

			[current setObject:v forKey:attribute];
		}
	}
	/// DLog(@"result : %@", [result JSONRepresentation]);
	return result;
}
@end
