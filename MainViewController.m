//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"ABpdO5Bqp2zJtERaNjTrhw";
NSString * const kYelpConsumerSecret = @"g8LyPLAERMARgp6wM5GMFHMTtF0";
NSString * const kYelpToken = @"PRfZidD677C6y9rQcrScedSpYjMut-_y";
NSString * const kYelpTokenSecret = @"0JB61fXdxBFiUU8YuhSJgzF6iPg";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
      
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
  
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell"
                                               bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
  
    self.tableView.rowHeight = UITableViewAutomaticDimension;
  
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterButton)];
  
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 0, 180, 44)];
    self.searchBar.delegate = self;
    self.searchBar.translucent = NO;
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
  cell.business = self.businesses[indexPath.row];
  return cell;
}

#pragma mark - Search delegate methods
//user finished editing the search text
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self handleSearch:searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

- (void)handleSearch:(UISearchBar *)searchBar {
  NSLog(@"Hey neat handling search");
  NSString *newQuery = searchBar.text;
  
  NSLog(@"Hey cool, you searched for: %@", newQuery);
  [self fetchBusinessesWithQuery:newQuery params:nil];
  
}

#pragma mark - Filter delegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
  [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
  NSLog(@"fire new network event: %@", filters);
}

#pragma mark - Private methods

-(void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
  [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
    //NSLog(@"response: %@", response);
    NSArray *businessDictionaries = response[@"businesses"];
    self.businesses = [Business businessesWithDictionaries:businessDictionaries];
    
    [self.tableView reloadData];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error: %@", [error description]);
  }];
}

- (void)onFilterButton {
  FiltersViewController *vc = [[FiltersViewController alloc] init];
  vc.delegate = self;
  
  UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];

  [self presentViewController:nvc animated:YES completion:nil];
}


@end
