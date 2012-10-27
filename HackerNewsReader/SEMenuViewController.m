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
    NSDictionary *frontPage = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Front Page", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=product(points,pow(2,div(div(ms(create_ts,NOW),3600000),1)))%20desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    
    NSDictionary *newPage = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"New", @"name", @"http://api.thriftdb.com/api.hnsearch.com/items/_search?limit=30&filter[fields][type]=submission&sortby=create_ts%20desc", @"url", @"FrontNavigationTop", @"storyboardId", nil];
    
    self.menuItems = [NSArray arrayWithObjects:frontPage, newPage, nil];
    currentMenuItem = frontPage;
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
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
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
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"storyboardId"]];
    
    SEFrontNavigationTopViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    currentMenuItem = [self.menuItems objectAtIndex:indexPath.row];
    [newTopViewController setCurrentMenuItem:currentMenuItem];
        
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"test section";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}


@end
