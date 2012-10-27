//
//  SENewsItemViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/16/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEFrontNavigationTopViewController.h"
#import "SENewsItem.h"
#import "SEWebViewController.h"
#import "SENewsItemTopWebCell.h"

@interface SENewsItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SENewsItem *newsItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
