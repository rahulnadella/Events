//
//  EventDetailsViewController.m
//  Events
//
//  Created by Rahul Nadella on 5/4/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@end

@implementation EventDetailsViewController

@synthesize currentEvent;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleTextField.text = self.currentEvent.eventTitle;
    self.timeTextField.text = self.currentEvent.eventTime;
    self.eventImageView.image = [UIImage imageNamed:self.currentEvent.eventImageName];
}

@end
