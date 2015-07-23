//
//  MyUtility.h
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-23.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MyUtility : NSObject

+ (void)responseFrom4sq:(CLLocation*)currentLocation categoryId:(NSString*)categoryId limit:(NSString*)limit block:(void (^)(NSArray *locationsArray, NSError *error))completionBlock;

@end