//
//  Appearance.h
//  Events
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Appearance : NSObject

+ (void)customizeNavigationAppearance;

+ (void)customizeNavigationBar;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
