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
        NSString *rating = dictionary[@"rating"];
        NSString *urlImage = dictionary[@"urlImage"];
        
        self.title = title;
        self.overview = overview;
        self.rating = rating;
        self.urlImage = urlImage;
    }

    return self;
}

@end

