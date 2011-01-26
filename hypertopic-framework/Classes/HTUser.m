//
//  HTUser.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTDatabase.h"
#import "HTUser.h"
#import "JSON.h"

@implementation HTUser

@synthesize database;
@synthesize userId;

- (id) initWithServer:(HTDatabase *)d user:(NSString *)u
{
	if( self = [super init])
	{
		database = [d retain];
		userId = [u copy];
	}
	return self;
}

- (void)dealloc
{
    [database release];
    [userId release];
    [super dealloc];
}

- (NSDictionary*)getView
{
	NSString *urlString = [NSString stringWithFormat:@"%@/user/%@", database.serverUrl, userId];
	NLog(urlString);
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
        NSDictionary *doc =	[json JSONValue];
		return [[database normalize:doc] objectForKey:userId];
    }else{
        DLog(@"HTTP GET FAILED:  %@",  urlString );
        DLog(@"STATUS CODE %i",  [response statusCode]);
    }
    
    return nil;
}

- (NSDictionary*)listCorpora
{
	NSDictionary *doc = [self getView];
	return [doc objectForKey:@"corpus"];
}

- (NSDictionary*)listViewpoints
{
	NSDictionary *doc = [self getView];
	return [doc objectForKey:@"viewpoint"];
}
@end
