//
//  OrdinaryEventRow.h
//  Events
//
//  Created by Rahul Nadella on 4/28/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface OrdinaryEventRow : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *timeLabel;

@end
