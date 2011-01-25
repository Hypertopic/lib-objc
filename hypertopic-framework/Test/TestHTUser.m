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

- (void) testDefaultServerUrl
{
	STAssertEqualObjects(database.serverUrl, @"http://127.0.0.1:5984/argos/_design/argos/_rewrite", nil);
}

- (void) testGetView
{
	NSDictionary *doc = [user getView];
	STAssertTrue([doc objectForKey:@"total_rows"] > 0, nil);
}
@end
