//
//  DetailsViewController.m
//  ObjectiveCMovie
//
//  Created by Anderson Sprenger on 21/03/22.
//

#import "DetailsViewController.h"
#import "Movie.h"
#import "MovieDBService.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    
    [self fillDetailsWithMovie:self.movie];
    
}


// MARK: - Fill data
- (void)fillDetailsWithMovie:(Movie *)movie {
    
    /// 1. Configure texts
    self.movieTitle.text = movie.title;
    self.overview.text = movie.overview;
    
    /// 2. Parsing float to text
    float roundRatingFloat = roundf(10 * movie.rating.floatValue) / 10;
    NSString *roundedRatingString = [NSString stringWithFormat:@"%.01f",roundRatingFloat];
    self.rating.text = roundedRatingString;
    
}


@end
