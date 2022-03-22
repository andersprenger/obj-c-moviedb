//
//  MoviesTableViewController.m
//  ObjectiveCMovie
//
//  Created by Anderson Sprenger on 21/03/22.
//

#import "MoviesTableViewController.h"
#import "MovieDBService.h"
#import "Movie.h"

@interface MoviesTableViewController ()

@property (strong, nonatomic) NSMutableArray<Movie *> *popularMovies;
@property (strong, nonatomic) Movie *selectedMovie;

@property (strong, nonatomic) UISearchController *searchBarController;
@property (nonatomic) BOOL showldDisplaySearch;

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
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [MovieDBService fetchPopularMoviesWithHandler:^(NSMutableArray *movies) {
        [self.popularMovies addObjectsFromArray:movies];
        dispatch_group_leave(group);
    }];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.showldDisplaySearch) {
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
    return 2; // MovieCell & HeaderCell
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"show-details" sender: self];
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

@end
