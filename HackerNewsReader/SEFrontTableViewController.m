//
//  SEFrontTableViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SEFrontTableViewController.h"

@interface SEFrontTableViewController ()

@end

@implementation SEFrontTableViewController

@synthesize frontTableView, menuItem;

NSMutableArray *newsItems;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showNewsItem"]) {
        SENewsItemViewController *nivc = [segue destinationViewController];
        NSIndexPath *path = [[self frontTableView] indexPathForSelectedRow];
        
        SENewsItem *item = [newsItems objectAtIndex:[path row]];
        
        [nivc setNewsItem:item];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshTable];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"iphone_retina_3.5.png"]];
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
    menuItem = [(SEFrontNavigationTopViewController *)self.navigationController currentMenuItem];
    
    if ((NSNull *)menuItem == [NSNull null]) {
        menuItem = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Front Page", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=product(points,pow(2,div(div(ms(create_ts,NOW),3600000),1)))%20desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    } else if (menuItem == nil) {
        menuItem = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Front Page", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=product(points,pow(2,div(div(ms(create_ts,NOW),3600000),1)))%20desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    }
    
    
    [self setTitle:[menuItem objectForKey:@"name"]];
    
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[menuItem objectForKey:@"url"]];
    NSString *json = [NSString stringWithContentsOfURL:url
                                              encoding:NSASCIIStringEncoding
                                                 error:&error];
    //NSLog(@"\nJSON: %@ \n Error: %@", json, error);
    
    if(!error) {
        NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:kNilOptions
                                                                   error:&error];
        //NSLog(@"JSON: %@", [jsonDict objectForKey:@"results"]);
        
        id results = [jsonDict objectForKey:@"results"];
        
        newsItems = [[NSMutableArray alloc] init];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss'Z'"];
        
        SENewsItem *item;
        for (NSDictionary* result in results) {
            //NSLog(@"%@", [result objectForKey:@"item"]);
            item = [[SENewsItem alloc] init];
            //NSLog(@"title: %@", [[result objectForKey:@"item"] objectForKey:@"title"]);
            [item setTitle:[[result objectForKey:@"item"] objectForKey:@"title"]];
            [item setUsername:[[result objectForKey:@"item"] objectForKey:@"username"]];
            [item setCreated:[dateFormat dateFromString:[[result objectForKey:@"item"] objectForKey:@"create_ts"]]];
            [item setPoints:[NSNumber numberWithInt:[[[result objectForKey:@"item"] objectForKey:@"points"] integerValue]]];
            [item setNumComments:[NSNumber numberWithInt:[[[result objectForKey:@"item"] objectForKey:@"num_comments"] integerValue]]];
            //[item setNumComments:[[NSNumberFormatter alloc] numberFromString:[[result objectForKey:@"item"] objectForKey:@"num_comments"]]];
            //NSLog(@"url: %@", [[result objectForKey:@"item"] objectForKey:@"url"]);
            NSString *url = (NSString *)[[result objectForKey:@"item"] objectForKey:@"url"];
            if ((NSNull *)url == [NSNull null]) {
                [item setUrl:@"about:blank"];
            } else {
                [item setUrl:url];
            }
            
            [newsItems addObject:item];
        }
    }
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
    
    SENewsItem *currentItem = [newsItems objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        // create cell
        cell = [[SENewsItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withNewsItem:currentItem];
    } else {
        
    }
    
    // set text label for cell
    [cell setNewsItem:currentItem];
    [cell updateCell];
    
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
