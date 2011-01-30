//
//  HTDatabase.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTDatabase.h"
#import "HTListener.h"
#import "HTUser.h"
#import "HTCorpus.h"
#import "HTItem.h"
#import "HTViewpoint.h"
#import "HTTopic.h"
#import "JSON.h"

@implementation HTDatabase

@synthesize serverUrl = _serverUrl;
@synthesize listener;
@synthesize cache;

- (id) initWithServerUrl:(NSString *)s
{
	if(self = [super init])
	{
		_serverUrl = [s copy];
		listener = [[HTListener alloc] initWithServer: self];
		cache = [NSMutableDictionary new];
	}
	return self;
}

- (void)dealloc
{
    [_serverUrl release];
	[cache release];
	[listener release];
    [super dealloc];
}

- (id)init
{
    return [self initWithServerUrl:@"http://localhost:5984/argos/_design/argos/_rewrite"];
}

+ (NSString *)GetUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	NSMutableString *uuid = (NSMutableString *)string;
	[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
	[uuid lowercaseString];
	return [[uuid copy] autorelease];
}
+ (BOOL)isReserved:(NSString *)key;
{
	return [@"highlight" isEqual:key]
	|| [@"name" isEqual:key]
	|| [@"resource" isEqual:key]
	|| [@"thumbnail" isEqual:key]
	|| [@"topic" isEqual:key]
	|| [@"upper" isEqual:key]
	|| [@"user" isEqual:key];
}
#pragma mark -
#pragma mark Get Hypertopic Objects
- (HTUser *)getUser:(NSString *)u
{
    return [[[HTUser alloc] initWithServer:self withID:u] autorelease];
}
- (HTCorpus *)getCorpus:(NSString *)c
{
	return [[[HTCorpus alloc] initWithServer:self withID:c] autorelease];
}
- (HTItem *)getItem:(NSString *)i withCorpusID:(NSString *)c
{
	HTCorpus *corpus = [[[HTCorpus alloc] initWithServer:self withID:c] autorelease];
	return [corpus getItem: i];
}
- (HTItem *)getItem:(NSDictionary *)item
{
	NSString *corpusID = [item objectForKey:@"corpus"];
	NSString *itemID = [item objectForKey:@"item"];
	return [self getItem:itemID withCorpusID:corpusID];
}
- (HTViewpoint *)getViewpoint:(NSString *)viewpointID
{
	return [[[HTViewpoint alloc] initWithServer:self withID:viewpointID] autorelease];
}
- (HTTopic *)getTopic:(NSString *)topicID withViewpointID:(NSString *)viewpointID 
{
	return [[HTTopic alloc] initWithViewpoint: [[self getViewpoint: viewpointID] autorelease] withID: topicID];
}
#pragma mark -
#pragma mark HTTP requests
- (NSDictionary *)normalize:(NSDictionary *)doc
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	NSArray *rows = [doc objectForKey:@"rows"];
	for(NSDictionary *row in rows)
	{
		NSArray *keys = [row objectForKey:@"key"];
		NSMutableDictionary *current = result;
		for(NSString *key in keys)
		{
			if([current objectForKey:key] == nil)
				[current setObject:[[NSMutableDictionary alloc] init] forKey: key];			
			current = [current objectForKey:key];
		}
		NSDictionary *value = [row objectForKey:@"value"];
		for(NSString *attribute in value)
		{
			NSMutableArray *v = [current objectForKey:attribute];
			if(v == nil || [v count] == 0)
				v = [NSMutableArray arrayWithObject:[value objectForKey:attribute]];
			else
				[v addObject: [value objectForKey:attribute]];
			DLog(@"Array is %@", [v JSONRepresentation]);
			[current setObject:v forKey:attribute];
		}
	}
	DLog(@"doc : %@", doc);
	DLog(@"result : %@", result);
	return result;
}
- (NSDictionary *)httpGet: (NSString *)urlString
{
	DLog(@"HTTP GET Request on URL: %@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSError *error;
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
	DLog(@" URL Status Code %i", [response statusCode]);
    if (200 == [response statusCode]) {
        NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		DLog(@"Data from server: %@", json);
        return	[json JSONValue];
    }else{
        DLog(@"HTTP GET FAILED:  %@",  urlString );
        DLog(@"STATUS CODE %i",  [response statusCode]);
    }
    
    return nil;
}
- (BOOL)httpDelete:(NSDictionary *)doc
{
	NSString *docID = [doc objectForKey:@"_id"];
	NSString *docRev = [doc objectForKey:@"_rev"];
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?rev=%@", self.serverUrl, docID, docRev];
	DLog(@"HTTP DELETE Request on URL: %@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"DELETE"];
    NSError *error;
    NSHTTPURLResponse *response;
    (void)[NSURLConnection sendSynchronousRequest:request
								returningResponse:&response
											error:&error];
	DLog(@"DELETE URL Status Code %i", [response statusCode]);
	if (200 == [response statusCode]) {
		[self purgeCache];
		return TRUE;
	} 
	return FALSE;
}
- (BOOL)httpPut:(NSDictionary *)doc
{
	NSString *docID = [doc objectForKey:@"_id"];
	NSString *docRev = [doc objectForKey:@"_rev"];
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?rev=%@", self.serverUrl, docID, docRev];
	DLog(@"HTTP PUT Request on URL: %@", urlString);
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
	[request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPMethod:@"PUT"];
	[request setHTTPBody: [[doc JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSError *error;
    NSHTTPURLResponse *response;
    
	(void) [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
	DLog(@" URL Status Code %i", [response statusCode]);
	DLog(@" Request Body %@", doc);
    if (201 == [response statusCode] || 205 == [response statusCode])
	{
		[self purgeCache];
		return TRUE;
	}
	return FALSE;
}
- (NSDictionary *)httpPost:(NSDictionary *)doc
{
	
	NSURL *url = [NSURL URLWithString:self.serverUrl];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	[request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: [[doc JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSError *error;
    NSHTTPURLResponse *response;
    
	NSData *data = [NSURLConnection sendSynchronousRequest:request
								 returningResponse:&response
											 error:&error];
    
	DLog(@" URL Status Code %i", [response statusCode]);
	DLog(@" Request Body %@", doc);
    if (201 == [response statusCode]) {
		NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		[self purgeCache];
        return	[json JSONValue];
	}
	return nil;
}
#pragma mark -
#pragma mark Cache management
- (void)purgeCache
{
	@synchronized(self) 
	{
		[cache removeAllObjects];
	}
}
- (void)purgeCache:(NSData *)data
{
	@synchronized(self) 
	{
		[cache removeAllObjects];
		NSLog(@"purge cache: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	}
}
- (void)setCache:(NSString *)key withValue:(NSDictionary *)value
{
	@synchronized(self) 
	{
		[cache setObject:value forKey:key];
	}
}
- (NSDictionary *)getCache:(NSString *)key
{
	NSDictionary *result = nil;
	@synchronized(self) 
	{
		result = [cache objectForKey:key];
	}
	return result;
}
@end
