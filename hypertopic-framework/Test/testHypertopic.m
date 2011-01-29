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
	return [NSString stringWithFormat:@"%@.%u", className, arc4random()];
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
	
	STAssertTrue([corpus destroy], @"cannot destroy corpus");
	STAssertTrue([viewpoint destroy], @"cannot destroy viewpoint");
}

- (void)testCorpusMethods
{
	NSString *userID = [self getRandomName:@"c.user"];
	NSString *userID2 = [self getRandomName:@"c.user2"];
	NSString *corpusName = [self getRandomName:@"c.corpus"];
	NSString *corpusName2 = [self getRandomName:@"c.corpus2"];
	NSString *itemName = [self getRandomName:@"c.item"];
	
	HTUser *userObj = [database getUser:userID];
	HTCorpus *corpus = [userObj createCorpus:corpusName];
	STAssertNotNil(corpus, @"cannot create corpus");
	STAssertTrue([corpusName isEqual:[corpus getName]], @"created corpus name is not correct: %@", [corpus getName]);
	
	//Register another user
	STAssertTrue([corpus registerUser:userID2], @"cannot register new user");
	STAssertTrue([[corpus listUsers] count] == 2, @"should have two users: %@", [[corpus listUsers] JSONRepresentation]);
	//Unregister user
	STAssertTrue([corpus unregisterUser:userID2], @"cannot unregister new user");
	STAssertTrue([[corpus listUsers] count] == 1, @"should only have one user: %@", [[corpus listUsers] JSONRepresentation]);
	
	//Rename corpus
	[corpus rename:corpusName2];
	STAssertTrue([corpusName2 isEqual:[corpus getName]], @"corpus new name is not correct: %@", [corpus getName]);
	
	HTItem *item = [corpus createItem:itemName];
	STAssertNotNil(item, @"cannot create item within corpus");
	
	NSArray *items = [corpus getItems];
	STAssertTrue([items count] == 1, @"Items number is not correct: %@", [items JSONRepresentation]);
	
	STAssertTrue([corpus destroy], @"cannot destroy corpus");
	//STAssertTrue([item destroy], @"cannot destroy item");
}

- (void)testItemMethods
{
	NSString *userID = [self getRandomName:@"i.user"];
	NSString *corpusName = [self getRandomName:@"i.corpus"];
	NSString *itemName = [self getRandomName:@"i.item"];
	NSString *itemName2 = [self getRandomName:@"i.item2"];
	
	HTUser *userObj = [database getUser:userID];
	HTCorpus *corpus = [userObj createCorpus:corpusName];
	HTItem *item = [corpus createItem:itemName];

	// test getAttributes
	STAssertTrue([item rename:itemName2], @"cannot rename item");
	NSDictionary *attributes = [item getAttributes];
	STAssertTrue([[attributes allKeys] count] == 0, @"attribute should be nil");
	
	// test describe
	[item describe:@"attr_name" withValue:@"attr_value1"];
	[item describe:@"attr_name" withValue:@"attr_value2"];
	[item describe:@"attr_name" withValue:@"attr_value3"];
	[item describe:@"attr_name" withValue:@"attr_value3"];
	[item describe:@"attr_name2" withValue:@"attr_value"];
	
	attributes = [item getAttributes];
	STAssertTrue([[attributes objectForKey:@"attr_name"] count] == 3, @"%@", attributes);
	STAssertTrue([[attributes objectForKey:@"attr_name2"] count] == 1, @"%@", attributes);
	
	//test undescribe
	[item undescribe:@"attr_name" withValue:@"attr_value3"];
	[item undescribe:@"attr_name2" withValue:@"attr_value"];
	
	attributes = [item getAttributes];
	STAssertTrue([[attributes objectForKey:@"attr_name"] count] == 2, @"%@", attributes);
	STAssertNil([attributes objectForKey:@"attr_name2"], nil);
	
	NSString *viewName = [self getRandomName:@"i.viewpoint"];
	NSString *topicName1 = [self getRandomName:@"i.topic.1"];	
	NSString *topicName2 = [self getRandomName:@"i.topic.2"];
	NSString *topicName3 = [self getRandomName:@"i.topic.3"];
	HTViewpoint *viewpoint = [userObj createViewpoint:viewName];
	HTTopic *topic1 = [viewpoint createTopic];
	HTTopic *topic2 = [viewpoint createTopicWithName:topicName2];
	HTTopic *topic3 = [viewpoint createTopic:topic1,topic2,nil];
	[topic1 rename:topicName1];
	[topic3 rename:topicName3];
	
	// test tag
	STAssertTrue([item tag:topic1], @"cannot tag item");
	STAssertTrue([item tag:topic2], @"cannot tag item");
	STAssertTrue([item tag:topic3], @"cannot tag item");
	
	// test getTopics
	NSArray *topics = [item getTopics];
	STAssertTrue([topics count] == 3, @"topics number error");
	
	// test untag
	STAssertTrue([item untag:topic2], @"cannot untag item");
	
	topics = [item getTopics];
	STAssertTrue([topics count] == 2, @"topics number error");
	[corpus destroy];
	[viewpoint destroy];
}

