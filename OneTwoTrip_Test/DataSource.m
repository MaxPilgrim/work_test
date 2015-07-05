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

-(void) insertObject:(Man *)object inPeopleAtIndex:(NSUInteger)index{
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
    }
    [self startUpdates];
}

#pragma mark - updates methods

-(void)performUpdate{
    if (!self.active) return;
    BOOL isInsert = ((arc4random() % 10) > 3) || _people.count == 0;
    int idx = arc4random() % (_people.count + (int)isInsert);
    if (isInsert){
        Man * man = [Man new];
        [self insertObject:man inPeopleAtIndex:idx];
    }else{
        [self removeObjectFromPeopleAtIndex:idx];
    }
}

-(void)nextUpdate{
    if (self.active){
        double delay = (arc4random() % 100) / 100.0 + 0.2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), QUEQUES_MANAGER.serialQueue, ^{
            [self performUpdate];
            dispatch_async(QUEQUES_MANAGER.serialQueue, ^{
                [self nextUpdate];
            });
            
        });
    }
}
-(void)startUpdates{
    [self nextUpdate];
}

@end
