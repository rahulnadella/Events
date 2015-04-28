//
//  Events.h
//  Events
//
//  Created by Rahul Nadella on 4/28/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventTime;
@property (nonatomic, strong) NSString *eventImageName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)eventsList;

@end
