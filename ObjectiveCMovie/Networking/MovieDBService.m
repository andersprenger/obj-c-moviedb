//
//  MovieDBService.m
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#import <UIKit/UIKit.h>
#import "MovieDBService.h"

@interface MovieDBService()

@end

static NSCache *imageCache;

@implementation MovieDBService

NSString *popularMoviesBaseUrl = @"https://api.themoviedb.org/3/movie/popular?api_key=a23088f8339f956b04f1b7064ddd50f8";
NSString *nowPlayingMoviesBaseUrl = @"https://api.themoviedb.org/3/movie/now_playing?api_key=a23088f8339f956b04f1b7064ddd50f8";
NSString *searchUrl = @"https://api.themoviedb.org/3/search/movie?api_key=a23088f8339f956b04f1b7064ddd50f8";
NSString *baseImageURL = @"https://image.tmdb.org/t/p/original";
NSString *genresURL = @"https://api.themoviedb.org/3/genre/movie/list?api_key=a23088f8339f956b04f1b7064ddd50f8";

+ (NSDictionary *) fetchGenres {
    NSURL *url = [NSURL URLWithString: genresURL];
    NSMutableDictionary *genres = [[NSMutableDictionary alloc] initWithCapacity: 20];
    
    [[NSURLSession.sharedSession dataTaskWithURL: url
                               completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) {
            return;
        }
        
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &err];
        
        if (err) {
            NSLog(@"S>Failed to serialize data into JSON: %@", err);
        }
        
        NSArray *genresJSON = resultJSON[@"genres"];
        
        for (NSDictionary *genre in genresJSON) {
            [genres setObject: genre[@"name"] forKey: genre[@"id"]];
        }
    }] resume];
    
    return genres;
}

+ (void) fetchPosterOf: (Movie *) movie withHandler:(void (^) (UIImage * image)) handler {
    NSMutableString *urlString = [NSMutableString stringWithCapacity: 50];
    [urlString appendString: baseImageURL];
    [urlString appendString: movie.urlImage];
    
    NSURL *url = [NSURL URLWithString: urlString];
    [[NSURLSession.sharedSession dataTaskWithURL: url
                               completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data == nil) return;
        
        UIImage *loadedImage = [UIImage imageWithData: data];
        
        handler(loadedImage);
        
    }] resume];
}

+ (NSString *) searchURLWithQuery:(NSString *) query {
    return [NSString stringWithFormat:@"%@&query=%@", searchUrl, query];
}

+ (NSURLSessionTask *) fetchMoviesWithHandler: (NSURL *) url andHandler: (void (^) (NSMutableArray *)) handler {
    NSURLSessionTask *session = [NSURLSession.sharedSession dataTaskWithURL: url
                                 completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &err];
        
        if (err) {
            handler(NSMutableArray.new);
            return;
        }
        
        NSArray *moviesDictionaryArray = resultJSON[@"results"];
        
        NSMutableArray *movies = NSMutableArray.new;
        for (NSDictionary *movieDictionary in moviesDictionaryArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [movies addObject: movie];
        }
        
        handler(movies);
    }];
    
    [session resume];
    
    return session;
}

+ (void) fetchNowPlayingMoviesWithHandler: (void (^) (NSMutableArray *)) handler {
    NSURL *url = [NSURL URLWithString: nowPlayingMoviesBaseUrl];
    [self fetchMoviesWithHandler: url andHandler: handler];
}

+ (void) fetchPopularMoviesWithHandler: (void (^) (NSMutableArray *)) handler {
    NSURL *url = [NSURL URLWithString: popularMoviesBaseUrl];
    [self fetchMoviesWithHandler: url andHandler: handler];
}

+ (NSURLSessionTask *) searchForMovieWithQuery: (NSString *) query andHandler: (void (^)(NSMutableArray *)) handler {
    NSString *charactersToEscape = @"!*';:()@&^,+$/?%#[]<> ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape]invertedSet];
    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSURL *url = [NSURL URLWithString: [self searchURLWithQuery:encodedQuery]];
    
    return [self fetchMoviesWithHandler: url andHandler: handler];
}

@end
