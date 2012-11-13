//
//  SEMenuViewController.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SEMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

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

- (IBAction)linkAuthorHomeClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://about.me/soleun"]];
}

- (IBAction)linkAuthorTwitterClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/soleun"]];
}

- (IBAction)linkDesignerHomeClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://joelglovier.com/"]];
}

- (IBAction)linkDesignerTwitterClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/jglovier"]];
}

#pragma mark UITableViewDelegate / UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count + 2;
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
    } else if ([indexPath row] == self.menuItems.count + 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"about"];
        
        CGFloat height = self.view.frame.size.height - (44.0f * (self.menuItems.count + 1));
        
        UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, height - 150.0f, 300.0f, 130.0f)];
        [aboutView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310.0f, 20.0f)];
        [aboutLabel setBackgroundColor:[UIColor clearColor]];
        [aboutLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
        [aboutLabel setTextColor:[UIColor whiteColor]];
        [aboutLabel setText:@"About Hacker News Reader"];
        
        [aboutView addSubview:aboutLabel];
        
        float authorHeight = 40.0f;
        
        UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, authorHeight, 300.0f, 20.0f)];
        [authorLabel setBackgroundColor:[UIColor clearColor]];
        [authorLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
        [authorLabel setTextColor:[UIColor whiteColor]];
        [authorLabel setText:@"Designed and written by"];
        
        [aboutView addSubview:authorLabel];
        
        UILabel *authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, authorHeight + 20, 300.0f, 20.0f)];
        [authorNameLabel setBackgroundColor:[UIColor clearColor]];
        [authorNameLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
        [authorNameLabel setTextColor:[UIColor whiteColor]];
        [authorNameLabel setText:@"Sol Eun"];
        
        [aboutView addSubview:authorNameLabel];
        
        UIButton *authorHomeButton = [[UIButton alloc] initWithFrame:CGRectMake(195.0f, authorHeight + 10.0f, 20.0f, 20.0f)];
        [authorHomeButton addTarget:self
                   action:@selector(linkAuthorHomeClick:)
         forControlEvents:UIControlEventTouchDown];
        
        UIView *authorHomeIcon = [self tintImage:@"home.png" withColor:[UIColor whiteColor] withSize:CGSizeMake(20.0f, 20.0f)];
        
        [authorHomeButton addSubview:authorHomeIcon];
        [aboutView addSubview:authorHomeButton];
        
        UIButton *authorTwitterButton = [[UIButton alloc] initWithFrame:CGRectMake(225.0f, authorHeight + 14.0f, 24.0f, 24.0f)];
        [authorTwitterButton addTarget:self
                             action:@selector(linkAuthorTwitterClick:)
                   forControlEvents:UIControlEventTouchDown];
        
        UIView *authorTwitterIcon = [self tintImage:@"twitter.png" withColor:[UIColor whiteColor] withSize:CGSizeMake(24.0f, 15.0f)];
        
        [authorTwitterButton addSubview:authorTwitterIcon];
        [aboutView addSubview:authorTwitterButton];
        
        
        float iconDesignerHeight = authorHeight + 50.0f;
        
        UILabel *iconDesignerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconDesignerHeight, 300.0f, 20.0f)];
        [iconDesignerLabel setBackgroundColor:[UIColor clearColor]];
        [iconDesignerLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12.0f]];
        [iconDesignerLabel setTextColor:[UIColor whiteColor]];
        [iconDesignerLabel setText:@"Hacker News icon designed by"];
        
        [aboutView addSubview:iconDesignerLabel];
        
        UILabel *iconDesignerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconDesignerHeight + 20, 300.0f, 20.0f)];
        [iconDesignerNameLabel setBackgroundColor:[UIColor clearColor]];
        [iconDesignerNameLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0f]];
        [iconDesignerNameLabel setTextColor:[UIColor whiteColor]];
        [iconDesignerNameLabel setText:@"Joel Glovier"];
        
        [aboutView addSubview:iconDesignerNameLabel];
        
        
        UIButton *designerHomeButton = [[UIButton alloc] initWithFrame:CGRectMake(195.0f, iconDesignerHeight + 10.0f, 20.0f, 20.0f)];
        [designerHomeButton addTarget:self
                             action:@selector(linkDesignerHomeClick:)
                   forControlEvents:UIControlEventTouchDown];
        
        UIView *designerHomeIcon = [self tintImage:@"home.png" withColor:[UIColor whiteColor] withSize:CGSizeMake(20.0f, 20.0f)];
        
        [designerHomeButton addSubview:designerHomeIcon];
        [aboutView addSubview:designerHomeButton];
        
        UIButton *designerTwitterButton = [[UIButton alloc] initWithFrame:CGRectMake(225.0f, iconDesignerHeight + 14.0f, 24.0f, 24.0f)];
        [designerTwitterButton addTarget:self
                                action:@selector(linkDesignerTwitterClick:)
                      forControlEvents:UIControlEventTouchDown];
        
        UIView *designerTwitterIcon = [self tintImage:@"twitter.png" withColor:[UIColor whiteColor] withSize:CGSizeMake(24.0f, 15.0f)];
        
        [designerTwitterButton addSubview:designerTwitterIcon];
        [aboutView addSubview:designerTwitterButton];
        
        
        [cell addSubview:aboutView];
        
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] > 0 && [indexPath row] < self.menuItems.count + 1) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    if ([indexPath row] == self.menuItems.count + 1) {
        height = self.view.frame.size.height - (44.0f * (self.menuItems.count + 1));
    }
    
    return height;
}


@end
