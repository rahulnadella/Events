/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Rahul Nadella http://github.com/rahulnadella
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "GlanceController.h"
#import "Event.h"
#import "ImportantEventRow.h"
#import "MMWormhole.h"
#import "OrdinaryEventRow.h"

@interface GlanceController()

@property (nonatomic, strong) NSArray *eventsData;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *eventImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *eventTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *eventSubTitle;
@property (nonatomic, strong) MMWormhole *wormhole;

@end


@implementation GlanceController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        _eventsData = events;
        
        [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject)
        {
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
    [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject) {
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        _eventsData = events;
        [self findNextClosestEventByDate];
    }];
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