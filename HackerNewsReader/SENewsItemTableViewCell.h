//
//  SENewsItemTableViewCell.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/15/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENewsItem.h"
#import "SEWebViewController.h"
#import "SEFrontNavigationTopViewController.h"
#import "SEFrontTableViewController.h"
#import "SEAppDelegate.h"

@interface SENewsItemTableViewCell : UITableViewCell

@property (nonatomic, strong) SENewsItem *newsItem;
@property (nonatomic, strong) NSString *HTMLCache;
@property (nonatomic, strong) NSMutableData *receivedData;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeAuthorLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withNewsItem:(SENewsItem *)currentItem;
- (void)updateCell;

@end
