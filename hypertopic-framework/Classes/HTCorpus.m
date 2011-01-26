//
//  HTCorpus.m
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import "HTCorpus.h"
#import "HTDatabase.h"
#import "JSON.h"

@implementation HTCorpus

@synthesize database;
@synthesize corpusID;

- (id) initWithServer:(HTDatabase *)d withCorpusID:(NSString *)c
{
	if( self = [super init])
	{
		database = [d retain];
		corpusID = [c copy];
	}
	return self;
}

- (void)dealloc
{
    [database release];
    [corpusID release];
    [super dealloc];
}

@end
