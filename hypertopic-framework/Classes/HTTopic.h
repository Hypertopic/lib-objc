//
//  HTTopic.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTNamed.h"
#import "HTViewpoint.h"

@interface HTTopic : HTNamed {
	HTViewpoint *viewpoint;
}

@property (readonly) HTViewpoint *viewpoint;

- (id)initWithViewpoint:(HTViewpoint *)v withID:(NSString *)i;
- (NSString *)getViewpointID;

- (NSArray *)getNarrower;
- (NSArray *)getBroader;
- (NSArray *)getItems;

- (BOOL)rename:(NSString *)name;
- (BOOL)destroy;
- (BOOL)moveTopics:(HTTopic *)narrowerTopic, ...;
- (BOOL)unlink;
- (BOOL)linkTopics:(HTTopic *)narrowerTopic, ...;
@end
