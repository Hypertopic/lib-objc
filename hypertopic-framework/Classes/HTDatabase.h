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
@class HTItem;
@class HTViewpoint;
@class HTTopic;
@class HTListener;

@interface HTDatabase : NSObject {
	HTListener *listener;
	NSMutableDictionary *cache;
	@private NSString* _serverUrl;
}

@property (readonly) NSString *serverUrl;
@property (retain) HTListener *listener;
@property (retain) NSMutableDictionary *cache;

- (id)initWithServerUrl:(NSString *)s;

+ (NSString *)GetUUID;
+ (BOOL)isReserved:(NSString *)key;

/// Returns an hypertopic object.
- (HTUser *)getUser:(NSString *)userID;
- (HTCorpus *)getCorpus:(NSString *)corpusID;
- (HTItem *)getItem:(NSString *)itemID withCorpusID:(NSString *)corpusID;
- (HTItem *)getItem:(NSDictionary *)item;
- (HTViewpoint *)getViewpoint:(NSString *)viewpointID;
- (HTTopic *)getTopic:(NSString *)topicID withViewpointID:(NSString *)viewpointID;

/// Parse returned view
- (NSDictionary *)normalize:(NSDictionary *)doc;
- (NSDictionary *)httpGet:(NSString *)urlString;

- (BOOL)httpDelete:(NSDictionary *)doc;

- (BOOL)httpPut:(NSDictionary *)doc;

- (NSDictionary *)httpPost:(NSDictionary *)doc;

- (void)purgeCache;
- (void)purgeCache:(NSData *)data;
- (void)setCache:(NSString *)key withValue:(NSDictionary *)value;
- (NSDictionary *)getCache:(NSString *)key;
@end