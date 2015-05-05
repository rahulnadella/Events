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
#import "MMWormhole.h"

@interface AddEventViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateLabel;
@property (nonatomic, strong) MMWormhole *wormhole;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (nonatomic, strong) NSString *imageDestinationName;
@property (nonatomic, strong) NSString *imageFileName;

@end

@implementation AddEventViewController

# pragma mark - Memory Allocation

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.eventImage.image = nil;
    self.eventImage = nil;
}

# pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.titleLabel becomeFirstResponder];
    [self.dateLabel becomeFirstResponder];
}

# pragma mark - Save Button

- (IBAction)save:(UIBarButtonItem *)sender
{
    Event *event = [[Event alloc] init];
    [event setEventTitle:self.titleLabel.text];
    [event setEventTime:self.dateLabel.text];
    [event setEventImageName:self.imageFileName];
    
    [globalEvents addObject:event];
    
    NSUserDefaults *globalDefaults = [NSUserDefaults standardUserDefaults];
    NSData *globalEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:globalEvents];
    [globalDefaults setObject:globalEncodedObject forKey:GLOBAL_EVENT_LIST];
    [globalDefaults synchronize];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:APPLICATION_GROUP_IDENTIFIER optionalDirectory:OPTIONAL_DIRECTORY];
    
    [self.wormhole passMessageObject:globalEvents identifier:GLOBAL_EVENTS];
    [self.wormhole passMessageObject:self.eventImage identifier:self.imageFileName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectImage:(id)sender
{
    if (self.titleLabel.text)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.eventImage.image = image;
    self.imageFileName = [self.titleLabel.text.lowercaseString stringByAppendingString:IMAGE_EXTENSION];
    
    // Dismiss the camera
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
