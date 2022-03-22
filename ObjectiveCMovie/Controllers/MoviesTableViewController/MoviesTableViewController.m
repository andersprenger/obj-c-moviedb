//
//  MoviesTableViewController.m
//  ObjectiveCMovie
//
//  Created by Anderson Sprenger on 21/03/22.
//

#import "MoviesTableViewController.h"
#import "DetailsViewController.h"
#import "MovieDBService.h"
#import "MovieCell.h"
#import "Movie.h"

@interface MoviesTableViewController ()

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *nowPlayingMovies;
@property (strong, nonatomic) NSMutableArray<Movie *> *searchedMovies;
@property (strong, nonatomic) Movie *selectedMovie;

@property (strong, nonatomic) UISearchController *searchBarController;
@property (nonatomic) BOOL shouldDisplaySearch;
@property (strong, nonatomic) NSURLSessionTask *currentSearchingTask;

@end

@implementation MoviesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Movies";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    
    [self setupLayout];
    
    [self setupSearchBar];
    
    [self loadMovies];
}

- (void)setupLayout {
    self.view.backgroundColor = UIColor.secondarySystemBackgroundColor;

}

- (void)setupSearchBar {
    /// 1. Create searchbar
    self.searchBarController = UISearchController.new;
    
    /// 2. Sets searchbar appearence and behaiviour
    [self.searchBarController.searchBar sizeToFit];
    self.searchBarController.searchBar.searchTextField.backgroundColor = UIColor.quaternarySystemFillColor;
    self.searchBarController.obscuresBackgroundDuringPresentation = false;
    self.searchBarController.hidesNavigationBarDuringPresentation = true;
    self.searchBarController.searchBar.searchTextField.clearButtonMode = UITextFieldViewModeNever;
    self.searchBarController.searchBar.returnKeyType = UIReturnKeyDone;
    
    /// 3. Sets searchbar delegates
    self.searchBarController.searchBar.delegate = self;
    self.searchBarController.searchBar.searchTextField.delegate = self;
    
    /// 4. Add searchbar to navigation
    self.navigationItem.searchController = self.searchBarController;
}


- (void)loadMovies {
    self.popularMovies = NSMutableArray.new;
    self.nowPlayingMovies = NSMutableArray.new;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [MovieDBService fetchPopularMoviesWithHandler:^(NSMutableArray *movies) {
        [self.popularMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [MovieDBService fetchNowPlayingMoviesWithHandler:^(NSMutableArray *movies) {
        [self.nowPlayingMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.shouldDisplaySearch = NO;
        [self.tableView reloadData];
    });
}

- (void)searchForMovieWithQuery:(NSString *)query {
    
    [self.currentSearchingTask cancel];
    
    self.searchedMovies = NSMutableArray.new;
    [self.searchBarController.searchBar setShowsCancelButton:YES animated:YES];
    
    self.currentSearchingTask = [MovieDBService searchForMovieWithQuery:query
                                                          andHandler:^(NSMutableArray *movies) {
        [self.searchedMovies addObjectsFromArray:movies];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shouldDisplaySearch = YES;
            [self.tableView reloadData];
        });
    }];
}

- (void)cancelSearching {
    [self.currentSearchingTask cancel];
    self.searchedMovies = NSMutableArray.new;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.shouldDisplaySearch = NO;
        [self.tableView reloadData];
    });
    return;
}

//MARK: - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.shouldDisplaySearch) {
        return @"Results";
    } else {
        switch (section) {
            case 0:
                return @"Popular Movies";
            case 1:
                return @"Now Playing";
            default:
                return @"";
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.shouldDisplaySearch)
        return 1;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.shouldDisplaySearch) {
        return self.searchedMovies.count;
    } else {
        switch (section) {
            case 0:
                return self.popularMovies.count;
            case 1:
                return self.nowPlayingMovies.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:[MovieCell identifier] forIndexPath:indexPath];
    
    NSMutableArray *movies;
    
    if (self.shouldDisplaySearch) {
        movies = self.searchedMovies;
    } else {
        switch (indexPath.section) {
            case 0: movies = self.popularMovies;
            case 1: movies = self.nowPlayingMovies;
        }
    }
    Movie *movie = movies[indexPath.row];
    
    [cell configureMovieData:movie];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *movies;
    
    if (self.shouldDisplaySearch) {
        movies = self.searchedMovies;
    } else {
        switch (indexPath.section) {
            case 0: movies = self.popularMovies;
            case 1: movies = self.nowPlayingMovies;
        }
    }
    Movie *selectedMovie = movies[indexPath.row];
    self.selectedMovie = selectedMovie;
    [self performSegueWithIdentifier:@"show-details" sender: self];
}

// MARK: - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *movieDetailViewController = [segue destinationViewController];
    movieDetailViewController.movie = self.selectedMovie;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// MARK: - SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBarController.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBarController.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBarController.searchBar.text = @"";
    [self cancelSearching];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self cancelSearching];
        return;
    }
    
    [self searchForMovieWithQuery:searchText];
}

@end
