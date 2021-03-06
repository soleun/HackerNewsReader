//
//  SENewsItemCommentCell.h
//  HackerNewsReader
//
//  Created by Sol Eun on 11/6/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENewsItemCommentTableViewController.h"
#import "SENewsItemComment.h"

@interface SENewsItemCommentCell : UITableViewCell <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *commentView;
@property (strong, nonatomic) IBOutlet NSMutableArray *newsItemCommentsArray;
@property (strong, nonatomic) IBOutlet UILabel *timeAuthorLabel;
@property (strong, nonatomic) IBOutlet UIView *replyIconView;
@property (nonatomic) NSInteger newsItemCommentIndex;

- (void)loadContent:(NSMutableArray *)comments atIndex:(NSInteger)i;

@end
