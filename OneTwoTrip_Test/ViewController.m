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
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) configureViews{
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
//TODO: implement [cell configureWithMan:[DATASOURCE people][indexPath.row]]
    cell.textLabel.text = @"Name";
    return cell;
}
#pragma mark - <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//TODO: [(TableViewCell *)cell stopObserving];
}


#pragma mark - Active Button
-(void)configureTableHeader{
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    header.backgroundColor = [UIColor whiteColor];
    //adding title
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    title.center = header.center;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"People";
    [header addSubview:title];

    //configuring button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Activate" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(self.view.bounds.size.width - 20 - button.frame.size.width / 2, header.center.y);

    [button addTarget:self action:@selector(activeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];

    [self.view addSubview:header];

    tableView.frame = CGRectMake(0, header.frame.size.height, tableView.frame.size.width, tableView.frame.size.height - header.frame.size.height);
}
-(void)activeButtonTapped{
    DATASOURCE.active = !DATASOURCE.active;
}
@end
