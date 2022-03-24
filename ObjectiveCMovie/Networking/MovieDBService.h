//
//  MovieDBService.h
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#ifndef MovieDBService_h
#define MovieDBService_h

#import "Movie.h"

#endif

@interface MovieDBService: NSObject

@property (nonatomic) NSCache *posterCache;

+ (void) fetchPopularMoviesWithHandler:(void (^)(NSMutableArray *))handler;
+ (void) fetchNowPlayingMoviesWithHandler:(void (^)(NSMutableArray *))handler;
+ (NSString *) searchURLWithQuery:(NSString *)query;
+ (NSDictionary *) fetchGenres;
+ (void) fetchPosterOf: (Movie *) movie withHandler:(void (^)(UIImage * image)) handler ;
+ (NSURLSessionTask *) searchForMovieWithQuery:(NSString *)query andHandler:(void (^)(NSMutableArray *))handler;
+ (NSURLSessionTask *) fetchMoviesWithHandler: (NSURL *) url andHandler: (void (^) (NSMutableArray *)) handler;
+ (NSCache *) imageCache;

@end
