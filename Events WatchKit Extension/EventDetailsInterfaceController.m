//
//  EventDetailsInterfaceController.m
//  Events
//
//  Created by Rahul Nadella on 5/4/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "EventDetailsInterfaceController.h"


@interface EventDetailsInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *subTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *eventImage;

@end


@implementation EventDetailsInterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    Event *event = (Event *)context;

    if (event.eventImageName)
    {
        [self.titleLabel setText:event.eventTitle];
        [self.subTitle setText:event.eventTime];
        [self.eventImage setImage:[UIImage imageNamed:event.eventImageName]];
    }
    else
    {
        [self.titleLabel setText:event.eventTitle];
        [self.subTitle setText:event.eventTime];
    }
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

@end