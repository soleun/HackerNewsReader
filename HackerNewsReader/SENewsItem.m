//
//  SENewsItem.m
//  HackerNewsReader
//
//  Created by Sol Eun on 10/14/12.
//  Copyright (c) 2012 Sol Eun. All rights reserved.
//

#import "SENewsItem.h"

@implementation SENewsItem

@synthesize sigId, title, url, domain, text, type, username, created, parentSigId, contentHeight;

- (BOOL)hasUrl
{
    if (@"" == url) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)formattedCreated
{
    NSString * prettyTimestamp;
    
    float delta = [created timeIntervalSinceNow];
    //NSLog(@"%@, %f", created, delta);
    
    if (delta < 60) {
        prettyTimestamp = @"just now";
    } else if (delta < 120) {
        prettyTimestamp = @"one minute ago";
    } else if (delta < 3600) {
        prettyTimestamp = [NSString stringWithFormat:@"%d minutes ago", (int) floor(delta/60.0) ];
    } else if (delta < 7200) {
        prettyTimestamp = @"one hour ago";
    } else if (delta < 86400) {
        prettyTimestamp = [NSString stringWithFormat:@"%d hours ago", (int) floor(delta/3600.0) ];
    } else if (delta < ( 86400 * 2 ) ) {
        prettyTimestamp = @"one day ago";
    } else if (delta < ( 86400 * 7 ) ) {
        prettyTimestamp = [NSString stringWithFormat:@"%d days ago", (int) floor(delta/86400.0) ];
    } else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:@"on %@", [formatter stringFromDate:created]];
    }
    
    return prettyTimestamp;
}

@end
