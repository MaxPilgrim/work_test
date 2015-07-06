//
//  ViewModel.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "ViewModel.h"
#import "DataSource.h"
#import "Man.h"

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
        [_dataSource addObserver:self forKeyPath:@"people" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)dealloc{
    _dataSource.active = NO;
    [_dataSource removeObserver:self forKeyPath:@"people"];
    [_dataSource.people enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Man * man = (Man *)obj;
        [man removeObserver:self forKeyPath:@"name"];
    }];
}


-(void)setActive:(BOOL)active{
    if (_active != active)  {
        _active = active;
        _dataSource.active = _active;
    }
}

-(NSString *)nameAtIndex:(NSUInteger)index{
    NSString * name = [_people[index] isKindOfClass:[NSNull class]] ? nil : _people[index];
    return name;
}

#pragma mark - DATASOURCE KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if ([keyPath isEqualToString:@"people"]){
        //Man KVO updating
        NSArray * newObjects = [change objectForKey:NSKeyValueChangeNewKey];
        NSMutableArray * newNames = [NSMutableArray new];
        [newObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Man * man = (Man *)obj;
            [man addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
            [newNames addObject:man.name ? man.name : [NSNull null]];
        }];
        NSArray * oldObjects = [change objectForKey:NSKeyValueChangeOldKey];
        [oldObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Man * man = (Man *)obj;
            [man removeObserver:self forKeyPath:@"name"];
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate){
                NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];

                switch ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue]) {
                    case NSKeyValueChangeSetting:
                        _people = [NSMutableArray arrayWithArray:newNames];
                        [self.delegate viewModelDidSetData:self];
                        break;
                    case NSKeyValueChangeInsertion:
                        [_people insertObjects:newNames atIndexes:indexes];
                        [self.delegate viewModel:self didInsertObjectsAtIndexes:indexes];
                        break;
                    case NSKeyValueChangeRemoval:
                        [_people removeObjectsAtIndexes:indexes];
                        [self.delegate viewModel:self didRemoveObjectsAtIndexes:indexes];
                        break;
                    case NSKeyValueChangeReplacement:
                        [_people replaceObjectsAtIndexes:indexes withObjects:newNames];
                        [self.delegate viewModel:self didReplaceObjectsAtIndexes:indexes];
                        break;
                    default:
                        break;
                }
            }
        });
        
    }

    //Man KVO
    if ([keyPath isEqualToString:@"name"]){
        NSUInteger idx = [_dataSource.people indexOfObject:object];
        id name = [change objectForKey:NSKeyValueChangeNewKey];
        if (idx != NSNotFound){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate){
                    _people[idx] = name;
                    [self.delegate viewModel:self didReplaceObjectsAtIndexes:[NSIndexSet indexSetWithIndex:idx]];
                }
            });
        }
        
    }
    
}





@end
