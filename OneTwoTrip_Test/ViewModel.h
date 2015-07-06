//
//  ViewModel.h
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@protocol ViewModelDelegate <NSObject>

@required
-(void)didSetData;
-(void)didInsertedObjectsAtIndexes:(NSIndexSet *)indexes;
-(void)didRemovedObjectsAtIndexes:(NSIndexSet *)indexes;
-(void)didReplacedObjectsAtIndexes:(NSIndexSet *)indexes;

@end


@interface ViewModel : NSObject <DataSource>

@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong, readonly) NSArray *people; // array of Man objects, KVO-compatible
@property (nonatomic, assign) id<ViewModelDelegate> delegate;


-(instancetype)initWithDataSource:(DataSource *)dataSource;

@end
