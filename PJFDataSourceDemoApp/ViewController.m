//
//  ViewController.m
//  PJFTestApplication
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "ViewController.h"

#import "ColorsDataSource.h"
#import "ColorsLoader.h"

#import "PJFLoadingCoordinator.h"
#import "PJFContentWrapperView.h"
#import "PJFImageTitleMessageView.h"
#import "PJFLoadingView.h"
#import "PJFAction.h"


@interface ViewController () <PJFDataSourceDelegate, PJFContentWrapperViewDelegate>

@property (nonatomic) PJFContentWrapperView *contentWrapperView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) ColorsLoader *colorsLoader;
@property (nonatomic) ColorsDataSource *dataSource;

@property (nonatomic) UIView *buttonsContainer;
@property (nonatomic) UIButton *loadSuccessButton;
@property (nonatomic) UIButton *loadEmptyButton;
@property (nonatomic) UIButton *loadErrorButton;

@end


@implementation ViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.colorsLoader = [[ColorsLoader alloc] init];
    self.dataSource = [[ColorsDataSource alloc] initWithDelegate:self colorsLoader:self.colorsLoader];
    
    self.buttonsContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.buttonsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.buttonsContainer];
    
    self.loadSuccessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loadSuccessButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadSuccessButton setTitle:@"Success" forState:UIControlStateNormal];
    [self.loadSuccessButton addTarget:self action:@selector(_loadSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsContainer addSubview:self.loadSuccessButton];
    
    self.loadEmptyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loadEmptyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadEmptyButton setTitle:@"Empty" forState:UIControlStateNormal];
    [self.loadEmptyButton addTarget:self action:@selector(_loadEmpty:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsContainer addSubview:self.loadEmptyButton];
    
    self.loadErrorButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loadErrorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadErrorButton setTitle:@"Error" forState:UIControlStateNormal];
    [self.loadErrorButton addTarget:self action:@selector(_loadError:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsContainer addSubview:self.loadErrorButton];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.contentWrapperView = [[PJFContentWrapperView alloc] initWithFrame:CGRectZero contentView:self.tableView];
    self.contentWrapperView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentWrapperView.delegate = self;
    [self.view addSubview:self.contentWrapperView];

    [self _setUpConstraints];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self _loadSuccess:self];
}

#pragma mark - Test Button Actions

- (void)_loadSuccess:(id)sender;
{
    self.colorsLoader.nextResponseType = ColorsLoaderNextResponseTypeSuccess;
    [self.dataSource loadContent];
}

- (void)_loadEmpty:(id)sender;
{
    self.colorsLoader.nextResponseType = ColorsLoaderNextResponseTypeEmpty;
    [self.dataSource loadContent];
}

- (void)_loadError:(id)sender;
{
    self.colorsLoader.nextResponseType = ColorsLoaderNextResponseTypeError;
    [self.dataSource loadContent];
}

#pragma mark - PJFDataSourceDelegate

- (PJFContentWrapperView *)contentWrapperViewForDataSource:(PJFDataSource *)dataSource;
{
    return self.contentWrapperView;
}

- (void)dataSourceDidFinishLoading:(PJFDataSource *)dataSource withError:(NSError *)error;
{
    [self.tableView reloadData];
}

#pragma mark - PJFContentWrapperViewDelegate

- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView willShowNoContentView:(PJFImageTitleMessageView *)placeholderView;
{
    placeholderView.title = @"Test";
    placeholderView.message = @"This is a longer message.  It contains some information. Or not. Up to you, you know?";
    placeholderView.action = [PJFAction actionWithTitle:@"Action" selector:@selector(actionPressed:)];
}

- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView willShowErrorView:(PJFImageTitleMessageView *)placeholderView withError:(NSError *)error;
{
    placeholderView.title = @"Oops!";
    placeholderView.message = [NSString stringWithFormat:@"Sorry, an error occurred. I could give you more info about this particular error. For example, the hex address is %p.", error];
    placeholderView.action = [PJFAction actionWithTitle:@"Error Action" selector:@selector(errorPressed:)];
}

#pragma mark - Placeholder View Button Actions

- (void)actionPressed:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Action button pressed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)errorPressed:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Error button pressed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Private Methods

- (void)_setUpConstraints;
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentWrapperView, _buttonsContainer, _loadSuccessButton, _loadEmptyButton, _loadErrorButton);

    [self.buttonsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_loadSuccessButton][_loadEmptyButton(==_loadSuccessButton)][_loadErrorButton(==_loadEmptyButton)]|" options:0 metrics:nil views:views]];
    [self.buttonsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_loadSuccessButton]|" options:0 metrics:nil views:views]];
    [self.buttonsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_loadEmptyButton]|" options:0 metrics:nil views:views]];
    [self.buttonsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_loadErrorButton]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentWrapperView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonsContainer]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_buttonsContainer(60)][_contentWrapperView]|" options:0 metrics:nil views:views]];
}

@end
