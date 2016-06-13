//
//  ColorsDataSource.m
//  PJFTestApplication
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "ColorsDataSource.h"

#import "PJFLoadingCoordinator.h"
#import "ColorsLoader.h"

@interface ColorsDataSource ()

@property (nonatomic) ColorsLoader *colorsLoader;

@end

@implementation ColorsDataSource

- (instancetype)initWithDelegate:(id <PJFDataSourceDelegate>)delegate colorsLoader:(ColorsLoader *)colorsLoader;
{
    self = [super initWithDelegate:delegate];
    if (!self) {
        return nil;
    }

    _colorsLoader = colorsLoader;

    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ColorCell"];
    if (!cell) {
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ColorCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ColorCell"];
    }

    cell.backgroundColor = [self _colorForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Public Methods

- (void)loadContent;
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.loadingCoordinator loadContentWithBlock:^(PJFLoadingState *loadingState) {
        [self.colorsLoader asyncLoadColorsWithSuccess:^(NSArray *colors) {
            if ([loadingState hasBeenSuperseded]) {
                return;
            }
            
            self.colors = colors;
            
            [self.loadingCoordinator loadContentDidFinishWithError:nil];
            
        } error:^(NSError *error) {
            if ([loadingState hasBeenSuperseded]) {
                return;
            }
            
            NSLog(@"*** OOOF, GOT AN ERROR: %@", error);
            [self.loadingCoordinator loadContentDidFinishWithError:error];
            
        }];
    }];
}

- (BOOL)hasContent;
{
    return self.colors.count > 0;
}

#pragma mark - Private Methods

- (UIColor *)_colorForIndexPath:(NSIndexPath *)indexPath;
{
    return [self.colors objectAtIndex:indexPath.row];
}

@end
