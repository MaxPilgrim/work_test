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
    DataSource * _dataSoucre;
}
@end


@implementation ViewModel


-(instancetype)initWithDataSource:(DataSource *)dataSource{
    self = [super init];
    if (self){
        _people = [NSMutableArray new];
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
    [_people insertObject:object atIndex:index];
}
-(void)insertPeople:(NSArray *)array atIndexes:(NSIndexSet *)indexes{
    [_people insertObjects:array atIndexes:indexes];
}

-(void)removeObjectFromPeopleAtIndex:(NSUInteger)index{
    [_people removeObjectAtIndex:index];
}
-(void)removePeopleAtIndexes:(NSIndexSet *)indexes{
    [_people removeObjectsAtIndexes:indexes];
}
-(void)replaceObjectInPeopleAtIndex:(NSUInteger)index withObject:(id)object{
    [_people replaceObjectAtIndex:index withObject:object];
}
-(void)replacePeopleAtIndexes:(NSIndexSet *)indexes withPeople:(NSArray *)array{
    [_people replaceObjectsAtIndexes:indexes withObjects:array];
}

-(id)objectInPeopleAtIndex:(NSUInteger)index{
    return [_people objectAtIndex:index];
}

-(NSArray * )people{
    return _people;
}
-(void)setPeople:(NSArray *)people{
    _people = [NSMutableArray arrayWithArray:people];
}

#pragma mark - _active KVC
-(BOOL)active{
    return _active;
}

-(void)setActive:(BOOL)active{
    if (_active != active)  {
        _active = active;
        _dataSoucre.active = _active;
    }
}


#pragma mark - DATASOURCE KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"people"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray * newObjects = [change objectForKey:NSKeyValueChangeNewKey];
            NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
            NSArray * indexPaths = [self getIndexPathsFromIndexSet:indexes];
            
            switch ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue]) {
                case NSKeyValueChangeSetting:
                    NSLog(@"setting");
                    [self setPeople:newObjects];
                    if (self.delegate) {
                        [self.delegate didSetData];
                    }
                    break;
                case NSKeyValueChangeInsertion:
                    NSLog(@"insertion");
                    [self insertPeople:newObjects atIndexes:indexes];
                    if (self.delegate) {
                        [self.delegate didInsertedObjectsAtIndexPaths:indexPaths];
                    }
                    break;
                case NSKeyValueChangeRemoval:
                    NSLog(@"removal");
                    [self removePeopleAtIndexes:indexes];
                    if (self.delegate) {
                        [self.delegate didRemovedObjectsAtIndexPaths:indexPaths];
                    }

                    break;
                case NSKeyValueChangeReplacement:
                    NSLog(@"replacement");
                    [self replacePeopleAtIndexes:indexes withPeople:newObjects];
                    if (self.delegate) {
                        [self.delegate didReplacedObjectsAtIndexPaths:indexPaths];
                    }

                    break;

                default:
                    break;
            }
        });

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
