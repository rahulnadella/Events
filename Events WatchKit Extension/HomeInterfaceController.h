//
//  InterfaceController.h
//  Events WatchKit Extension
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface HomeInterfaceController : WKInterfaceController

@property (nonatomic, strong) IBOutlet WKInterfaceTable *tableView;

@end
