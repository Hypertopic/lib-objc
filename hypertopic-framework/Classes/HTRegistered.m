//
//  HTRegistered.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTRegistered.h"
#import "HTDatabase.h"

@implementation HTRegistered
- (BOOL)registerUser:(NSString *)userID
{
	NSMutableDictionary *doc = [[[self getRaw] mutableCopy] autorelease];
	NSMutableArray *users = [doc objectForKey:@"users"];
	if (users == nil || [users count] == 0)
		[doc setObject:[[NSMutableArray alloc] initWithObjects:userID,nil] forKey:@"users"];
	else
	{
		[users addObject:userID];
		[doc setObject:users forKey: @"users"];
	}
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)unregisterUser:(NSString *)userID
{
	//[self doesNotRecognizeSelector:_cmd];
	//return false;
	NSMutableDictionary *doc = [[[self getRaw] mutableCopy] autorelease];
	NSMutableArray *users = [doc objectForKey:@"users"];
	if (users == nil || [users count] == 0)
		return true;
	[users removeObject:userID];
	[doc setObject:users forKey: @"users"];
	return [self.database httpPut:[[doc copy] autorelease]];
}
@end
