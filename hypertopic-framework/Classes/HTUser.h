/*
 *  HTUser.h
 *  Hypertopic
 *
 *  Created by ZHOU Chao on 11-1-25.
 *  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import <JSON/JSON.h>
#import <HTDatabase.h>

@interface HTUser : NSObject {
	HTDatabase *htDatabase;
	NSString *userId;
}

/// Initialise a database with a server and user ID.
- (id)initWithServer:(HTDatabase*)server name:(NSString*)name;

/// Database
@property (readonly) HTDatabase *htDatabase;
/// User ID
@property (readonly) NSString *userId;

#pragma mark -
#pragma mark GET Call
- (NSDictionary*)get:(NSString*)args;

@end