//
//  SEMenuViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SEMenuViewController.h"

@interface SEMenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SEMenuViewController

@synthesize menuItems, currentMenuItem;

- (void)awakeFromNib
{
    
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    NSDictionary *frontPage = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Front Page", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=product(points,pow(2,div(div(ms(create_ts,NOW),3600000),1)))+desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    
    NSDictionary *newPage = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"New", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=create_ts+desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    
    NSDictionary *askPage = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Ask", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&filter[queries][]=-url:http*&sortby=create_ts+desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    
    self.menuItems = [NSArray arrayWithObjects:frontPage, newPage, askPage, nil];
    currentMenuItem = frontPage;
}
/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
#pragma mark UITableViewDelegate / UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([indexPath row] == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"appHeader"];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
        [titleView setBackgroundColor:[UIColor colorWithRed:(227.0f/255) green:(93.0f/255) blue:(44.0f/255) alpha:1]];
        
        UIImageView *hnLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sm.png"]];
        [hnLogoImageView setFrame:CGRectMake(5.0f, 2.0f, 40.0f, 40.0f)];
        
        [titleView addSubview:hnLogoImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 0, 260.0f, 44.0f)];
        [titleLabel setBackgroundColor:[UIColor colorWithRed:(227.0f/255) green:(93.0f/255) blue:(44.0f/255) alpha:1]];
        [titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0f]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"Hacker News Reader"];
        
        [titleView addSubview:titleLabel];
        
        [cell addSubview:titleView];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
        NSString *cellIdentifier = @"MenuItemCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [[cell textLabel] setFont:[UIFont fontWithName:@"Roboto-Light" size:20.0f]];
        [[cell textLabel] setTextColor:[UIColor whiteColor]];
        [[cell textLabel] setText:[[self.menuItems objectAtIndex:indexPath.row - 1] objectForKey:@"name"]];
    }
    
    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] > 0) {
        NSString *identifier = [NSString stringWithFormat:@"%@", [[self.menuItems objectAtIndex:indexPath.row - 1] objectForKey:@"storyboardId"]];
        
        SEFrontNavigationTopViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        currentMenuItem = [self.menuItems objectAtIndex:indexPath.row - 1];
        [newTopViewController setCurrentMenuItem:currentMenuItem];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
