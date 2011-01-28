//
//  HTRegistered.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTLocated.h"

@interface HTRegistered : HTLocated {

}

- (BOOL)registerUser:(NSString *)userID;
- (BOOL)unRegisterUser:(NSString *)userID;

@end
