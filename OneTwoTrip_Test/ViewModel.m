//
//  ViewModel.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "ViewModel.h"
#import <UIKit/UIKit.h>

@interface ViewModel (){
    BOOL _active;
    NSMutableArray * _people;
    NSLock * _lockPeople;
    NSLock * _lockActive;
    DataSource * _dataSoucre;
}
@end


@implementation ViewModel


-(instancetype)initWithDataSource:(DataSource *)dataSource{
    self = [super init];
    if (self){
        _people = [NSMutableArray new];
        _lockPeople = [NSLock new];
        _lockActive = [NSLock new];
        _dataSoucre = dataSource;
        [_dataSoucre addObserver:self forKeyPath:@"people" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)dealloc{
    [_dataSoucre removeObserver:self forKeyPath:@"people"];
}


#pragma mark - _people KVC

-(void) insertObject:(id)object inPeopleAtIndex:(NSUInteger)index{
    [_lockPeople lock];
    [_people insertObject:object atIndex:index];
    [_lockPeople unlock];
}
-(void)insertPeople:(NSArray *)array atIndexes:(NSIndexSet *)indexes{
    [_lockPeople lock];
    [_people insertObjects:array atIndexes:indexes];
    [_lockPeople unlock];
}

-(void)removeObjectFromPeopleAtIndex:(NSUInteger)index{
    [_lockPeople lock];
    [_people removeObjectAtIndex:index];
    [_lockPeople unlock];
}
-(void)removePeopleAtIndexes:(NSIndexSet *)indexes{
    [_lockPeople lock];
    [_people removeObjectsAtIndexes:indexes];
    [_lockPeople unlock];
}
-(void)replaceObjectInPeopleAtIndex:(NSUInteger)index withObject:(id)object{
    [_lockPeople lock];
    [_people replaceObjectAtIndex:index withObject:object];
    [_lockPeople unlock];
}
-(void)replacePeopleAtIndexes:(NSIndexSet *)indexes withPeople:(NSArray *)array{
    [_lockPeople lock];
    [_people replaceObjectsAtIndexes:indexes withObjects:array];
    [_lockPeople unlock];
}

-(id)objectInPeopleAtIndex:(NSUInteger)index{
    id object;
    [_lockPeople lock];
    object = [_people objectAtIndex:index];
    [_lockPeople unlock];
    return object;
}

-(NSArray * )people{
    NSArray * people;
    [_lockPeople lock];
    people = _people;
    [_lockPeople unlock];
    return people;
}
-(void)setPeople:(NSArray *)people{
    [_lockPeople lock];
    _people = [NSMutableArray arrayWithArray:people];
    [_lockPeople unlock];
}

#pragma mark - _active KVC
-(BOOL)active{
    BOOL acitve;
    [_lockActive lock];
    acitve = _active;
    [_lockActive unlock];
    return acitve;
}

-(void)setActive:(BOOL)active{
    [_lockActive lock];
    if (_active != active)  {
        _active = active;
        _dataSoucre.active = _active;
    }
    [_lockActive unlock];
}


#pragma mark - DATASOURCE KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"people"]){
        //setting
        NSArray * newObjects = [change objectForKey:NSKeyValueChangeNewKey];
        NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
        NSArray * indexPaths = [self getIndexPathsFromIndexSet:indexes];
        switch ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue]) {
            case NSKeyValueChangeSetting:
                [self setPeople:newObjects];
                if (self.delegate) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didSetData];
                    });
                }
                break;
            case NSKeyValueChangeInsertion:
                [self insertPeople:newObjects atIndexes:indexes];
                if (self.delegate) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didInsertedObjectsAtIndexPaths:indexPaths];
                    });
                }
                break;
            case NSKeyValueChangeRemoval:
                [self removePeopleAtIndexes:indexes];
                if (self.delegate) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didRemovedObjectsAtIndexPaths:indexPaths];
                    });
                }

                break;
            case NSKeyValueChangeReplacement:
                [self replacePeopleAtIndexes:indexes withPeople:newObjects];
                if (self.delegate) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didReplacedObjectsAtIndexPaths:indexPaths];
                    });
                }

                break;

            default:
                break;
        }

    }
}

-(NSArray *) getIndexPathsFromIndexSet:(NSIndexSet *) set{
    NSMutableArray * indexPaths = [NSMutableArray new];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    return indexPaths;
}




@end
