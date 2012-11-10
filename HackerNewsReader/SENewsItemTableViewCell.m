//
//  SENewsItemTableViewCell.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/15/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItemTableViewCell.h"

@implementation SENewsItemTableViewCell

@synthesize newsItem, HTMLCache, receivedData;
@synthesize containerView = _containerView;
@synthesize containerBGView = _containerBGView;
@synthesize titleLabel = _titleLabel;
@synthesize timeAuthorLabel = _timeAuthorLabel;
@synthesize pointCommentView;
@synthesize dummyView;
@synthesize pointLabel;
@synthesize commentLabel;
@synthesize pointIconView;
@synthesize commentIconView;

static CGFloat viewWidth = 100;
static CGFloat viewHeight = 20;
static CGFloat hGap = 5;
static CGFloat vGap = 2;

- (NSString *) reuseIdentifier {
    return @"NewsItemCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)prepareForReuse
{
    
}

- (void)layoutSubviews
{
    //UIColor *contentColor = [UIColor colorWithRed:(176.0f/255) green:(106.0f/255) blue:(6.0f/255) alpha:1];
    //UIColor *bgColor = [UIColor colorWithRed:(239.0f/255) green:(223.0f/255) blue:(193.0f/255) alpha:1];
    UIColor *contentColor = [UIColor colorWithWhite:0.4f alpha:1];
    UIColor *iconColor = [UIColor colorWithWhite:0.8f alpha:1];
    UIColor *bgColor = [UIColor colorWithWhite:0.9f alpha:1];
    UIFont *contentFont = [UIFont fontWithName:@"Roboto-Light" size:14.0f];
    UIFont *timeAuthorFont = [UIFont fontWithName:@"Roboto-Light" size:12.0f];
    
    // 242, 175, 79
    //[self setBackgroundColor:[UIColor colorWithRed:(242.0f/255) green:(175.0f/255) blue:(79.0f/255) alpha:1]];
    [self setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1]];
    
    [[self titleLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:18.0f]];
    [[self titleLabel] setTextColor:[UIColor colorWithRed:(227.0f/255) green:(93.0f/255) blue:(44.0f/255) alpha:1]];
    [[self titleLabel] setText:[newsItem title]];
    [[self titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[self titleLabel] sizeToFit];
    
    [[self timeAuthorLabel] setFont:timeAuthorFont];
    [[self timeAuthorLabel] setTextColor:[UIColor grayColor]];
    [[self timeAuthorLabel] setBounds:CGRectMake(0, 0, 290, 21)];
    [[self timeAuthorLabel] setText:[[NSString alloc] initWithFormat:@"%@ by %@", [newsItem formattedCreated], [newsItem username]]];
    
    [[[self containerView] layer] setCornerRadius:3.0f];
    
    [[[self containerBGView] layer] setCornerRadius:3.0f];
    [[[self containerBGView] layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[[self containerBGView] layer] setShadowOffset:CGSizeMake(0, 0)];
    [[[self containerBGView] layer] setShadowRadius:1];
    [[[self containerBGView] layer] setShadowOpacity:0.5];
    [[[self containerBGView] layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [[[self containerBGView] layer] setShadowPath:[UIBezierPath bezierPathWithRect:[self containerBGView].layer.bounds].CGPath];
    
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
        
        [[self containerView] addSubview:pointCommentView];
    }
    
    [pointIconView setFrame:CGRectMake(hGap, vGap+2, iconSize, iconSize)];
    [commentIconView setFrame:CGRectMake(hGap*2 + 3 + iconSize + pointLabelWidth, vGap+2, iconSize, iconSize)];
    
    CGFloat finalWidth = commentLabelWidth + pointLabelWidth + iconSize*2 + hGap*3 + 6;
    
    [pointCommentView setFrame:CGRectMake([self containerView].frame.size.width - finalWidth,
                                          [self containerView].frame.size.height - commentLabelHeight - vGap,
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

@end
