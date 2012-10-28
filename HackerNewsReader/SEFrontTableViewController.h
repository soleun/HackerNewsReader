//
//  SEFrontTableViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "SENewsItemTableViewController.h"
#import "SENewsItemTableViewCell.h"
#import "SEMenuViewController.h"

@interface SEFrontTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *frontTableView;
@property (nonatomic, strong) NSDictionary *menuItem;

- (IBAction)showMenu:(id)sender;

@end
