//
//  ViewModel.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "ViewModel.h"
#import "DataSource.h"

@interface ViewModel (){
    BOOL _active;
    NSMutableArray * _people;
    DataSource * _dataSource;
}
@end


@implementation ViewModel


-(instancetype)initWithDataSource:(id<DataSource>)dataSource{
    self = [super init];
    if (self){
        _people = [NSMutableArray new];
        _dataSource = dataSource;
        [_dataSource addObserver:self forKeyPath:@"people" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)dealloc{
    [_dataSource removeObserver:self forKeyPath:@"people"];
}


-(void)setActive:(BOOL)active{
    if (_active != active)  {
        _active = active;
        _dataSource.active = _active;
    }
}


#pragma mark - DATASOURCE KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"people"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate){
                NSArray * newObjects = [change objectForKey:NSKeyValueChangeNewKey];
                NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];

                switch ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue]) {
                    case NSKeyValueChangeSetting:
                        _people = [NSMutableArray arrayWithArray:newObjects];
                        [self.delegate viewModelDidSetData:self];
                        break;
                    case NSKeyValueChangeInsertion:
                        [_people insertObjects:newObjects atIndexes:indexes];
                        [self.delegate viewModel:self didInsertObjectsAtIndexes:indexes];
                        break;
                    case NSKeyValueChangeRemoval:
                        [_people removeObjectsAtIndexes:indexes];
                        [self.delegate viewModel:self didRemoveObjectsAtIndexes:indexes];
                        break;
                    case NSKeyValueChangeReplacement:
                        [_people replaceObjectsAtIndexes:indexes withObjects:newObjects];
                        [self.delegate viewModel:self didReplaceObjectsAtIndexes:indexes];
                        break;
                    default:
                        break;
                }
            }
        });
        
    }
    
}





@end
