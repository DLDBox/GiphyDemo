//
//  GiphyTableViewController.m
//  GiphyDemo
//
//  Created by Dana Devoe on 5/16/16.
//  Copyright © 2016 Dana Devoe. All rights reserved.
//

#import "GiphyTableViewController.h"
#import "GiphyViewController.h"
#import "GiphyQueryResultModel.h"
#import "GiphyAPI.h"

@interface GiphyTableViewController()<UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *giphyAPISelectSeg;
@property (nonatomic,strong) GiphyAPI* api;

@property (nonatomic, strong) NSArray<GiphyModel *> *giphyList;

@end

@implementation GiphyTableViewController

#pragma mark - Lazy Initializer
- (GiphyAPI *)api
{
    if ( _api == nil ) {
        _api = [[GiphyAPI alloc]init];
    }
    return _api;
}

// I am having to manually place the searchbar due to
// XLForm, which seem to be preventing it from displaying
- (UISearchBar *)searchBar
{
    if ( _searchBar == nil ) {
        CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 42);
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
        _searchBar = searchBar;
        [self.view addSubview:searchBar];
    }
    return _searchBar;
}

#pragma mark - Initialization Methods
- (void) configureView
{
    XLFormDescriptor *formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"Giphy"];
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSection];
    
    for ( GiphyModel *giphyModel in self.giphyList )
    {
        __block XLFormRowDescriptor *row;
        row = [XLFormRowDescriptor formRowDescriptorWithTag:nil
                                                    rowType:XLFormRowDescriptorTypeImage ];
        
        row.title = giphyModel.slug;
        __weak __typeof(self) weakSelf = self;
        
        [self.api loadImageFromGiphy:giphyModel.images.fixed_width.url withCompletion:^(UIImage *theImage,NSError *error){
            row.value = theImage;
            [weakSelf.tableView reloadData];
        }];
        
        [section addFormRow:row];
    }
    
    [formDescriptor addFormSection:section];
    self.form = formDescriptor;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(70,0,0,0);
    self.searchBar.delegate = self;
    
    __weak __typeof(self) weakSelf = self;
    [self.api trendingWithCompletion:^(NSArray<GiphyModel *> *gifs, NSError *error){
        _giphyList = gifs;
        [weakSelf configureView];
    }];

    self.title = @"Trending";
}

#pragma mark - <UISearchBarDelegate> Method
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _giphyList = nil;
    [self configureView];
    [self.tableView reloadData];
    return TRUE;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return TRUE;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *terms = self.searchBar.text;
    __weak __typeof(self) weakSelf = self;

    self.title = terms;
    
    [self.api search:terms completion:^(NSArray<GiphyModel *> *gifs, NSError *error){
        _giphyList = gifs;
        dispatch_async(dispatch_get_main_queue(), ^(){
            [weakSelf configureView];
            [weakSelf.tableView reloadData];
            [weakSelf.searchBar resignFirstResponder];
        });
    }];
}

#pragma mark - <UITableViewDelegate> Method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GiphyViewController *giphyViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"GiphyViewController"];
    
    [self.api loadImageFromGiphy:self.giphyList[indexPath.row].images.original.url withCompletion:^(UIImage *theImage,NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^(){
            giphyViewController.giphyImage.image = theImage;
            giphyViewController.url = self.giphyList[indexPath.row].images.original.url;
            
            // animation timing adjustment for the UIActivity view which will not stop on some gif which load
            // faster than the view animation
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [giphyViewController.activity stopAnimating];
            });
        });
    }];
    
    [self.navigationController pushViewController:giphyViewController animated:YES];
}

@end
