//
//  SENewsItemTopWebCell.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/17/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItemTopWebCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SENewsItemTopWebCell

@synthesize webView, newsItem, receivedData, urlRequest;
@synthesize timeAuthorLabel = _timeAuthorLabel;
@synthesize loadingIndicator = _loadingIndicator;
@synthesize titleTextView = _titleTextView;
@synthesize pointCommentView;
@synthesize dummyView;
@synthesize pointLabel;
@synthesize commentLabel;
@synthesize pointIconView;
@synthesize commentIconView;

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

- (void)loadContent:(SENewsItem *)n
{
    [self setNewsItem:n];
    [self loadWebView];
    
    [[self titleTextView] setFont:[UIFont fontWithName:@"Roboto-Light" size:24.0f]];
    [[self titleTextView] setTextColor:[UIColor colorWithRed:(227.0f/255) green:(93.0f/255) blue:(44.0f/255) alpha:1]];
    [[[self titleTextView] layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[[self titleTextView] layer] setShadowOffset:CGSizeMake(0.0, 1)];
    [[[self titleTextView] layer] setShadowOpacity:1.0f];
    [[[self titleTextView] layer] setShadowRadius:0.0f];
    [[self titleTextView] setText:[newsItem title]];
}

- (void)layoutSubviews
{
    UIColor *contentColor = [UIColor colorWithWhite:0.4f alpha:1];
    UIColor *iconColor = [UIColor colorWithWhite:0.8f alpha:1];
    UIColor *bgColor = [UIColor colorWithWhite:0.9f alpha:1];
    UIFont *contentFont = [UIFont fontWithName:@"Roboto-Light" size:14.0f];
    UIFont *timeAuthorFont = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
    
    [[self timeAuthorLabel] setFont:timeAuthorFont];
    [[self timeAuthorLabel] setTextColor:[UIColor whiteColor]];
    [[self timeAuthorLabel] setBounds:CGRectMake(0, 0, 290, 21)];
    [[self timeAuthorLabel] setText:[[NSString alloc] initWithFormat:@"%@ by %@", [newsItem formattedCreated], [newsItem username]]];
    
    if (pointLabel == nil) {
        pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        [pointLabel setFont:contentFont];
        [pointLabel setTextColor:contentColor];
        [pointLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    if (commentLabel == nil) {
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        
        [commentLabel setFont:contentFont];
        [commentLabel setTextColor:contentColor];
        [commentLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    
    [pointLabel setText:[[NSString alloc] initWithFormat:@"%@", [newsItem points]]];
    [pointLabel sizeToFit];
    
    [commentLabel setText:[[NSString alloc] initWithFormat:@"%@", [newsItem numComments]]];
    [commentLabel sizeToFit];
    
    CGFloat pointLabelWidth = pointLabel.frame.size.width;
    CGFloat pointLabelHeight = pointLabel.frame.size.height;
    CGFloat commentLabelWidth = commentLabel.frame.size.width;
    CGFloat commentLabelHeight = commentLabel.frame.size.height;
    CGFloat iconSize = 12.0f;
    
    [pointLabel setFrame:CGRectMake(hGap + 3 + iconSize, vGap, pointLabelWidth, pointLabelHeight)];
    [commentLabel setFrame:CGRectMake(pointLabelWidth + iconSize*2 + hGap*2 + 6, vGap, commentLabelWidth, commentLabelHeight)];
    
    
    if (pointCommentView == nil) {
        pointCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [pointCommentView setBackgroundColor:bgColor];
        
        dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, commentLabelHeight, 3, 3)];
        [dummyView setBackgroundColor:bgColor];
        
        pointIconView = [self tintImage:@"point.png" withColor:iconColor withSize:CGSizeMake(iconSize, iconSize)];
        commentIconView = [self tintImage:@"comment.png" withColor:iconColor withSize:CGSizeMake(iconSize, iconSize)];
        
        [pointCommentView addSubview:pointIconView];
        [pointCommentView addSubview:commentIconView];
        [pointCommentView addSubview:dummyView];
        [pointCommentView addSubview:pointLabel];
        [pointCommentView addSubview:commentLabel];
        
        [[pointCommentView layer] setCornerRadius:3.0f];
        
        [self addSubview:pointCommentView];
    }
    
    [pointIconView setFrame:CGRectMake(hGap, vGap+2, iconSize, iconSize)];
    [commentIconView setFrame:CGRectMake(hGap*2 + 3 + iconSize + pointLabelWidth, vGap+2, iconSize, iconSize)];
    
    CGFloat finalWidth = commentLabelWidth + pointLabelWidth + iconSize*2 + hGap*3 + 6;
    
    [pointCommentView setFrame:CGRectMake(self.frame.size.width - finalWidth,
                                          self.frame.size.height - commentLabelHeight - vGap,
                                          finalWidth + 3,
                                          commentLabelHeight + vGap)];
}

- (UIView *)tintImage:(NSString *)imageName withColor:(UIColor *)color withSize:(CGSize)size
{
    UIView *resultView = [[UIView alloc] init];
    UIImage *myImage = [UIImage imageNamed:imageName];
    
    UIImageView *originalImageView = [[UIImageView alloc] initWithImage:myImage];
    [originalImageView setFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    [resultView addSubview:originalImageView];
    
    UIView *overlay = [[UIView alloc] initWithFrame:[originalImageView frame]];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:myImage];
    [maskImageView setFrame:[overlay bounds]];
    
    [[overlay layer] setMask:[maskImageView layer]];
    [overlay setBackgroundColor:color];
    [[overlay layer] setShouldRasterize:YES];
    [[overlay layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    [resultView addSubview:overlay];
    
    return resultView;
}

#pragma mark - NSURLConnection

- (NSCachedURLResponse *)connection:(NSURLConnection *)c
                  willCacheResponse:(NSCachedURLResponse *)response {
	
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
    
    [self loadCacheData:receivedData];
    [[self loadingIndicator] setAlpha:0.0f];
}

@end
