//
//  DataSource.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//


#import "DataSource.h"
#import "Man.h"
#import "QueuesManager.h"

@interface DataSource (){
    BOOL _active;
    NSMutableArray * _people;
}

@end


@implementation DataSource

-(instancetype)init{
    self = [super init];
    if (self){
        _people = [NSMutableArray new];
    }
    return self;
}

#pragma mark - _people KVC

-(void)insertPeople:(NSArray *)array atIndexes:(NSIndexSet *)indexes{
    [_people insertObjects:array atIndexes:indexes];
}

-(void)removePeopleAtIndexes:(NSIndexSet *)indexes{
    [_people removeObjectsAtIndexes:indexes];
}

-(void)replacePeopleAtIndexes:(NSIndexSet *)indexes withPeople:(NSArray *)array{
    [_people replaceObjectsAtIndexes:indexes withObjects:array];
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
    }
    [self startUpdates];
}

#pragma mark - updates methods

-(void)startUpdates{
    [self nextUpdate];
}

-(void)nextUpdate{
    if (self.active){
        double delay = (arc4random() % 10) / 10.0 + 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), QUEQUES_MANAGER.serialQueue, ^{
            [self performUpdate];
            dispatch_async(QUEQUES_MANAGER.serialQueue, ^{
                [self nextUpdate];
            });

        });
    }
}

-(void)performUpdate{
    if (!self.active) return;
    int changeType = arc4random() % 4;
    if (changeType > 1 && _people.count == 0){
        changeType = changeType % 2;
    }
    switch (changeType) {
        case 0:
            [self performPeopleSetting];
            break;
        case 1:
            [self performPeopleInsert];
            break;
        case 2:
            [self performPeopleRemoval];
            break;
        case 3:
            [self performPeopleReplacement];
            break;
        default:
            break;
    }
}



-(void)performPeopleSetting{
    NSMutableArray * newObjects = [NSMutableArray new];
    int size = arc4random() % 20 + 5;
    for (int i = 0; i < size; i++){
        Man * man = [Man new];
        [newObjects addObject:man];
    }
    [self setPeople:newObjects];
}
-(void)performPeopleInsert{
    int size = arc4random() % 20 + 4;
    NSMutableIndexSet * indexes = [NSMutableIndexSet new];
    for (int i = 0; i < size; i++){
        int idx = arc4random() % (_people.count + [indexes count] + 1);
        [indexes addIndex:idx];
    }
    NSMutableArray * newObjects = [NSMutableArray new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        Man * man = [Man new];
        [newObjects addObject:man];
    }];
    [self insertPeople:newObjects atIndexes:indexes];
}
-(void)performPeopleRemoval{
    int size = arc4random() % _people.count;
    if (size == 0) size++;
    NSMutableIndexSet * indexes = [NSMutableIndexSet new];
    for (int i = 0; i < size; i++){
        int idx = arc4random() % _people.count;
        [indexes addIndex:idx];
    }
    [self removePeopleAtIndexes:indexes];
}
-(void)performPeopleReplacement{
    int size = arc4random() % 20 + 1;
    NSMutableIndexSet * indexes = [NSMutableIndexSet new];
    for (int i = 0; i < size; i++){
        int idx = arc4random() % _people.count;
        [indexes addIndex:idx];
    }

    NSMutableArray * newObjects = [NSMutableArray new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        Man * man = [Man new];
        [newObjects addObject:man];
    }];
    [self replacePeopleAtIndexes:indexes withPeople:newObjects];
}


@end
