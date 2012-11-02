//
//  SENewsItem.h
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SENewsItem : NSObject

@property (nonatomic, strong) NSString *sigId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *username;
@property (nonatomic) NSNumber *itemId;
@property (nonatomic) NSNumber *numComments;
@property (nonatomic) NSNumber *parentId;
@property (nonatomic, strong) NSString *parentSigId;
@property (nonatomic) NSNumber *points;
@property (nonatomic, strong) NSDate *created;

- (BOOL)hasUrl;
- (NSString *)formattedCreated;

@end
