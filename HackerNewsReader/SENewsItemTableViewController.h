//
//  SENewsItemTableViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "SENewsItemCommentTableViewController.h"
#import "SENewsItemTableViewCell.h"
#import "SEMenuViewController.h"

@interface SENewsItemTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *frontTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (nonatomic, strong) NSDictionary *menuItem;

- (IBAction)showMenu:(id)sender;

@end
