//
//  Movie.m
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#import "Movie.h"

@implementation Movie

- (id) initWithDictionary:(NSDictionary *) dictionary {
    
    self = [self init];
    
    if(self) {
        NSString *title = dictionary[@"title"];
        NSString *overview = dictionary[@"overview"];
        NSString *rating = dictionary[@"vote_average"];
        NSString *urlImage = dictionary[@"poster_path"];
        NSArray *genres = dictionary[@"genre_ids"];
        
        self.title = title;
        self.overview = overview;
        self.rating = rating;
        self.urlImage = urlImage;
        self.genres = genres;
    }

    return self;
}

@end

