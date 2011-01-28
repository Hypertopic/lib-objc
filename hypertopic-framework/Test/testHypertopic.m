//
//  testHypertopic.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-27.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "HTDatabase.h"
#import "HTIdentified.h"
#import "HTNamed.h"
#import "HTLocated.h"
#import "HTRegistered.h"
#import "HTUser.h"
#import "HTCorpus.h"
#import "HTItem.h"
#import "HTViewpoint.h"
#import "HTTopic.h"
#import "JSON.h"

@interface testHypertopic : SenTestCase
{
	HTDatabase *database;
}

- (NSString *)getRandomName:(NSString *)className;
@end

@implementation testHypertopic

- (void)setUp {
    database = [[HTDatabase alloc] initWithServerUrl : @"http://127.0.0.1:5984/test/_design/argos/_rewrite"];
}

- (void)tearDown {
    [database release];
}

- (NSString *)getRandomName:(NSString *)className
{
	srandom(time(0));
	return [NSString stringWithFormat:@"%@.%u", className, random()];
}

- (void)testUserMethods
{
	NSString *userID = [self getRandomName:@"u.user"];
	NSString *corpusName = [self getRandomName:@"u.corpus"];
	NSString *viewpointName = [self getRandomName:@"u.viewpoint"];
	HTUser *userObj = [database getUser:userID];
	///Create Corpus
	HTCorpus *corpus = [userObj createCorpus:corpusName];
	STAssertNotNil(corpus, @"cannot create corpus");
	STAssertTrue([corpusName isEqual:[corpus getName]], @"created corpus name is not correct: %@", [corpus getName]);
	
	
	///Create viewpoint
	HTViewpoint *viewpoint = [userObj createViewpoint:viewpointName];
	STAssertNotNil(viewpoint, @"cannot create viewpoint");
	STAssertTrue([viewpointName isEqual:[viewpoint getName]], @"created viewpoint name is not correct: %@", [viewpoint getName]);
	
	//List corpora
	NSArray *corpora = [userObj listCorpora];
	STAssertNotNil(corpora, nil);
	STAssertTrue([corpora count] == 1, @"%@", [corpora JSONRepresentation]);	
	//List viewpoint
	NSArray *viewpoints = [userObj listViewpoints];
	STAssertNotNil(viewpoints, nil);
	STAssertTrue([viewpoints count] == 1, @"%@", [viewpoints JSONRepresentation]);
}

- (void)testCorpusMethods
{
	NSString *userID = [self getRandomName:@"c.user"];
	NSString *userID2 = [self getRandomName:@"c.user2"];
	NSString *corpusName = [self getRandomName:@"c.corpus"];
	
	HTUser *userObj = [database getUser:userID];
	HTCorpus *corpus = [userObj createCorpus:corpusName];
	STAssertNotNil(corpus, @"cannot create corpus");
	STAssertTrue([corpusName isEqual:[corpus getName]], @"created corpus name is not correct: %@", [corpus getName]);
	
	//Register another user
	STAssertTrue([corpus registerUser:userID2], @"cannot register new user");
	
	STAssertTrue([[corpus listUsers] count] == 2, @"%@", [[corpus listUsers] JSONRepresentation]);
}

@end
