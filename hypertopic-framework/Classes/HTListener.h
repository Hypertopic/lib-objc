//
//  HTListen.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-29.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTDatabase.h"


@interface HTListener : NSObject {
	BOOL finished;
	BOOL started;
	HTDatabase *database;
	NSURL *changesUrl;
}

@property BOOL finished;

- (id)initWithServer:(HTDatabase *)db;
- (void)start;
@end
