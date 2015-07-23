//
//  DetailViewController.m
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-22.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)setMovie:(Movie *)newMovie {
    if (_movie != newMovie) {
        _movie = newMovie;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.movie) {
        self.titleLabel.text = [[self.movie valueForKey:@"title"] description];
        self.ratingLabel.text = [[self.movie valueForKey:@"score"] description];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleLabel.text = [[self.movie valueForKey:@"title"] description];
    self.ratingLabel.text = [[self.movie valueForKey:@"score"] description];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
