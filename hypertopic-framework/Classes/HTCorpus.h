/*
 *  HTCorpus.h
 *  Hypertopic
 *
 *  Created by ZHOU Chao on 11-1-26.
 *  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>

@class HTDatabase;

@interface HTCorpus : NSObject {
	HTDatabase *database;
	NSString *corpusID;
}

/// Initialise a database with a server and corpus ID.
- (id)initWithServer:(HTDatabase*)db withCorpusID:(NSString*)corpusID;

/// Database
@property (readonly) HTDatabase *database;
/// User ID
@property (readonly) NSString *corpusID;

#pragma mark -
#pragma mark GET Call
//- (NSDictionary*)getView;

#pragma mark POST and PUT Call

@end
