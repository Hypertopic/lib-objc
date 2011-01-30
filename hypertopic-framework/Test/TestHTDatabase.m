//
//  TestHTDatabase.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HTDatabase.h"
#import "HTListener.h"

@interface Database : SenTestCase
{
	HTDatabase *database;
}

@end

@implementation Database 

- (void)setUp {
    database = [[HTDatabase alloc] initWithServerUrl : @"http://127.0.0.1:5984/test"];
}

- (void)tearDown {
    [database release];
}

- (void) testDefaultServerUrl
{
	STAssertEqualObjects(database.serverUrl, @"http://127.0.0.1:5984/test", nil);
}

- (void) testHttpMethod
{
	NSMutableDictionary *doc = [NSMutableDictionary new];
	[doc setObject:@"example" forKey:@"name"];
	NSLog(@"example document: %@", doc);
	/// Create a document
	NSDictionary *new = [database httpPost:[[doc copy] autorelease]];
	NSLog(@"new created document: %@", new);
	STAssertNotNil(new, nil);
	
	NSString *docID = [new objectForKey:@"id"];
	NSString *docRev = [new objectForKey:@"rev"];
	NSLog(@"new created document ID: %@", docID);
	
	NSString *urlString = [NSString stringWithFormat:@"%@/%@?rev=%@", database.serverUrl, docID, docRev];
	NSLog(@"Document URL: %@", docID);
	[doc setObject:@"updated" forKey:@"name"];
	[doc setObject:docID forKey:@"_id"];
	[doc setObject:docRev forKey:@"_rev"];
	NSLog(@"Document to update: %@", doc);
	
	BOOL updated = [database httpPut: doc];
	STAssertTrue(updated, nil);
	
	urlString = [NSString stringWithFormat:@"%@/%@", database.serverUrl, docID];
	NSDictionary *updatedDoc = [database httpGet:urlString];
	STAssertEqualObjects([updatedDoc objectForKey:@"name"], @"updated", nil);
	
	NSLog(@"Document to delete: %@", updatedDoc);
	STAssertTrue([database httpDelete:updatedDoc], nil);
}

- (void) testCouchDBListener
{
	STAssertTrue(!database.listener.finished, nil);
	while(!database.listener.finished){
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}
@end
