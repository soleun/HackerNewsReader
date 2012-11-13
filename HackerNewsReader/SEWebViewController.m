//
//  SEWebViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SEWebViewController.h"

@interface SEWebViewController ()

@end

@implementation SEWebViewController

@synthesize newsItem, currentNewsItemWebView, receivedData, urlRequest;
@synthesize loadingView = _loadingView;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize loadingLabel = _loadingLabel;

- (void)loadCacheData:(NSData *)data
{
    [currentNewsItemWebView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self loadingView] setAlpha:1];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                       target:self action:@selector(refreshWebView:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [navTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setText:[newsItem title]];
    [navTitle sizeToFit];
    
    [[self navigationItem] setTitleView:navTitle];
    
    //URLRequest
    NSURL *url = [[NSURL alloc] initWithString:[newsItem url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest = request;
    
    NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    if (response) {
        [self loadCacheData:[response data]];
        [[self loadingView] setAlpha:0];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshWebView:(id)sender
{
    [[self loadingView] setAlpha:1];
    
    NSURL *url = [[NSURL alloc] initWithString:[newsItem url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest = request;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
    }
}

#pragma mark - NSURLConnection

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
    
    [self loadCacheData:receivedData];
    [[self loadingView] setAlpha:0];
}

@end
