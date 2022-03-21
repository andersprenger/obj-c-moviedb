//
//  ViewController.m
//  ObjectiveCMovie
//
//  Created by Giovani Nícolas Bettoni on 21/03/22.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieDBService.h"

@interface ViewController ()

// MARK: - Variables
@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) Movie *selectedMovie;

@end

@implementation ViewController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self loadMovies];
}


- (void)loadMovies {
    
    self.popularMovies = NSMutableArray.new;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [MovieDBService fetchPopularMoviesWithHandler:^(NSMutableArray *movies) {
        
        [self.popularMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
    }];
    
    
    
}


@end
