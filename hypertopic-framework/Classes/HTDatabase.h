/*
 *  RESTClient.h
 *  Hypertopic
 *
 *  Created by ZHOU Chao on 11-1-23.
 *  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class HTUser;
@class HTCorpus;

@interface HTDatabase : NSObject {
@private
	NSString* _serverUrl;
}

- (id)initWithServerUrl: (NSString*) s;

@property (readonly) NSString *serverUrl;

/// Returns an user object.
- (HTUser*)getUser:(NSString*) userID;
/// Returns a corpus.
- (HTCorpus*)getCorpus:(NSString*) corpusID;

/// Parse returned view
- (NSDictionary*)normalize:(NSDictionary*) doc;
- (NSDictionary*)httpGet:(NSString*)urlString;

- (BOOL)httpDelete:(NSDictionary*)doc;

- (BOOL)httpPut:(NSDictionary*)doc;

- (NSDictionary *)httpPost:(NSDictionary*)doc;
@end