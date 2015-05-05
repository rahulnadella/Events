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

#import "EventDetailsInterfaceController.h"
#import "Event.h"
#import "ImportantEventRow.h"
#import "MMWormhole.h"

@interface EventDetailsInterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *subTitle;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *eventImage;
@property (nonatomic, strong) MMWormhole *wormhole;

@end

@implementation EventDetailsInterfaceController

# pragma mark - AwakeWithContext

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    /* Convert the Context to an Array */
    NSMutableArray *attachedContext = (NSMutableArray *)context;
    /* Obtain the first object (Event) from the Array */
    Event *event = [attachedContext objectAtIndex:0];
    /* Instantiate the APP_GROUP */
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER
                                                         optionalDirectory:OPTIONAL_DIRECTORY];
    
    if (event.eventImageName)
    {
        [self.titleLabel setText:event.eventTitle];
        [self.subTitle setText:event.eventTime];
        
        /* Set the appropriate image based on the APP_GROUP */
        if (event.eventImageName)
        {
            /* Retrieve the Image in the APP_GROUP */
            UIImageView *eventImage = [self.wormhole messageWithIdentifier:event.eventImageName];
            /* Decipher if the Image is in the APP_GROUP if so set it otherwise create an new Image */
            eventImage ? [self.eventImage setImage:eventImage.image] : [self.eventImage setImage:[UIImage imageNamed:event.eventImageName]];
        }
    }
    else
    {
        [self.titleLabel setText:event.eventTitle];
        [self.subTitle setText:event.eventTime];
    }
}

# pragma mark - Activate

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

# pragma mark - Deactivate

- (void)didDeactivate
{
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    self.eventImage = nil;
}

@end