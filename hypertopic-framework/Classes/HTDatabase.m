//
//  HTDatabase.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTDatabase.h"
#import "HTUser.h"
#import "HTCorpus.h"
#import "JSON.h"

@implementation HTDatabase

@synthesize serverUrl = _serverUrl;

- (id) initWithServerUrl:(NSString *)s
{
	if(self = [super init])
	{
		_serverUrl = [s copy];
	}
	return self;
}

- (void)dealloc
{
    [_serverUrl release];
    [super dealloc];
}

- (id)init
{
    return [self initWithServerUrl:@"http://localhost:5984/argos/_design/argos/_rewrite"];
}

#pragma mark -
#pragma mark Get Hypertopic Objects
- (HTUser*)getUser:(NSString*)u
{
    return [[[HTUser alloc] initWithServer:self withID:u] autorelease];
}
- (HTCorpus*)getCorpus:(NSString *)c
{
	return [[[HTCorpus alloc] initWithServer:self withID:c] autorelease];
}

#pragma mark -
#pragma mark HTTP requests
- (NSDictionary*)normalize:(NSDictionary *)doc
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
			NSArray *v = [current objectForKey:attribute];
			if(v == nil)
				v = [NSArray arrayWithObject:[value objectForKey:attribute]];
			else
				[v arrayByAddingObject: [value objectForKey:attribute]];

			[current setObject:v forKey:attribute];
		}
	}
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
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?_rev=%@", self.serverUrl, docID, docRev];
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
	return (200 == [response statusCode]);
}
- (BOOL)httpPut:(NSDictionary*)doc
{
	NSString *docID = [doc objectForKey:@"_id"];
	NSString *docRev = [doc objectForKey:@"_rev"];
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?_rev=%@", self.serverUrl, docID, docRev];
	DLog(@"HTTP DELETE Request on URL: %@", urlString);
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
    return (201 == [response statusCode] || 205 == [response statusCode]);
}
- (NSDictionary *)httpPost:(NSDictionary*)doc
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
    if (201 == [response statusCode]) {
		NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        return	[json JSONValue];
	}
	return nil;
}
@end
