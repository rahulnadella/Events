//
//  GlanceController.m
//  Events WatchKit Extension
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "GlanceController.h"
#import "Event.h"
#import "ImportantEventRow.h"
#import "OrdinaryEventRow.h"

@interface GlanceController()

@property (nonatomic, strong) NSArray *eventsData;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *eventImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *eventTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *eventSubTitle;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self findNextClosestEventByDate];
}

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)findNextClosestEventByDate
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.openSource"];
    NSData *encodedObject = [userDefaults objectForKey:@"EventList"];
    _eventsData = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    NSInteger closetDay = 0;
    Event *closestEvent;
    for (Event *event in _eventsData)
    {
        NSString *eventTime = event.eventTime;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        /*
         This is imporant - we set our input date format to match our input string
         if format doesn't match you'll get nil from your string, so be careful
         */
        [dateFormatter setDateFormat:@"MM-dd-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:eventTime];
        
        NSInteger tempDateInterval = [dateFromString timeIntervalSinceNow];
        /* To work with positive and negative time difference */
        if( tempDateInterval > 0 )
        {
            if (!closetDay)
            {
                closetDay = tempDateInterval;
                closestEvent = event;
            }
            else if (tempDateInterval < closetDay)
            {
                closetDay = tempDateInterval;
                closestEvent = event;
            }
        }
    }
    
    [self.eventImage setImage:[UIImage imageNamed:closestEvent.eventImageName]];
    [self.eventTitle setText:closestEvent.eventTitle];
    [self.eventSubTitle setText:closestEvent.eventTime];
}

@end