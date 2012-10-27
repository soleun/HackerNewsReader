//
//  SENewsItemTopWebCell.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/17/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENewsItem.h"
#import "SEWebViewController.h"

@interface SENewsItemTopWebCell : UITableViewCell <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) SENewsItem *newsItem;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (void)loadWebView;

@end
