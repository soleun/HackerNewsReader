//
//  SENewsItemTopTextCell.h
//  HackerNewsReader
//
//  Created by Sol Eun on 11/2/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENewsItem.h"

@interface SENewsItemTopTextCell : UITableViewCell <UIWebViewDelegate>

@property (nonatomic, strong) SENewsItem *newsItem;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeAuthorLabel;

@property (strong, nonatomic) IBOutlet UIWebView *textView;
@property (strong, nonatomic) IBOutlet UIView *pointCommentView;
@property (strong, nonatomic) IBOutlet UIView *dummyView;
@property (strong, nonatomic) IBOutlet UILabel *pointLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIView *pointIconView;
@property (strong, nonatomic) IBOutlet UIView *commentIconView;

- (void)loadContent:(SENewsItem *)n;

@end
