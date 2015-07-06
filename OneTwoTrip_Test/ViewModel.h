//
//  ViewModel.h
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ViewModelDelegate;
@protocol DataSource;

@interface ViewModel : NSObject

@property (nonatomic) BOOL active;
@property (nonatomic, strong, readonly) NSArray *people;
@property (nonatomic, weak) id<ViewModelDelegate> delegate;


-(instancetype)initWithDataSource:(id<DataSource>)dataSource;
-(NSString *)nameAtIndex:(NSUInteger)index;
@end

@protocol ViewModelDelegate <NSObject>

@required
-(void)viewModelDidSetData:(ViewModel *)viewModel;
-(void)viewModel:(ViewModel *)viewModel didInsertObjectsAtIndexes:(NSIndexSet *)indexes;
-(void)viewModel:(ViewModel *)viewModel didRemoveObjectsAtIndexes:(NSIndexSet *)indexes;
-(void)viewModel:(ViewModel *)viewModel didReplaceObjectsAtIndexes:(NSIndexSet *)indexes;

@end



