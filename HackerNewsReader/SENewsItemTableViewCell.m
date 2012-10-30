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

static CGFloat viewWidth = 80;
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
    //[pointLabel removeFromSuperview];
    //[commentLabel removeFromSuperview];
    //[dummyView removeFromSuperview];
    
    //[pointCommentView removeFromSuperview];
}

- (void)layoutSubviews
{
    // 242, 175, 79
    [self setBackgroundColor:[UIColor colorWithRed:(242.0f/255) green:(175.0f/255) blue:(79.0f/255) alpha:1]];
    
    [[self titleLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:18.0f]];
    [[self titleLabel] setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    //[[self titleLabel] setShadowColor:[UIColor orangeColor]];
    //[[self titleLabel] setShadowOffset:CGSizeMake(0.0, 0.5)];
    [[self titleLabel] setText:[newsItem title]];
    [[self titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[self titleLabel] sizeToFit];
    
    [[self timeAuthorLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
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
        
        [[self containerView] addSubview:pointCommentView];
    }
    
    [pointCommentView setFrame:CGRectMake([self containerView].frame.size.width - commentLabelWidth - pointLabelWidth - hGap*3,
                                          [self containerView].frame.size.height - commentLabelHeight - vGap,
                                          commentLabelWidth + pointLabelWidth + hGap*3 + 3,
                                          commentLabelHeight + vGap)];
}

@end
