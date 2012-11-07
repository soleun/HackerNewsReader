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
        float padding = [[comment depth] floatValue]*20.0f;
        float width = 320.0f - padding;
        
        commentView = [[UIWebView alloc] initWithFrame:CGRectMake(padding, 0, width, 43)];
        [commentView setDelegate:self];
        [commentView setUserInteractionEnabled:NO];
        
        [self addSubview:commentView];
        
        NSLog(@"%f", commentView.frame.size.height);
    }
}

- (void)layoutSubviews
{
    SENewsItemComment *comment = [newsItemCommentsArray objectAtIndex:newsItemCommentIndex];
    float padding = [[comment depth] floatValue]*20.0f;
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
    NSLog(@"%@", htmlString);
    
    [commentView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    SENewsItemComment *comment = [newsItemCommentsArray objectAtIndex:newsItemCommentIndex];
    float padding = [[comment depth] floatValue]*20.0f;
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
        
        NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
        
        [(UITableView *)self.superview beginUpdates];
        [(UITableView *)self.superview endUpdates];
        
        [webView stringByEvaluatingJavaScriptFromString:@"window.alert=null;"];
    }
}

@end
