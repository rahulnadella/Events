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

#import <Foundation/Foundation.h>

/*
 The Event object provides the basic data structure to hold the data for a specific Event.
 
 @version 1.0
 */
@interface Event : NSObject

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventTime;
@property (nonatomic, strong) NSString *eventImageName;

/* 
 The initWithDictionary initializes the specific Event objects 
 (ImportantEventRow or OrdinaryEventRow).
 
 @version 1.0
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/*
 The eventList method initializes a list of Event objects.
 
 @version 1.0
 */
+ (NSArray *)eventsList;

@end
