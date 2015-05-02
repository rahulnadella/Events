//
//  Appearance.m
//  Events
//
//  Created by Rahul Nadella on 5/2/15.
//  Copyright (c) 2015 Rahul Nadella. All rights reserved.
//

#import "Appearance.h"

@implementation Appearance

+ (void)customizeNavigationAppearance
{
    /* Create resizable images */
    UIImage *gradientImage44 = [[UIImage imageNamed:@"surf_gradient_textured_44"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                       forBarMetrics:UIBarMetricsDefault];
    
    /* Create the desired color */
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    /* Create the Shadow Color and Offset */
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [shadow setShadowOffset: CGSizeMake(0.0f, -1.0f)];
    /* Create the desired FONT for the Navigation Bar */
    UIFont *font = [UIFont fontWithName:@"Cochin-BoldItalic" size:20.0];
    /* Map of attributes to define look of Navigation Bar */
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:color forKey:NSForegroundColorAttributeName];
    [attributes setObject:shadow forKey:NSShadowAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    
    /* Customize the title text for *all* UINavigationBars */
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}

+ (void)customizeNavigationBar
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
