//
//  MNSAddMessageViewController.h
//  Noticeboard
//
//  Created by Max Scheiber on 11/16/12.
//  Copyright (c) 2012 Max Scheiber. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNSAddMessageViewControllerDelegate;

@interface MNSAddMessageViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *bodyInput;
@property (weak, nonatomic) id <MNSAddMessageViewControllerDelegate> delegate;

@end

@protocol MNSAddMessageViewControllerDelegate <NSObject>

- (void)mnsAddMessageViewControllerDidCancel:(MNSAddMessageViewController *)controller;

@end
