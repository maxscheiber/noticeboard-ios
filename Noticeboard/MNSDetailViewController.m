//
//  MNSDetailViewController.m
//  Noticeboard
//
//  Created by Max Scheiber on 11/12/12.
//  Copyright (c) 2012 Max Scheiber. All rights reserved.
//

#import "MNSDetailViewController.h"

@interface MNSDetailViewController ()
- (void)configureView;
@end

@implementation MNSDetailViewController

#pragma mark - Managing the detail item
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize bodyLabel;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    NSMutableDictionary *msg = self.detailItem;
    
    if (msg != NULL) {
        self.titleLabel.text = (NSString *)[msg objectForKey:@"title"];
        self.bodyLabel.text = (NSString *)[msg objectForKey:@"body"];
        self.dateLabel.text = (NSString *)[msg objectForKey:@"created_at"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setBodyLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
