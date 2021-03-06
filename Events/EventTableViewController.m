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

#import "EventTableViewController.h"
#import "AddEventViewController.h"
#import "Event.h"
#import "EventDetailsViewController.h"
#import "EventTableViewCell.h"
#import "MMWormhole.h"

@interface EventTableViewController ()

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) MMWormhole *wormhole;
@property (nonatomic, strong) UIImageView *eventImageView;

@end

@implementation EventTableViewController

# pragma mark - Properties

@synthesize event;

# pragma mark - Memory Allocation

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Initialization (Constructor)

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        globalEvents = events;
        
        [self listenToEvents];
    }
    return self;
}

# pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Events"];
    
    /* Synchronize the List of current Events */
    [self synchronizeEventList];
    
    /* Reload the TableView */
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /* Check to see if any Events have been Add or Removed */
    [self listenToEvents];
    
    /* Reload the TableView */
    [self.tableView reloadData];
}

# pragma mark - Listen to Events

- (void)listenToEvents
{
    [self.wormhole listenForMessageWithIdentifier:GLOBAL_EVENTS listener:^(id messageObject) {
        NSMutableArray *events = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
        globalEvents = events;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [globalEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    
    Event *currentEvent = globalEvents[indexPath.row];
    eventCell.eventTitle.text = currentEvent.eventTitle;
    eventCell.eventSubTitle.text = currentEvent.eventTime;
    /* Verify that Event contains an Image */
    if ([currentEvent.eventImageName containsString:IMAGE_EXTENSION])
    {
        /* Create the File Name that was added to the APP_GROUP */
        NSString *fileName = [currentEvent.eventTitle.lowercaseString stringByAppendingString:IMAGE_EXTENSION];
        /* Retrieve the UIImageView from the APP_GROUP based on the File Name */
        self.eventImageView = [self.wormhole messageWithIdentifier:fileName];
        /* Set the Image to the specific Event */
        eventCell.eventImage.image = self.eventImageView ? self.eventImageView.image : [UIImage imageNamed:currentEvent.eventImageName];
    }
    
    /* Change the selection style color of the CategoryCell */
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(76.0/255.0) green:(161.0/255.0) blue:(255.0/255.0) alpha:1.0];
    bgColorView.layer.masksToBounds = YES;
    eventCell.selectedBackgroundView = bgColorView;
    
    return eventCell;
}

# pragma mark - Table View Commit Edit Style

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /* Delete the row from the data source */
        NSMutableArray *mutableEvents = [globalEvents mutableCopy];
        [mutableEvents removeObjectAtIndex:[indexPath row]];
        globalEvents = mutableEvents;
        
        self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
        [self.wormhole passMessageObject:globalEvents identifier:GLOBAL_EVENTS];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self listenToEvents];
}

# pragma mark - Table View Move Event

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceIndex = (NSUInteger)[sourceIndexPath row];
    NSUInteger destinationIndex = (NSUInteger)[destinationIndexPath row];
    
    if (sourceIndex != destinationIndex)
    {
        NSMutableArray *mutableEvents = [globalEvents mutableCopy];
        [mutableEvents exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
    }
}

# pragma mark - Prepare Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /* Retrieve the current Event being selected by the user */
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    self.event = globalEvents[indexPath.row];
    
    if ([segue.identifier isEqualToString:ADD_EVENT_IDENTIFIER])
    {
        if ([segue.destinationViewController isKindOfClass:[AddEventViewController class]])
        {
            AddEventViewController *emvc = segue.destinationViewController;
            [emvc setTitle:ADD_EVENT_IDENTIFIER];
        }
    }
    else if ([segue.identifier isEqualToString:@"Event Details"])
    {
        if ([segue.destinationViewController isKindOfClass:[EventDetailsViewController class]])
        {
            EventDetailsViewController *edvc = segue.destinationViewController;
            [edvc setTitle:@"Event Details"];
            [edvc setCurrentEvent:self.event];
        }
    }
}

# pragma mark - Synchronize Events

- (void)synchronizeEventList
{
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
    globalEvents = [self.wormhole messageWithIdentifier:GLOBAL_EVENTS];
    
    if (!globalEvents)
    {
        globalEvents = [[Event eventsList] mutableCopy];
        [self.wormhole passMessageObject:globalEvents identifier:GLOBAL_EVENTS];
    }
}

# pragma mark - Edit Button

- (IBAction)editEvents:(id)sender
{
    if([self isEditing])
    {
        [sender setTitle:@"Edit"];
        [self setEditing:NO animated:YES];
    }
    else
    {
        [sender setTitle:@"Done"];
        [self setEditing:YES animated:YES];
    }
}

@end
