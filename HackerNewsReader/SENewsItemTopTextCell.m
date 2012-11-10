//
//  SENewsItemTopTextCell.m
//  HackerNewsReader
//
//  Created by Sol Eun on 11/2/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItemTopTextCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SENewsItemTopTextCell

@synthesize newsItem;
@synthesize timeAuthorLabel = _timeAuthorLabel;
@synthesize titleTextView = _titleTextView;
@synthesize textView;
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
    
    [[self titleTextView] setFont:[UIFont fontWithName:@"Roboto-Light" size:24.0f]];
    [[self titleTextView] setTextColor:[UIColor colorWithRed:(227.0f/255) green:(93.0f/255) blue:(44.0f/255) alpha:1]];
    [[[self titleTextView] layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[[self titleTextView] layer] setShadowOffset:CGSizeMake(0.0, 1)];
    [[[self titleTextView] layer] setShadowOpacity:1.0f];
    [[[self titleTextView] layer] setShadowRadius:0.0f];
    [[self titleTextView] setText:[newsItem title]];
    
    if (!textView) {
        textView = [[UIWebView alloc] init];
        [textView setDelegate:self];
        [textView setUserInteractionEnabled:NO];
        
        [self addSubview:textView];
    }
}

- (void)layoutSubviews
{
    float width = 310.0f;
    [[self textView] setFrame:CGRectMake(5, 150, width, [[newsItem contentHeight] floatValue] - 150.0f)];
    
    NSString *htmlString = [[NSString alloc] initWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-family: \"%@\"; font-size: %@; background-color:#222222; color:#FFFFFF}\n"
                            "a {text-decoration:none; color:#FFFFFF;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>", @"Roboto-Light", @"16px", [[self newsItem] text]];
    
    [[self textView] loadHTMLString:htmlString baseURL:nil];
    
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

#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    float width = 310.0f;
    
    if ([[newsItem contentHeight] floatValue] == -1.0f) {
        CGRect frame = textView.frame;
        frame.size.width = width;
        frame.size.height = 1;
        textView.frame = frame;
        CGSize fittingSize = [textView sizeThatFits:CGSizeMake(width, 1)];
        
        frame.size.height = fittingSize.height;
        textView.frame = frame;
        
        [newsItem setContentHeight:[[NSNumber alloc] initWithFloat:fittingSize.height + 150.0f]];
        
        [[textView layer] setShouldRasterize:YES];
        [[textView layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
        
        [(UITableView *)self.superview beginUpdates];
        [(UITableView *)self.superview endUpdates];
        
        [textView stringByEvaluatingJavaScriptFromString:@"window.alert=null;"];
    }
}

@end
