//
//  SENewsItemTableViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/16/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SENewsItemTableViewController.h"

@interface SENewsItemTableViewController ()

@end

@implementation SENewsItemTableViewController

@synthesize newsItem;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWeb"]) {
        SEWebViewController *wvc = [segue destinationViewController];
        
        [wvc setNewsItem:newsItem];
    }
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
    
    [self refreshTable];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"iphone_retina_3.5.png"]];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [navTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setText:[newsItem title]];
    [navTitle sizeToFit];
    
    [[self navigationItem] setTitleView:navTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    [self refreshTable];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)refreshTable
{
    // TODO: Refresh table
    
    // Comment fetch url : http://api.thriftdb.com/api.hnsearch.com/items/_search?filter[fields][discussion.sigid]=4691251-ad4a0&sortby=product(points,div(sub(points,1),pow(sum(div(ms(NOW,create_ts),3600000),2.25),1.8)))&limit=100
    
    
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    if ([indexPath row] == 0) {
        CellIdentifier = @"NewsItemTopWeb";
        
        SENewsItemTopWebCell *cell = (SENewsItemTopWebCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            // create cell
            cell = [[SENewsItemTopWebCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell setNewsItem:newsItem];
        [cell loadWebView];
        
        [[cell titleTextView] setFont:[UIFont fontWithName:@"Roboto-Light" size:24.0f]];
        [[cell titleTextView] setTextColor:[UIColor orangeColor]];
        [[[cell titleTextView] layer] setShadowColor:[[UIColor blackColor] CGColor]];
        [[[cell titleTextView] layer] setShadowOffset:CGSizeMake(0.0, 1)];
        [[[cell titleTextView] layer] setShadowOpacity:1.0f];
        [[[cell titleTextView] layer] setShadowRadius:0.0f];
        [[cell titleTextView] setText:[newsItem title]];
        
        return cell;
    } else {
        CellIdentifier = @"NewsItemComment";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *label = [[NSString alloc] initWithFormat:@"Comment %i", [indexPath row]];
        [[cell textLabel] setText:label];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:16.0f]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        return 200.0f;
    } else {
        return 44.0f;
    }
}

@end
