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

@class HTTopic;

@interface HTViewpoint : HTRegistered {
	
}

- (NSArray *)getUpperTopics;
- (NSArray *)getTopics;
- (NSArray *)getItems;

- (HTTopic *)getTopic:(NSString *)topicID;

- (NSArray *)listUsers;

- (BOOL)rename:(NSString *)name;

- (HTTopic *)createTopicWithName:(NSString *)name;

- (HTTopic *)createTopic;
- (HTTopic *)createTopic:(HTTopic *)parentTopicID, ...;

@end