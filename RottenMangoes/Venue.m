//
//  Venue.m
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-23.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import "Venue.h"

@implementation Venue

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle;
{
    self = [super init];
    if (self) {
        _coordinate = aCoordinate;
        _title = aTitle;
        _subtitle = aSubtitle;
    }
    return self;
}

@end
