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
#import "OrdinaryEventRow.h"

@interface HomeInterfaceController()

@property (nonatomic, strong) NSArray *eventsData;

@end


@implementation HomeInterfaceController

@synthesize tableView;

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
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)setupTable
{
    //    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.openSource"];
    //    NSData *encodedObject = [userDefaults objectForKey:@"EventList"];
    //    _eventsData = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    _eventsData = [Event eventsList];
    
    NSMutableArray *rowTypesList = [NSMutableArray array];
    
    for (Event *event in _eventsData)
    {
        if (event.eventImageName.length > 0)
        {
            [rowTypesList addObject:@"ImportantEventRow"];
        }
        else
        {
            [rowTypesList addObject:@"OrdinaryEventRow"];
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



