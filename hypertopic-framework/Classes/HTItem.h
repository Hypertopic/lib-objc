//
//  HTItem.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTLocated.h"
#import "HTCorpus.h"

@interface HTItem : HTLocated {
	HTCorpus *corpus;
}

@property (readonly) HTCorpus *corpus;

- (id) initWithCorpus: (HTCorpus *)c withID: (NSString *)i;
- (NSString *) getCorpusID;
- (BOOL) rename:(NSString *)name;

- (NSString *)getResource;
- (NSArray *)getTopics;
- (NSDictionary *)getAttributes;
- (BOOL) describe:(NSString *)name withValue:(NSString *)value;
- (BOOL) undescribe:(NSString *)name withValue:(NSString *)value;
- (BOOL) tag:(HTTopic *)topic;
- (BOOL) untag:(HTTopic *)topic;

@end