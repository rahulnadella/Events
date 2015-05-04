//
//  InterfaceController.m
//  Events WatchKit Extension
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "HomeInterfaceController.h"
#import "Event.h"
#import "ImportantEventRow.h"
#import "MMWormhole.h"
#import "OrdinaryEventRow.h"

@interface HomeInterfaceController()

@property (nonatomic, strong) NSArray *eventsData;
@property (nonatomic, strong) MMWormhole *wormhole;
@end


@implementation HomeInterfaceController

@synthesize tableView;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        _eventsData = events;
        
        [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject) {
            NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
            _eventsData = events;
        }];
    }
    return self;
}

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self setupTable];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject) {
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        _eventsData = events;
        [self setupTable];
    }];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [self.wormhole stopListeningForMessageWithIdentifier:GLOBAL_EVENTS];
}

- (void)setupTable
{
    NSMutableArray *rowTypesList = [NSMutableArray array];
    
    for (Event *event in _eventsData)
    {
        if (event.eventImageName.length > 0)
        {
            [rowTypesList addObject:IMPORTANT_EVENT_ROW];
        }
        else
        {
            [rowTypesList addObject:ORDINARY_EVENT_ROW];
        }
    }
    
    [tableView setRowTypes:rowTypesList];
    
    for (NSInteger i = 0; i < tableView.numberOfRows; i++)
    {
        NSObject *row = [tableView rowControllerAtIndex:i];
        Event *event = _eventsData[i];
        
        if ([row isKindOfClass:[ImportantEventRow class]])
        {
            ImportantEventRow *importantRow = (ImportantEventRow *) row;
            [importantRow.eventImage setImage:[UIImage imageNamed:event.eventImageName]];
            [importantRow.titleLabel setText:event.eventTitle];
            [importantRow.timeLabel setText:event.eventTime];
        }
        else
        {
            OrdinaryEventRow *ordinaryRow = (OrdinaryEventRow *) row;
            [ordinaryRow.titleLabel setText:event.eventTitle];
            [ordinaryRow.timeLabel setText:event.eventTime];
        }
    }
}


@end



