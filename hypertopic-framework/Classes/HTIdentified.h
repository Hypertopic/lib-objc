//
//  HTIdentified.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HTDatabase;

@interface HTIdentified : NSObject {
	HTDatabase *database;
	NSString *objectID;
}

/// Initialise a database with a server and object ID.
- (id)initWithServer:(HTDatabase *)db withID:(NSString *)objectID;

/// Database
@property (readonly) HTDatabase *database;
/// ID
@property (readonly) NSString *objectID;

/// Fetch view from CouchDB server, and normalize it.
- (NSDictionary *)fetchView;
/// Return view by object keys
- (NSDictionary *)getView;

- (NSString *)getViewUrl;
@end