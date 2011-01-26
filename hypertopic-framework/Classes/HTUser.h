//
//  HTUser.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HTDatabase;

@interface HTUser : NSObject {
	HTDatabase *database;
	NSString *userId;
}

/// Initialise a database with a server and user ID.
- (id)initWithServer:(HTDatabase*)db user:(NSString*)userId;

/// Database
@property (readonly) HTDatabase *database;
/// User ID
@property (readonly) NSString *userId;

#pragma mark -
#pragma mark GET Call
- (NSDictionary*)getView;
- (NSDictionary*)listCorpora;
- (NSDictionary*)listViewpoints;

#pragma mark POST and PUT Call

@end
