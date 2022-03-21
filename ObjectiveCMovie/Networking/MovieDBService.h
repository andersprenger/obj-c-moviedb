//
//  MovieDBService.h
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#ifndef MovieDBService_h
#define MovieDBService_h

#import "Movie.h"

#endif /* MovieDBService_h */

typedef enum {
    small,
    medium,
    large
} ImageSize;

@interface MovieDBService : NSObject
+ (void) fetchPopularMoviesWithHandler:(void (^)(NSMutableArray *))handler;
+ (NSString *) searchMoviesWithQuery:(NSString *)query;
//+ (void) fetchPopularMoviesWithHandler:(void (^)(NSMutableArray *))handler;
//+ (void) fetchNowPlayingMoviesWithHandler:(void (^)(NSMutableArray *))handler;
//+ (NSURLSessionTask *) fetchMovieImageDataFromPath:(NSString *)movieImagePath andSize:(ImageSize) imageSize andHandler:(void (^)(NSData *))handler;
//+ (NSURLSessionTask *) searchMoviesWithQuery:(NSString *)query andHandler:(void (^)(NSMutableArray *))handler;

@end
