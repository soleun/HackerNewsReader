//
//  SENewsItemCommentCell.m
//  HackerNewsReader
//
//  Created by Sol Eun on 11/6/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItemCommentCell.h"

@implementation SENewsItemCommentCell

@synthesize newsItemCommentsArray, newsItemCommentIndex, commentView;
@synthesize timeAuthorLabel;
@synthesize replyIconView;

const CGFloat paddingWidth = 15.0f;

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

- (void)loadContent:(NSMutableArray *)comments atIndex:(NSInteger)i
{
    [self setNewsItemCommentsArray:comments];
    [self setNewsItemCommentIndex:i];
    
    if (!commentView) {
        SENewsItemComment *comment = [newsItemCommentsArray objectAtIndex:newsItemCommentIndex];
        float padding = [[comment depth] floatValue] * paddingWidth;
        float width = 320.0f - padding;
        
        commentView = [[UIWebView alloc] initWithFrame:CGRectMake(padding, 0, width, 43)];
        [commentView setDelegate:self];
        [commentView setUserInteractionEnabled:NO];
        
        [self addSubview:commentView];
        
        timeAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
        UIFont *timeAuthorFont = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
        
        [[self timeAuthorLabel] setFont:timeAuthorFont];
        [[self timeAuthorLabel] setTextColor:[UIColor grayColor]];
        [[self timeAuthorLabel] setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:timeAuthorLabel];
        
        replyIconView = [self tintImage:@"reply.png" withColor:[UIColor grayColor] withSize:CGSizeMake(12.0f, 12.0f)];
        
        [self addSubview:replyIconView];
    }
}

- (void)layoutSubviews
{
    SENewsItemComment *comment = [newsItemCommentsArray objectAtIndex:newsItemCommentIndex];
    float padding = [[comment depth] floatValue] * paddingWidth;
    float width = 320.0f - padding;
    
    [commentView setFrame:CGRectMake(padding, 0, width, [[comment contentHeight] floatValue])];
    
    NSString *htmlString = [[NSString alloc] initWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-family: \"%@\"; font-size: %@;}\n"
                            "a {text-decoration:none; color:#000000;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>", @"Roboto-Light", @"14px", [[newsItemCommentsArray objectAtIndex:newsItemCommentIndex] text]];
    
    [commentView loadHTMLString:htmlString baseURL:nil];
    
    
    [[self replyIconView] setFrame:CGRectMake(padding - paddingWidth + 2, 10.0f, 12.0f, 12.0f)];
    
    [[self timeAuthorLabel] setFrame:CGRectMake(padding, [[comment contentHeight] floatValue], width, 21)];
    [[self timeAuthorLabel] setText:[[NSString alloc] initWithFormat:@"  %@ by %@", [comment formattedCreated], [comment username]]];
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

#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    SENewsItemComment *comment = [newsItemCommentsArray objectAtIndex:newsItemCommentIndex];
    float padding = [[comment depth] floatValue] * paddingWidth;
    float width = 320.0f - padding;
    
    if ([[comment contentHeight] intValue] == -1) {
        CGRect frame = commentView.frame;
        frame.size.width = width;
        frame.size.height = 1;
        commentView.frame = frame;
        CGSize fittingSize = [commentView sizeThatFits:CGSizeMake(width, 1)];
        
        frame.size.height = fittingSize.height;
        commentView.frame = frame;
        
        [comment setContentHeight:[[NSNumber alloc] initWithFloat:fittingSize.height]];
        
        [[commentView layer] setShouldRasterize:YES];
        [[commentView layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
        
        [(UITableView *)self.superview beginUpdates];
        [(UITableView *)self.superview endUpdates];
        
        [webView stringByEvaluatingJavaScriptFromString:@"window.alert=null;"];
    }
}

@end
