//
//  SENewsItemTableCommentViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/16/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SENewsItemCommentTableViewController.h"

@interface SENewsItemCommentTableViewController ()

@end

@implementation SENewsItemCommentTableViewController

@synthesize newsItem;

NSMutableArray *comments;
bool loadingFlag = NO;

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
    
    loadingFlag = YES;
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
    //                                 [UIImage imageNamed:@"iphone_retina_3.5.png"]];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [navTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setText:[newsItem title]];
    [navTitle sizeToFit];
    
    [[self navigationItem] setTitleView:navTitle];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self refreshTable];
        loadingFlag = NO;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    
    int64_t delay = 1.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self refreshTable];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                                 [formatter stringFromDate:[NSDate date]]];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
        [self.refreshControl endRefreshing];
    });
}

- (NSMutableArray *)structureComments:(NSMutableArray *)finalArray withCommentsArray:(NSMutableArray *)commentsArray withDepth:(NSInteger)depth withSigId:(NSString *)sigId
{
    if (!commentsArray || [commentsArray count] == 0) {
        return commentsArray;
    }
    
    NSInteger i = 0;
    
    for (SENewsItemComment *comment in commentsArray) {
        if ([[comment parentSigId] isEqualToString:sigId] && ![finalArray containsObject:comment]) {
            i = 0;
            while (i < depth) {
                [comment setText:[[NSString alloc] initWithFormat:@"-> %@",[comment text]]];
                i++;
            }
            [comment setDepth:[NSNumber numberWithInt:depth]];
            [finalArray addObject:comment];
            [self structureComments:finalArray withCommentsArray:commentsArray withDepth:depth+1 withSigId:[comment sigId]];
        }
    }
    
    return finalArray;
}

- (void)refreshTable
{
    bool loadFinish = NO;
    NSInteger increments = 100;
    NSInteger start = 0;
    NSInteger total = 0;
    
    NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
    comments = [[NSMutableArray alloc] init];
    
    while (!loadFinish) {
        NSError *error = nil;
        NSString *urlString = [[NSString alloc] initWithFormat:@"http://api.thriftdb.com/api.hnsearch.com/items/_search?filter[fields][discussion.sigid]=%@&sortby=product(points,div(sub(points,1),pow(sum(div(ms(NOW,create_ts),3600000),2.25),1.8)))&limit=%d&start=%d", [newsItem sigId], increments, start];
        //NSLog(@"%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        
        if(!error) {
            NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&error];
            
            total = [[jsonDict objectForKey:@"hits"] intValue];
            id results = [jsonDict objectForKey:@"results"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
            
            SENewsItemComment *comment;
            for (NSDictionary* result in results) {
                comment = [[SENewsItemComment alloc] init];
                
                [comment setSigId:[[result objectForKey:@"item"] objectForKey:@"_id"]];
                [comment setParentSigId:[[result objectForKey:@"item"] objectForKey:@"parent_sigid"]];
                [comment setTitle:[[result objectForKey:@"item"] objectForKey:@"title"]];
                [comment setText:[[result objectForKey:@"item"] objectForKey:@"text"]];
                [comment setUsername:[[result objectForKey:@"item"] objectForKey:@"username"]];
                [comment setCreated:[dateFormat dateFromString:[[result objectForKey:@"item"] objectForKey:@"create_ts"]]];
                [comment setPoints:[NSNumber numberWithInt:[[[result objectForKey:@"item"] objectForKey:@"points"] integerValue]]];
                [comment setNumComments:[NSNumber numberWithInt:[[[result objectForKey:@"item"] objectForKey:@"num_comments"] integerValue]]];
                
                NSString *url = (NSString *)[[result objectForKey:@"item"] objectForKey:@"url"];
                if ((NSNull *)url == [NSNull null]) {
                    [comment setUrl:@"about:blank"];
                } else {
                    [comment setUrl:url];
                }
                
                [commentsArray addObject:comment];
            }
        }
        
        start += 100;
        if (start >= total) {
            loadFinish = YES;
        }
    }
    
    comments = [self structureComments:comments withCommentsArray:commentsArray withDepth:0 withSigId:[newsItem sigId]];
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [comments count] + 1;
    
    if ([comments count] == 0 || !comments) {
        rows++;
    }
    
    return rows;
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
        
        NSString *label;
        if ([comments count] == 0 || !comments) {
            if (loadingFlag) {
                label = @"Loading Comments...";
                UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [activityIndicatorView setFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
                [activityIndicatorView setCenter:CGPointMake(160.0f, 22.0f)];
                [activityIndicatorView startAnimating];
                
                [cell addSubview:activityIndicatorView];
            } else {
                label = @"No comment";
            }
        } else {
            SENewsItemComment *currentItem = [comments objectAtIndex:[indexPath row] - 1];
            label = [currentItem text];
        }
        
        [[cell textLabel] setText:label];
        [[cell textLabel] setNumberOfLines:0];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0f]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if ([indexPath row] == 0) {
        height = 200.0f;
    } else if ([comments count] == 0 || !comments) {
        height = 44.0f;
    } else {
        SENewsItemComment *currentItem = [comments objectAtIndex:[indexPath row]-1];
        
        CGSize titleHeight = [[currentItem text] sizeWithFont:[UIFont fontWithName:@"Roboto-Light" size:14.0f] constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        height = titleHeight.height + 20;
    }
    
    return height;
}

@end
