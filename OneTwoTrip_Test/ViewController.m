//
//  ViewController.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#define CELL_IDENTIFIER @"cell_identifier"

#import "ViewController.h"
#import "DataSource.h"
#import "TableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>{
    UITableView * tableView;
    UIView *header;
    UIActivityIndicatorView * preloader;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureViews];
    [self configureDataSource];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configurePreloader];
}
-(void)viewWillDisappear:(BOOL)animated{
    [DATASOURCE removeObserver:self forKeyPath:@"people"];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (DATASOURCE.active){
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
    if ([DATASOURCE people]){
        return [[DATASOURCE people] count];
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    [cell configureCellWithMan:[DATASOURCE people][indexPath.row]];
    return cell;
}
#pragma mark - <UITableViewDelegate>


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
    DATASOURCE.active = !DATASOURCE.active;
    [self configurePreloader];
}

#pragma mark - DATASOURCE
-(void)configureDataSource{
    [DATASOURCE addObserver:self forKeyPath:@"people" options:NSKeyValueObservingOptionNew context:nil];
    DATASOURCE.active = YES;
}

#pragma mark - DATASOURCE KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"people"]){
        if ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue] == NSKeyValueChangeInsertion){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            NSMutableArray * indexPaths = [NSMutableArray new];
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{

                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [self configurePreloader];
            });
        }
        if ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue] == NSKeyValueChangeRemoval){
            NSIndexSet * indexSet = [change objectForKey:NSKeyValueChangeIndexesKey];
            NSMutableArray * indexPaths = [NSMutableArray new];
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }];
            NSLog(@"deleting at index = %d",[(NSIndexPath *)indexPaths[0] row]);
            dispatch_async(dispatch_get_main_queue(), ^{

                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                [self configurePreloader];
            });
        }
    
        
    }
}

@end
