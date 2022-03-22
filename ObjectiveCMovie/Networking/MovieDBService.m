//
//  MovieDBService.m
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#import <Foundation/Foundation.h>
#import "MovieDBService.h"

@interface MovieDBService()

@end

static NSCache *imageCache;

@implementation MovieDBService

NSString *popularMoviesBaseUrl = @"https://api.themoviedb.org/3/movie/popular?api_key=a23088f8339f956b04f1b7064ddd50f8";
NSString *nowPlayingMoviesBaseUrl = @"https://api.themoviedb.org/3/movie/now_playing?api_key=a23088f8339f956b04f1b7064ddd50f8";
NSString *searchUrl = @"https://api.themoviedb.org/3/search/movie?api_key=a23088f8339f956b04f1b7064ddd50f8";
NSString *baseImageURL = @"https://image.tmdb.org/t/p/";


+ (NSString *) searchURLWithQuery:(NSString *)query {
    return [NSString stringWithFormat:@"%@&query=%@", searchUrl, query];
}

+ (NSURLSessionTask *) searchForMovieWithQuery:(NSString *)query andHandler:(void (^)(NSMutableArray *))handler {
    
    NSLog(@"Searching for movies with query: %@", query);
    
    NSString *charactersToEscape = @"!*';:()@&^,+$/?%#[]<> ";
    
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape]invertedSet];
    NSString *encodedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSURL *url = [NSURL URLWithString: [self searchURLWithQuery:encodedQuery]];
    NSLog(@"Sending request: %@", url);
    
    NSURLSessionTask *session = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data == nil) return;
        
        NSLog(@"S>Did receive API data.");
        
        // TODO: - Comment these lines.
        //NSString *jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Response %@", jsonResponse);
    
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err) {
            NSLog(@"S>Failed to serialize data into JSON: %@", err);
            handler(NSMutableArray.new);
            return;
        }
        
        NSArray *moviesDictionaryArray = resultJSON[@"results"];
        NSLog(@"S>Did serialize data into JSON.");
        
        NSMutableArray *movies = NSMutableArray.new;
        for (NSDictionary *movieDictionary in moviesDictionaryArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [movies addObject:movie];
        }
        
        NSLog(@"S>Did fetch json into movies array.");
        handler(movies);
    
    }];
    
    [session resume];
    return session;
}

+ (void) fetchNowPlayingMoviesWithHandler:(void (^)(NSMutableArray *))handler {
    NSLog(@"Searching for now playing movies");
    
    NSURL *url = [NSURL URLWithString:nowPlayingMoviesBaseUrl];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Did receive API data.");
        
        // TODO: - Comment these lines.
        //NSString *jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Response %@", jsonResponse);
    
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err) {
            NSLog(@"Failed to serialize data into JSON: %@", err);
            handler(NSMutableArray.new);
            return;
        }
        
        NSArray *moviesDictionaryArray = resultJSON[@"results"];
        NSLog(@"Did serialize data into JSON.");
        
        NSMutableArray *movies = NSMutableArray.new;
        for (NSDictionary *movieDictionary in moviesDictionaryArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [movies addObject:movie];
        }
        
        NSLog(@"Did fetch json into movies array.");
        handler(movies);
    
    }] resume];
}

+ (void) fetchPopularMoviesWithHandler:(void (^)(NSMutableArray *))handler {
    NSLog(@"Searching for popular movies");
    
    NSURL *url = [NSURL URLWithString:popularMoviesBaseUrl];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Did receive API data.");
        
        // TODO: - Comment these lines.
        //NSString *jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"Response %@", jsonResponse);
    
        NSError *err;
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err) {
            NSLog(@"Failed to serialize data into JSON: %@", err);
            handler(NSMutableArray.new);
            return;
        }
        
        NSArray *moviesDictionaryArray = resultJSON[@"results"];
        NSLog(@"Did serialize data into JSON.");
        
        NSMutableArray *movies = NSMutableArray.new;
        for (NSDictionary *movieDictionary in moviesDictionaryArray) {
            Movie *movie = Movie.new;
            movie = [movie initWithDictionary:movieDictionary];
            
            [movies addObject:movie];
        }
        
        NSLog(@"Did fetch json into movies array.");
        handler(movies);
    
    }] resume];
}

@end
