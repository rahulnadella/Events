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

#import "AddEventViewController.h"
#import "Event.h"

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateLabel;

@end

@implementation AddEventViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.titleLabel becomeFirstResponder];
    [self.dateLabel becomeFirstResponder];
}

- (IBAction)save:(UIBarButtonItem *)sender
{
    Event *event = [[Event alloc] init];
    [event setEventTitle:self.titleLabel.text];
    [event setEventTime:self.dateLabel.text];
    
    [globalEvents addObject:event];
    
    NSUserDefaults *globalDefaults = [NSUserDefaults standardUserDefaults];
    NSData *globalEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:globalEvents];
    [globalDefaults setObject:globalEncodedObject forKey:@"GlobalEventList"];
    [globalDefaults synchronize];
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.openSource"];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:globalEvents];
    [userDefaults setObject:myEncodedObject forKey:@"EventList"];
    [userDefaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
