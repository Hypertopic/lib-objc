//
//  HTListen.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-29.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTListener.h"

@implementation HTListener

@synthesize finished;

- (id)initWithServer:(HTDatabase *)db
{
	if( self = [super init])
	{
		database = [db retain];
		changesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", database.serverUrl, @"_changes?feed=continuous"]];
		finished = FALSE;
		started = FALSE;
		[self start];
	}
	return self;
}
- (void)dealloc
{
    [database release];
    [super dealloc];
}
- (void)start {
    NSURLRequest *request = [NSURLRequest requestWithURL:changesUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!started)
		started = TRUE;
	else
		[database purgeCache:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    finished = TRUE;
    [connection release];
	//TODO respawn this process
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    finished = TRUE;
    [connection release];
}
@end
