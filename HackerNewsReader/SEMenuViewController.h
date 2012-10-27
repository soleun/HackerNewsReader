//
//  SEMenuViewController.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "SEFrontNavigationTopViewController.h"

@interface SEMenuViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>

@property (nonatomic, strong) NSDictionary *currentMenuItem;

@end
