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

@interface HTDatabase : NSObject {
@private
	NSString* _serverUrl;
}

- (id)initWithServerUrl: (NSString*) s;

@property (readonly) NSString *serverUrl;

/// Returns an user object.
- (HTUser*)getUser:(NSString*)userId;
/// Parse returned view
- (NSDictionary*)normalize:(NSDictionary*) doc;
@end