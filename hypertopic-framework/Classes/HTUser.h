//
//  HTUser.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTIdentified.h"

@class HTDatabase;

@interface HTUser : HTIdentified {

}

#pragma mark -
#pragma mark List corpora and viewpoints
- (NSDictionary*)listCorpora;
- (NSDictionary*)listViewpoints;

#pragma mark -
#pragma mark Create corpus and viewpoint
- (BOOL)createViewpoint: (NSString *)name;

@end
