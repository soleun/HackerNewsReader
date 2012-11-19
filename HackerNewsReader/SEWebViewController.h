//
//  SEWebViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "SENewsItemCommentTableViewController.h"
#import "SENewsItem.h"
#import "SENewsItemTopWebCell.h"

@interface SEWebViewController : GAITrackedViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) SENewsItem *newsItem;
@property (weak, nonatomic) IBOutlet UIWebView *currentNewsItemWebView;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

- (IBAction)refreshWebView:(id)sender;

@end
