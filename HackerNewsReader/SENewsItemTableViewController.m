//
//  SENewsItemTableViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItemTableViewController.h"
#import "GAI.h"

@interface SENewsItemTableViewController ()

@end

@implementation SENewsItemTableViewController

@synthesize frontTableView, menuItem;

NSMutableArray *newsItems;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showNewsItem"]) {
        SENewsItemCommentTableViewController *nitvc = [segue destinationViewController];
        NSIndexPath *path = [[self frontTableView] indexPathForSelectedRow];
        
        SENewsItem *item = [newsItems objectAtIndex:[path row]];
        
        [nitvc setNewsItem:item];
    }
}

- (IBAction)showMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [((SEAppDelegate *)[UIApplication sharedApplication].delegate).tracker trackView:@"NewsItem Screen"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshTable];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
    //                                 [UIImage imageNamed:@"iphone_retina_3.5.png"]];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [navTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setText:[menuItem objectForKey:@"name"]];
    [navTitle sizeToFit];
    
    [[self navigationItem] setTitleView:navTitle];
    
    
    // TODO: menu icon
    /*UIImage *menuIconImage = [UIImage imageNamed:@"menu.png"];
    UIImageView *menuIconImageView = [[UIImageView alloc] initWithImage:menuIconImage];
    [menuIconImageView setFrame:CGRectMake(0, 0, 16.0f, 16.0f)];
    
    UIView *overlay = [[UIView alloc] initWithFrame:[menuIconImageView frame]];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:menuIconImage];
    [maskImageView setFrame:[overlay bounds]];
    
    [[overlay layer] setMask:[maskImageView layer]];
    
    [overlay setBackgroundColor:[UIColor redColor]];
    
    [self setMenuButton:[[UIBarButtonItem alloc] initWithCustomView:menuIconImageView]];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] init];
    
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

- (void)refreshTable
{
    menuItem = [(SEFrontNavigationTopViewController *)self.navigationController currentMenuItem];
    
    if ((NSNull *)menuItem == [NSNull null] || menuItem == nil) {
        menuItem = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Front Page", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=product(points,pow(2,div(div(ms(create_ts,NOW),3600000),1)))%20desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    }
    
    
    [self setTitle:[menuItem objectForKey:@"name"]];
    
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[menuItem objectForKey:@"url"]];
    NSString *json = [NSString stringWithContentsOfURL:url
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
    
    if(!error) {
        NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:kNilOptions
                                                                   error:&error];
        
        id results = [jsonDict objectForKey:@"results"];
        
        newsItems = [[NSMutableArray alloc] init];
        
        NSDateFormatter *dateFormatUTC = [[NSDateFormatter alloc] init];
        [dateFormatUTC setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatUTC setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
        
        SENewsItem *item;
        for (NSDictionary* result in results) {
            item = [[SENewsItem alloc] init];
            [item setSigId:[[result objectForKey:@"item"] objectForKey:@"_id"]];
            [item setTitle:[[result objectForKey:@"item"] objectForKey:@"title"]];
            [item setUsername:[[result objectForKey:@"item"] objectForKey:@"username"]];
            [item setText:[[result objectForKey:@"item"] objectForKey:@"text"]];
            [item setCreated:[dateFormatUTC dateFromString:[[result objectForKey:@"item"] objectForKey:@"create_ts"]]];
            [item setPoints:[NSNumber numberWithInt:[[[result objectForKey:@"item"] objectForKey:@"points"] integerValue]]];
            [item setNumComments:[NSNumber numberWithInt:[[[result objectForKey:@"item"] objectForKey:@"num_comments"] integerValue]]];
            [item setContentHeight:[NSNumber numberWithFloat:-1.0f]];
            
            NSString *url = (NSString *)[[result objectForKey:@"item"] objectForKey:@"url"];
            if ((NSNull *)url == [NSNull null]) {
                [item setUrl:@"about:blank"];
            } else {
                [item setUrl:url];
            }
            
            [newsItems addObject:item];
        }
        
        [[self tableView] reloadData];
    }
}

- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsItemCell";
    
    // check for resuable cell
    SENewsItemTableViewCell *cell = (SENewsItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // create cell
        cell = [[SENewsItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text label for cell
    SENewsItem *currentItem = [newsItems objectAtIndex:[indexPath row]];
    [cell setNewsItem:currentItem];
    
    [[cell layer] setShouldRasterize:YES];
    [[cell layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SENewsItem *currentItem = [newsItems objectAtIndex:[indexPath row]];

    CGSize titleHeight = [[currentItem title] sizeWithFont:[UIFont fontWithName:@"Roboto-Light" size:18.0f] constrainedToSize:CGSizeMake(290.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];

    NSInteger height = titleHeight.height + 45;
    
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
