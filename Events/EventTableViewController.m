//
//  EventTableViewController.m
//  Events
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "EventTableViewController.h"
#import "AddEventViewController.h"
#import "Event.h"
#import "EventTableViewCell.h"
#import "MMWormhole.h"

@interface EventTableViewController ()

@property (nonatomic, strong) MMWormhole *wormhole;

@end

@implementation EventTableViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Events"];
    
    [self synchronizeEventList];
    
    [self listenToEvents];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self listenToEvents];
    
    [self.tableView reloadData];
}

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
    
    Event *event = globalEvents[indexPath.row];
    eventCell.eventTitle.text = event.eventTitle;
    eventCell.eventSubTitle.text = event.eventTime;
    eventCell.eventImage.image = [UIImage imageNamed:event.eventImageName];
    
    /* Change the selection style color of the CategoryCell */
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(76.0/255.0) green:(161.0/255.0) blue:(255.0/255.0) alpha:1.0];
    bgColorView.layer.masksToBounds = YES;
    eventCell.selectedBackgroundView = bgColorView;
    
    return eventCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ADD_EVENT_IDENTIFIER])
    {
        if ([segue.destinationViewController isKindOfClass:[AddEventViewController class]])
        {
            AddEventViewController *emvc = segue.destinationViewController;
            [emvc setTitle:ADD_EVENT_IDENTIFIER];
        }
    }
}

- (void)synchronizeEventList
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:GLOBAL_EVENT_LIST];
    globalEvents = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    if (!globalEvents)
    {
        globalEvents = [[Event eventsList] mutableCopy];
        NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:globalEvents];
        [userDefaults setObject:myEncodedObject forKey:GLOBAL_EVENT_LIST];
        [userDefaults synchronize];
    }
}

@end
