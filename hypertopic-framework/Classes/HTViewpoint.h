//
//  HTViewpoint.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTDatabase.h"
#import "HTRegistered.h"

@interface HTViewpoint : HTRegistered {
	
}

-(NSArray *) getUpperTopics;
-(NSArray *) getTopics;
-(NSArray *) getItems;
-(NSArray *) listUsers;

-(BOOL) rename: (NSString *)name;

-(BOOL) createTopic: (NSString *)parentTopicID, ...;
@end