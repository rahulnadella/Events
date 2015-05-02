//
//  EventCellTableViewCell.h
//  Events
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *eventTitle;
@property (nonatomic, weak) IBOutlet UILabel *eventSubTitle;
@property (nonatomic, weak) IBOutlet UIImageView *eventImage;

@end
