//
//  SENewsItemComment.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/28/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SENewsItem.h"

@interface SENewsItemComment : SENewsItem

@property (nonatomic) NSNumber *depth;
@property (nonatomic) NSNumber *contentHeight;

@end
