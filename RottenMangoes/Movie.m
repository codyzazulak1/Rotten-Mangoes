//
//  Movie.m
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-22.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithTitle:(NSString*)title andImage:(UIImage*)image andScore:(NSNumber*)score {
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _score = score;
    }
    return self;
}

@end
