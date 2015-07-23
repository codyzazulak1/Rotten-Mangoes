//
//  Movie.h
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-22.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSNumber *score;

-(instancetype)initWithTitle:(NSString*)title andImage:(UIImage*)image andScore:(NSNumber*)score;

@end
