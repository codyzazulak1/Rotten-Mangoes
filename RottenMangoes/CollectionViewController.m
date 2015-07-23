//
//  CollectionViewController.m
//  RottenMangoes
//
//  Created by Cody Zazulak on 2015-07-22.
//  Copyright (c) 2015 Cody Zazulak. All rights reserved.
//

#import "CollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "DetailViewController.h"
#import "Movie.h"

@interface CollectionViewController ()

@property NSMutableArray *objects;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"MovieCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objects = [[NSMutableArray alloc] init];
    
    NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=55gey28y6ygcr8fjy4ty87ek&page_limit=50";
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *moviesDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *movies = moviesDict[@"movies"];
            NSMutableArray *moviesArray = [NSMutableArray array];
            for (NSDictionary *eachMovie in movies){
                NSString *title = eachMovie[@"title"];
                NSLog(@"Title: %@", title);
                
                NSDictionary *ratings = eachMovie[@"ratings"];
                NSNumber *score = ratings[@"audience_score"];
                NSLog(@"Rating Score: %@", score);
                
                NSDictionary *posters = eachMovie[@"posters"];
                NSString *imageUrl = posters[@"thumbnail"];
                NSLog(@"Image: %@", imageUrl);
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                
                Movie* aMovie = [[Movie alloc] initWithTitle:title andImage:image andScore:score];
                [moviesArray addObject:aMovie];
                self.objects = moviesArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        }
    }];
    [dataTask resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueToMovieDetail"]) {
        MovieCollectionViewCell *cell = (MovieCollectionViewCell *) sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        Movie *movie = self.objects[indexPath.row];
        DetailViewController *vc = segue.destinationViewController;
        vc.movie = movie;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.objects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Movie *eachMovie = [self.objects objectAtIndex:indexPath.row];
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.movieImageView setImage:eachMovie.image];
    
    // Configure the cell
    
    return cell;
}

@end
