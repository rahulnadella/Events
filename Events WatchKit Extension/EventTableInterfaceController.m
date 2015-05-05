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

#import "EventTableInterfaceController.h"
#import "Event.h"
#import "EventDetailsInterfaceController.h"
#import "ImportantEventRow.h"
#import "MMWormhole.h"
#import "OrdinaryEventRow.h"

@interface EventTableInterfaceController()

@property (nonatomic, strong) NSArray *eventsData;
@property (nonatomic, strong) MMWormhole *wormhole;
@property (nonatomic, strong) UIImageView *eventImage;
@property (nonatomic, strong) NSString *eventImageName;

@end

@implementation EventTableInterfaceController

# pragma mark - Properties

@synthesize tableView;

# pragma mark - Initialization (Constructor)

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        _eventsData = events;
        
        self.eventImage = [self.wormhole messageWithIdentifier:@"EventImage"];
        self.eventImageName = [self.wormhole messageWithIdentifier:@"EventImageName"];
        WKInterfaceDevice *device = [WKInterfaceDevice currentDevice];
        [device addCachedImage:self.eventImage.image name:self.eventImageName];
        
        [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject) {
            NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
            _eventsData = events;
        }];
    }
    return self;
}

# pragma mark - AwakeWithContext

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self setupTable];
}

# pragma mark - Activate

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject) {
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        _eventsData = events;
        
        self.eventImage = [self.wormhole messageWithIdentifier:@"EventImage"];
        self.eventImageName = [self.wormhole messageWithIdentifier:@"EventImageName"];
        WKInterfaceDevice *device = [WKInterfaceDevice currentDevice];
        [device addCachedImage:self.eventImage.image name:self.eventImageName];
        
        [self setupTable];
    }];
}

# pragma mark - Deactivate

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [self.wormhole stopListeningForMessageWithIdentifier:GLOBAL_EVENTS];
}

# pragma mark - Initialize TableView

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
            [importantRow.titleLabel setText:event.eventTitle];
            [importantRow.timeLabel setText:event.eventTime];
            [importantRow.eventImage setImage:self.eventImage.image];
        }
        else
        {
            OrdinaryEventRow *ordinaryRow = (OrdinaryEventRow *) row;
            [ordinaryRow.titleLabel setText:event.eventTitle];
            [ordinaryRow.timeLabel setText:event.eventTime];
        }
    }
}

# pragma mark - Prepare Segue

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex
{
    /* Retrieve the current Event being selected by the user */
    NSObject *row = [self.tableView rowControllerAtIndex:rowIndex];
    Event *event = _eventsData[rowIndex];
    
    if ([row isKindOfClass:[ImportantEventRow class]])
    {
        ImportantEventRow *importantRow = (ImportantEventRow *) row;
        [importantRow.eventImage setImage:self.eventImage.image];
        [importantRow.titleLabel setText:event.eventTitle];
        [importantRow.timeLabel setText:event.eventTime];
        
        if ([segueIdentifier isEqualToString:@"Event Details Important"])
        {
            return event;
        }
        
    }
    else
    {
        OrdinaryEventRow *ordinaryRow = (OrdinaryEventRow *) row;
        [ordinaryRow.titleLabel setText:event.eventTitle];
        [ordinaryRow.timeLabel setText:event.eventTime];
        
        if ([segueIdentifier isEqualToString:@"Event Details Ordinary"])
        {
            return event;
        }
    }
    
    return nil;
}

@end



