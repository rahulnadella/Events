//
//  ImportantEventRow.h
//  Events
//
//  Created by Rahul Nadella on 4/28/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface ImportantEventRow : NSObject

@property (nonatomic, strong) IBOutlet WKInterfaceLabel *titleLabel;
@property (nonatomic, strong) IBOutlet WKInterfaceLabel *timerLabel;
@property (nonatomic, strong) IBOutlet WKInterfaceImage *eventImage;

@end
