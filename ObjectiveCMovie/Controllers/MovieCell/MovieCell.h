//
//  MovieCell.h
//  ObjectiveCMovie
//
//  Created by Anderson Sprenger on 21/03/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - Outlets
@interface MovieCell : UITableViewCell

// MARK: - Constants
+ (NSString *) identifier;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *overview;

// MARK: - Method to configure movieData
- (void)configureMovieData:(Movie *) movie;

@end

NS_ASSUME_NONNULL_END
