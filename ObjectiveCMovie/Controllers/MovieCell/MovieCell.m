//
//  MovieCell.m
//  ObjectiveCMovie
//
//  Created by Anderson Sprenger on 21/03/22.
//

#import "MovieCell.h"
#import "MovieDBService.h"

@interface MovieCell()


@end

@implementation MovieCell

// MARK: - Constants
+ (NSString *) identifier { return @"MovieCell"; }

// MARK: - Lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureMovieData:(Movie *)movie {
    
    /// 1. Configure texts
    self.title.text = movie.title;
    self.overview.text = movie.overview;
    
    /// 2. Parsing float to text
    float roundRatingFloat = roundf(10 * movie.rating.floatValue) / 10;
    NSString *roundedRatingString = [NSString stringWithFormat:@"%.01f",roundRatingFloat];
    self.rating.text = roundedRatingString;
    
    [MovieDBService fetchPosterOf: movie withHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.poster.image = image;
        });
    }];
}

@end
