//
//  EventUtil.h
//  Events
//
//  Created by Rahul Nadella on 5/3/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventUtil : NSObject

# pragma mark - Global variables
extern NSMutableArray *globalEvents;

# pragma mark - Global Constants
extern NSString * const ADD_EVENT_IDENTIFIER;
extern NSString * const APPLICATION_GROUP_IDENTIFIER;
extern NSString * const EVENT_LIST;
extern NSString * const FILE_EXTENSION_SAVED;
extern NSString * const GLOBAL_EVENTS;
extern NSString * const GLOBAL_EVENT_LIST;
extern NSString * const IMAGE_EXTENSION;
extern NSString * const IMPORTANT_EVENT_ROW;
extern NSString * const OPTIONAL_DIRECTORY;
extern NSString * const ORDINARY_EVENT_ROW;
extern NSString * const SAVED;

@end
