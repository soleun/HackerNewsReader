//
//  SEWebViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SENewsItemTableViewController.h"
#import "SENewsItem.h"
#import "SENewsItemTopWebCell.h"

@interface SEWebViewController : UIViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) SENewsItem *newsItem;
@property (weak, nonatomic) IBOutlet UIWebView *currentNewsItemWebView;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLRequest *urlRequest;

@end
