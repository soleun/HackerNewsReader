//
//  SENewsItemTableViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/16/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEFrontNavigationTopViewController.h"
#import "SENewsItem.h"
#import "SENewsItemComment.h"
#import "SEWebViewController.h"
#import "SENewsItemTopWebCell.h"

@interface SENewsItemTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SENewsItem *newsItem;

@end
