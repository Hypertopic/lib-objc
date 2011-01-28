//
//  HTLocated.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//
#import "HTDatabase.h"
#import "HTLocated.h"

@implementation HTLocated
- (NSDictionary *) getRaw
{
	NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.database.serverUrl, objectID];
	return [self.database httpGet:urlString];
}
- (BOOL)destroy
{
	return [self.database httpDelete:[self getRaw]];
}
@end
