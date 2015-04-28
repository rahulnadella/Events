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

#import "Event.h"

@implementation Event

@synthesize eventTitle;
@synthesize eventTime;
@synthesize eventImageName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        eventTitle = dictionary[@"eventTitle"];
        eventTime = dictionary[@"eventTime"];
        eventImageName = dictionary[@"eventImageName"];
    }
    
    return self;
}

+ (NSArray *)eventsList
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:dataPath];
    
    for (NSDictionary *e in data)
    {
        Event *event = [[Event alloc] initWithDictionary:e];
        [array addObject:event];
    }
    
    return array;
}

@end
