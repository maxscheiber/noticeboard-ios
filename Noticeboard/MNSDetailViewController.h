//
//  MNSDetailViewController.h
//  Noticeboard
//
//  Created by Max Scheiber on 11/12/12.
//  Copyright (c) 2012 Max Scheiber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNSDetailViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyLabel;

@end
