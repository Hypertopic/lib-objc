/*
 *  HTCorpus.h
 *  Hypertopic
 *
 *  Created by ZHOU Chao on 11-1-26.
 *  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import "HTDatabase.h"
#import "HTRegistered.h"

@interface HTCorpus : HTRegistered {
}

- (NSArray *)listUsers;
- (NSArray *)getItems;

- (BOOL)rename:(NSString *)name;

- (HTItem *)getItem:(NSString *)itemID;
- (HTItem *)createItem:(NSString *)name;

@end
