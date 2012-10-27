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
@synthesize loadingIndicator = _loadingIndicator;
@synthesize titleTextView = _titleTextView;

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
