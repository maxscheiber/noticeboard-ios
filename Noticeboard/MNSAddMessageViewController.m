//
//  MNSAddMessageViewController.m
//  Noticeboard
//
//  Created by Max Scheiber on 11/16/12.
//  Copyright (c) 2012 Max Scheiber. All rights reserved.
//

#import "MNSAddMessageViewController.h"

@interface MNSAddMessageViewController ()

@end

@implementation MNSAddMessageViewController
@synthesize titleInput;
@synthesize bodyInput;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(postMessage:)];
    //self.navigationItem.rightBarButtonItem = done;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(IBAction)cancel:(UIBarButtonItem *)sender
{
    [[self delegate] mnsAddMessageViewControllerDidCancel:self];
}

- (void)viewDidUnload
{
    [self setTitleInput:nil];
    [self setBodyInput:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)postMessage:(UIBarButtonItem *)sender
{
    NSString *title = self.titleInput.text;
    NSString *body = self.bodyInput.text;
    
    NSString *url = @"http://cis195-messages.herokuapp.com/messages";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *data = [NSString stringWithFormat:@"message[title]=%@&message[body]=%@", title, body];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    [[self delegate] mnsAddMessageViewControllerDidCancel:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.bodyInput) || (textField == self.titleInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
