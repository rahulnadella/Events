//
//  EventTableViewController.m
//  Events
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "EventTableViewController.h"
#import "Event.h"
#import "EventTableViewCell.h"

@interface EventTableViewController ()

@property (nonatomic, strong) NSArray *eventData;

@end

@implementation EventTableViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Events"];
    
    self.eventData = [Event eventsList];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.openSource"];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.eventData];
    [userDefaults setObject:myEncodedObject forKey:@"EventList"];
    [userDefaults synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    
    Event *event = self.eventData[indexPath.row];
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


@end
