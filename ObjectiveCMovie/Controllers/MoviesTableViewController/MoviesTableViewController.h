//
//  MoviesTableViewController.h
//  ObjectiveCMovie
//
//  Created by Anderson Sprenger on 21/03/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoviesTableViewController : UITableViewController
<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

NS_ASSUME_NONNULL_END
