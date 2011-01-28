//
//  HTUser.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTIdentified.h"
#import "HTDatabase.h"
#import "HTCorpus.h"
#import "HTViewpoint.h"

@interface HTUser : HTIdentified {

}

#pragma mark -
#pragma mark List corpora and viewpoints
- (NSArray *)listCorpora;
- (NSArray *)listViewpoints;

#pragma mark -
#pragma mark Create corpus and viewpoint
- (HTViewpoint *)createViewpoint:(NSString *)name;
- (HTCorpus *)createCorpus:(NSString *)name;

@end
