//
//  HTNamed.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTNamed.h"
#import "JSON.h"

@implementation HTNamed

- (NSString *)getName
{
	NSDictionary *view = [[self getView] autorelease];
	//DLog(@"json view: %@", [view JSONRepresentation]);
	NSArray *names = [view objectForKey:@"name"];
	
	if ([names count] > 0) {
		return [names objectAtIndex:0];
	}
	return nil;
}
@end
