//
//  ViewController.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#define CELL_IDENTIFIER @"cell_identifier"

#import "ViewController.h"
#import "ViewModel.h"
#import "TableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ViewModelDelegate>{
    UITableView * tableView;
    UIView *header;
    UIActivityIndicatorView * preloader;
    ViewModel * _viewModel;
    NSLock * _lockDataSource;
}

@end

@implementation ViewController


-(instancetype)init{
    self = [super init];
    if (self) {
        _viewModel = [[ViewModel alloc] initWithDataSource:[[DataSource alloc] init]];
        _viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configurePreloader];
}


-(void)configureViews{
    //self.view
    self.view.backgroundColor = [UIColor whiteColor];

    //tableView

    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;

    [tableView registerClass:[TableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];

    [self.view addSubview:tableView];
    //active button will be in header
    [self configureTableHeader];

}

-(void)configurePreloader{
    if (_viewModel.active){
        preloader.hidden = NO;
        [preloader startAnimating];
    }else{
        [preloader stopAnimating];
        preloader.hidden = YES;
    }
}

#pragma mark - <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewModel.people ? _viewModel.people.count : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    [cell configureCellWithMan:[_viewModel.people objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - <UITableViewDelegate>
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Active Button
-(void)configureTableHeader{
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    header.backgroundColor = [UIColor whiteColor];

    //adding title
    UILabel * title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"People";
    [title sizeToFit];
    title.center = header.center;
    [header addSubview:title];

    //configuring button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Activate" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(self.view.bounds.size.width - 20 - button.frame.size.width / 2, header.center.y);
    [button addTarget:self action:@selector(activeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];


    preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    preloader.center = CGPointMake(20, header.center.y);
    [header addSubview:preloader];


    [self.view addSubview:header];
    tableView.frame = CGRectMake(0, header.frame.size.height, tableView.frame.size.width, tableView.frame.size.height - header.frame.size.height);
}
-(void)activeButtonTapped{
    _viewModel.active = !_viewModel.active;
    [self configurePreloader];
}



#pragma mark - <ViewModelDelegate>
-(void)didSetData{
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}
-(void)didInsertedObjectsAtIndexes:(NSIndexSet *)indexes{
    NSArray * indexPaths = [self getIndexPathsFromIndexSet:indexes];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}
-(void)didRemovedObjectsAtIndexes:(NSIndexSet *)indexes{
    NSArray * indexPaths = [self getIndexPathsFromIndexSet:indexes];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}
-(void)didReplacedObjectsAtIndexes:(NSIndexSet *)indexes{
    NSArray * indexPaths = [self getIndexPathsFromIndexSet:indexes];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}


-(NSArray *) getIndexPathsFromIndexSet:(NSIndexSet *) set{
    NSMutableArray * indexPaths = [NSMutableArray new];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    return indexPaths;
}


@end
