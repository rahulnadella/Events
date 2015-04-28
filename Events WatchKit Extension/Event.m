//
//  Events.m
//  Events
//
//  Created by Rahul Nadella on 4/28/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize eventTitle;
@synthesize eventTime;
@synthesize eventImageName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        eventTitle = dictionary[@"eventTitle"];
        eventTime = dictionary[@"eventTime"];
        eventImageName = dictionary[@"eventImageName"];
    }
    
    return self;
}

+ (NSArray *)eventsList
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:dataPath];
    
    for (NSDictionary *e in data)
    {
        Event *event = [[Event alloc] initWithDictionary:e];
        [array addObject:event];
    }
    
    return array;
}

@end
