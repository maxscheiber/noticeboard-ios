//
//  MNSMasterViewController.m
//  Noticeboard
//
//  Created by Max Scheiber on 11/12/12.
//  Copyright (c) 2012 Max Scheiber. All rights reserved.
//

#import "MNSMasterViewController.h"
#import "MNSDetailViewController.h"
#import "MNSAppDelegate.h"
#import "MNSAddMessageViewController.h"

@interface MNSMasterViewController () <MNSAddMessageViewControllerDelegate> {
    NSMutableArray *_objects;
    NSMutableData *_data;
}
@end

@implementation MNSMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getMessages];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)mnsAddMessageViewControllerDidCancel:(MNSAddMessageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self refresh:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *msg = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = (NSString *) [msg objectForKey:@"title"];
    cell.detailTextLabel.text = (NSString* ) [msg objectForKey:@"created_at"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSURLConnection *)getMessages
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://cis195-messages.herokuapp.com/messages"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    return connection;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDate *createdAt;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [outputFormatter setDateStyle:NSDateFormatterMediumStyle];
    [outputFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDictionary *messages = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    NSDictionary *msg;
    NSMutableDictionary *formattedMsg;
    
    if (_objects == NULL) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    for (msg in messages) {
        NSString *dateString = [msg valueForKey:@"created_at"];
        formattedMsg = [NSMutableDictionary dictionaryWithDictionary: msg];
        createdAt = [inputFormatter dateFromString:dateString];
        [formattedMsg setValue:[outputFormatter stringFromDate: createdAt] forKey:@"created_at"];
        [_objects addObject: formattedMsg];
    }
    
    [connection cancel];
    [self.tableView reloadData];
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    _data = nil;
    _objects = nil;
    [self getMessages];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSMutableDictionary *object = [_objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    
    else if ([[segue identifier] isEqualToString:@"addMessage"]) {
        MNSAddMessageViewController *addController = (MNSAddMessageViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        addController.delegate = self;
    }
}

@end
