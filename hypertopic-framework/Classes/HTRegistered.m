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
	NSArray *users = [doc objectForKey:@"users"];
	if (users == nil)
		[doc setObject:[[NSArray alloc] initWithObjects:userID,nil] forKey:@"users"];
	else
		[doc setObject:[users arrayByAddingObject:userID] forKey: @"users"];
	
	return [self.database httpPut:[[doc copy] autorelease]];
}
- (BOOL)unRegisterUser:(NSString *)userID
{
	[self doesNotRecognizeSelector:_cmd];
	return false;
}
@end
