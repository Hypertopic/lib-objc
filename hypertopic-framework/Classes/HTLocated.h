//
//  HTLocated.h
//  Hypertopic
//
//  Created by ZHOU Chao on 11-1-26.
//  Copyright 2011 Nostos Technologies Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTNamed.h"

@interface HTLocated : HTNamed {

}

- (NSMutableDictionary *)getRaw;
- (BOOL)destroy;
@end