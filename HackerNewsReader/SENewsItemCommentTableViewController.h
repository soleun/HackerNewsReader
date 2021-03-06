//
//  SENewsItemTableCommentViewController.h
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
#import "SENewsItemTopTextCell.h"
#import "SENewsItemCommentCell.h"

@interface SENewsItemCommentTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SENewsItem *newsItem;
@property (nonatomic, strong) NSMutableArray *comments;

- (IBAction)showShareSheet:(id)sender;

@end
