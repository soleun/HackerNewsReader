//
//  SENewsItemTopWebCell.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/17/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItemTopWebCell.h"

@implementation SENewsItemTopWebCell

@synthesize webView, newsItem, receivedData, urlRequest;
@synthesize timeAuthorLabel = _timeAuthorLabel;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize titleTextView = _titleTextView;
@synthesize pointCommentView;
@synthesize dummyView;
@synthesize pointLabel;
@synthesize commentLabel;

static CGFloat viewWidth = 80;
static CGFloat viewHeight = 20;
static CGFloat hGap = 5;
static CGFloat vGap = 2;

- (void)loadCacheData:(NSData *)data
{
    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
}

- (void)loadWebView
{
    webView.scalesPageToFit = true;
    webView.userInteractionEnabled = false;
    webView.multipleTouchEnabled = false;
    
    NSLog(@"NSURLCache ::::: %i", [[NSURLCache sharedURLCache] currentMemoryUsage]);
    
    //URLRequest
    NSURL *url = [[NSURL alloc] initWithString:[newsItem url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest = request;
    
    NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    if (response) {
        [self loadCacheData:[response data]];
        [[self loadingIndicator] setAlpha:0.0f];
    } else {
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            receivedData = [NSMutableData data];
        } else {
            // Inform the user that the connection failed.
        }
    }

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [[self timeAuthorLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
    [[self timeAuthorLabel] setTextColor:[UIColor whiteColor]];
    [[self timeAuthorLabel] setBounds:CGRectMake(0, 0, 290, 21)];
    [[self timeAuthorLabel] setText:[[NSString alloc] initWithFormat:@"%@ by %@", [newsItem formattedCreated], [newsItem username]]];
    
    if (pointLabel == nil) {
        pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        [pointLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
        [pointLabel setTextColor:[UIColor colorWithRed:(176.0f/255) green:(106.0f/255) blue:(6.0f/255) alpha:1]];
        [pointLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    if (commentLabel == nil) {
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        [commentLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
        [commentLabel setTextColor:[UIColor colorWithRed:(176.0f/255) green:(106.0f/255) blue:(6.0f/255) alpha:1]];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    
    [pointLabel setText:[[NSString alloc] initWithFormat:@"C: %@", [newsItem numComments]]];
    [pointLabel sizeToFit];
    
    [commentLabel setText:[[NSString alloc] initWithFormat:@"P: %@", [newsItem points]]];
    [commentLabel sizeToFit];
    
    CGFloat pointLabelWidth = pointLabel.frame.size.width;
    CGFloat pointLabelHeight = pointLabel.frame.size.height;
    CGFloat commentLabelWidth = commentLabel.frame.size.width;
    CGFloat commentLabelHeight = commentLabel.frame.size.height;
    
    [pointLabel setFrame:CGRectMake(hGap, vGap, pointLabelWidth, pointLabelHeight)];
    [commentLabel setFrame:CGRectMake(pointLabelWidth + hGap*2, vGap, commentLabelWidth, commentLabelHeight)];
    
    
    if (pointCommentView == nil) {
        pointCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [pointCommentView setBackgroundColor:[UIColor colorWithRed:(239.0f/255) green:(223.0f/255) blue:(193.0f/255) alpha:1]];
        
        dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, commentLabelHeight, 3, 3)];
        [dummyView setBackgroundColor:[UIColor colorWithRed:(239.0f/255) green:(223.0f/255) blue:(193.0f/255) alpha:1]];
        
        [pointCommentView addSubview:dummyView];
        [pointCommentView addSubview:pointLabel];
        [pointCommentView addSubview:commentLabel];
        
        [[pointCommentView layer] setCornerRadius:3.0f];
        
        [self addSubview:pointCommentView];
    }
    
    [pointCommentView setFrame:CGRectMake(self.frame.size.width - commentLabelWidth - pointLabelWidth - hGap*3,
                                          self.frame.size.height - commentLabelHeight - vGap,
                                          commentLabelWidth + pointLabelWidth + hGap*3 + 3,
                                          commentLabelHeight + vGap)];
}

#pragma mark - NSURLConnection

- (NSCachedURLResponse *)connection:(NSURLConnection *)c
                  willCacheResponse:(NSCachedURLResponse *)response {
    NSLog(@"Will Cache Response %@", response);
	
	NSURLCache *cache = [NSURLCache sharedURLCache];
	[cache storeCachedResponse:response forRequest:urlRequest];
	
    return response;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [self loadCacheData:receivedData];
    [[self loadingIndicator] setAlpha:0.0f];
}

@end
