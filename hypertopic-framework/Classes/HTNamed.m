//
//  HTNamed.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTNamed.h"


@implementation HTNamed

-(NSString *)getName
{
	NSArray *names = [[self getView] objectForKey:@"name"];
	if(names != nil && [names count] > 0)
	{
		return [&names[0] description];
	}
	return nil;
}
@end
