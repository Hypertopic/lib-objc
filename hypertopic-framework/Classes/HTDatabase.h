/*
 *  RESTClient.h
 *  Hypertopic
 *
 *  Created by ZHOU Chao on 11-1-23.
 *  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#define HT_LOG(o) NSLog(@"%s = %@",__FUNCTION__,o);

@interface HTDatabase : NSObject {
@private
	NSString* serverUrl;
}

- (id)initWithServerUrl: (NSString*) s;

@property (readonly) NSString *serverUrl;

@end