- (void)testViewpointAndTopicMethods
{
	NSString *userID = [self getRandomName:@"v.user"];
	NSString *viewpointName = [self getRandomName:@"v.viewpoint"];
	NSString *topicName1 = [self getRandomName:@"v.topic.1"];	
	NSString *topicName2 = [self getRandomName:@"v.topic.2"];
	NSString *topicName3 = [self getRandomName:@"v.topic.3"];
	
	HTUser *userObj = [database getUser:userID];
	
	HTViewpoint *viewpoint = [userObj createViewpoint:viewpointName];
	HTTopic *topic1 = [viewpoint createTopic];
	HTTopic *topic2 = [viewpoint createTopicWithName:topicName2];
	HTTopic *topic3 = [viewpoint createTopic:topic1,nil];
	[topic1 rename:topicName1];
	[topic3 rename:topicName3];
	[topic1 moveTopics:topic2,nil];
	
	NSLog(@"Viewpoint: %@", [viewpoint getRaw]);
	
	NSArray *uppers = [viewpoint getUpperTopics];
	STAssertTrue([uppers count] == 1, @"uppertopics number error %@", uppers); 
	
	NSArray *topics = [viewpoint getTopics];
	STAssertTrue([topics count] == 3, @"getTopics number error %@", topics); 
	
	HTTopic *topic4 = [viewpoint createTopic];
	[topic4 linkTopics:topic1,nil];
	NSLog(@"Viewpoint: %@", [viewpoint getView]);
	
	NSArray *broaders = [topic1 getBroader];
	NSArray *narrowers = [topic1 getNarrower];
	STAssertTrue([broaders count] == 1, @"getBroader number error %@", broaders);
	STAssertTrue([narrowers count] == 2, @"getBroader number error %@", narrowers);
	
	//TODO getItems
	HTCorpus *corpus = [userObj createCorpus:@"corpus"];
	NSString *itemName = [self getRandomName:@"i.item"];
	NSString *itemName2 = [self getRandomName:@"i.item2"];
	HTItem *item = [corpus createItem:itemName];
	HTItem *item2 = [corpus createItem:itemName2];
	
	[item tag:topic3];
	[item2 tag:topic1];
	[item tag:topic4];
	NSArray *items = [topic1 getItems];
	STAssertTrue([items count] == 2, @"topic getItems number error %i", [items count]);
	
	items = [viewpoint getItems];
	STAssertTrue([items count] == 3, @"viewpoint getItems number error %i", [items count]);
	
	[topic3 unlink];
	narrowers = [topic1 getNarrower];
	STAssertTrue([narrowers count] == 1, @"getBroader number error %@", narrowers);
	
	STAssertTrue([topic1 destroy], @"cannot destroy topic");
	
	uppers = [viewpoint getUpperTopics];
	STAssertTrue([uppers count] == 3, @"uppertopics number error %@", uppers); 
	
	NSArray *users = [viewpoint listUsers];
	STAssertTrue([users count] == 1, @"users number error %@", users); 
	
	STAssertTrue([viewpoint rename:@"new_name"], @"cannot rename viewpoint");
	[viewpoint destroy];
	[corpus destroy];
}
@end
