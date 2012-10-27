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
@synthesize titleLabel = _titleLabel;
@synthesize timeAuthorLabel = _timeAuthorLabel;

UIView *pointCommentView;
UIView *dummyView;
UILabel *pointLabel;
UILabel *commentLabel;
CGFloat viewWidth = 80;
CGFloat viewHeight = 20;
CGFloat hGap = 5;
CGFloat vGap = 2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withNewsItem:(SENewsItem *)currentItem
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setNewsItem:currentItem];
    }
    return self;
}

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
    pointCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [pointCommentView setBackgroundColor:[UIColor whiteColor]];
    
    pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [pointLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0f]];
    [pointLabel setTextColor:[UIColor grayColor]];
    [pointLabel setText:[[NSString alloc] initWithFormat:@"C: %@", [newsItem numComments]]];
    [pointLabel sizeToFit];
    
    [commentLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0f]];
    [commentLabel setTextColor:[UIColor grayColor]];
    [commentLabel setText:[[NSString alloc] initWithFormat:@"P: %@", [newsItem points]]];
    [commentLabel sizeToFit];
    
    CGFloat pointLabelWidth = pointLabel.frame.size.width;
    CGFloat pointLabelHeight = pointLabel.frame.size.height;
    CGFloat commentLabelWidth = commentLabel.frame.size.width;
    CGFloat commentLabelHeight = commentLabel.frame.size.height;
    
    [pointCommentView setFrame:CGRectMake([self containerView].frame.size.width - commentLabelWidth - pointLabelWidth - hGap*3,
                                          [self containerView].frame.size.height - commentLabelHeight - vGap,
                                          commentLabelWidth + pointLabelWidth + hGap*3 + 3,
                                          commentLabelHeight + vGap)];
    
    [pointLabel setFrame:CGRectMake(hGap, vGap, pointLabelWidth, pointLabelHeight)];
    [commentLabel setFrame:CGRectMake(pointLabelWidth + hGap*2, vGap, commentLabelWidth, commentLabelHeight)];
    
    dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, commentLabelHeight, 3, 3)];
    [dummyView setBackgroundColor:[UIColor whiteColor]];
    
    [pointCommentView addSubview:dummyView];
    [pointCommentView addSubview:pointLabel];
    [pointCommentView addSubview:commentLabel];
    
    [[pointCommentView layer] setCornerRadius:3.0f];
    
    [[self containerView] addSubview:pointCommentView];
}

- (void)updateCell
{
    [[self titleLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:18.0f]];
    [[self titleLabel] setTextColor:[UIColor orangeColor]];
    [[self titleLabel] setShadowColor:[UIColor blackColor]];
    [[self titleLabel] setShadowOffset:CGSizeMake(0.0, 0.5)];
    [[self titleLabel] setText:[newsItem title]];
    [[self titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[self titleLabel] sizeToFit];
    
    [[self timeAuthorLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
    [[self timeAuthorLabel] setTextColor:[UIColor grayColor]];
    [[self timeAuthorLabel] setBounds:CGRectMake(0, 0, 290, 21)];
    [[self timeAuthorLabel] setText:[[NSString alloc] initWithFormat:@"%@ by %@", [newsItem formattedCreated], [newsItem username]]];
    
    [[[self containerView] layer] setCornerRadius:3.0f];
    [[[self containerView] layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[[self containerView] layer] setShadowOffset:CGSizeMake(1, 1)];
    [[[self containerView] layer] setShadowRadius:2];
    [[[self containerView] layer] setShadowOpacity:0.7];
}

@end
