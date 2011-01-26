//
//  TestHTUser.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HTDatabase.h"
#import "HTUser.h"
#import "JSON.h"


@interface User : SenTestCase
{
	HTDatabase *database;
	HTUser *user;
}

@end

@implementation User 

- (void)setUp {
    database = [[HTDatabase alloc] initWithServerUrl : @"http://127.0.0.1:5984/argos/_design/argos/_rewrite"];
	user = [database getUser:@"chao.zhou"];
    srandom(time(NULL));
}

- (void)tearDown {
    [database release];
}

- (void) testGetView
{
	NSDictionary *doc = [user getView];
	STAssertNotNil(doc, nil);
	STAssertTrue([[doc objectForKey:@"viewpoint"] count]> 0, nil);
}

- (void) testListViewpoints
{
	NSDictionary *viewpoints = [user listViewpoints];
	STAssertNotNil(viewpoints, nil);
	STAssertTrue([viewpoints count]> 0, nil);
}

- (void) testListCorpora
{
	NSDictionary *corpora = [user listCorpora];
	STAssertNil(corpora, nil);
}

-(void) testGetViewUrl
{
	NSString *url = [user getViewUrl];
	STAssertTrue([url isEqual:@"http://127.0.0.1:5984/argos/_design/argos/_rewrite/user/chao.zhou"], nil);
}

-(void) testCreateViewpoint
{
	STAssertTrue([user createViewpoint:@"test-viewpoint"], nil);
}
@end
