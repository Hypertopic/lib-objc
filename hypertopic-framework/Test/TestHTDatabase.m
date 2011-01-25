//
//  TestHTDatabase.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-25.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HTDatabase.h"

@interface Database : SenTestCase
{
	HTDatabase *database;
}

@end

@implementation Database 

- (void)setUp {
    database = [HTDatabase new];
    srandom(time(NULL));
}

- (void)tearDown {
    [database release];
}

- (void) testDefaultServerUrl
{
	STAssertEqualObjects(database.serverUrl, @"http://localhost:5984", nil);
}
@end
