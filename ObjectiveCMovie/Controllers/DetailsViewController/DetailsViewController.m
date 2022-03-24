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
    
    NSMutableString *genresText = [NSMutableString stringWithCapacity: 50];
    
    for (NSNumber *genre in movie.genres) {
        NSString *genreFound = _genresDictionary[genre];
        
        if (genreFound != nil) {
            [genresText appendString: genreFound];
            [genresText appendString: @", "];
        }
    }
    
    if (genresText.length > 0) {
        [genresText deleteCharactersInRange: NSMakeRange(genresText.length - 2, 2)];
    }
    
    self.genres.text = genresText;
    
    [MovieDBService fetchPosterOf:movie withHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.poster.image = image;
        });
    }];
}


@end
