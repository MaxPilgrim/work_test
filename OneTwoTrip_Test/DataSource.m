//
//  DataSource.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//


#import "DataSource.h"
#import "Man.h"

@interface DataSource (){
    BOOL _active;
    NSMutableArray * _people;
    NSLock * _lockPeople;
    NSLock * _lockActive;
}

@end


@implementation DataSource

#pragma mark - singltone

+(DataSource *)sharedInstance {
    static DataSource *singletone = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^
                  {
                      singletone = [[DataSource alloc] init];
                  });

    return singletone;
}
-(instancetype)init{
    self = [super init];
    if (self){
        self.serialQueue = dispatch_queue_create(SERIAL_QUEUE_IDENTIFIER, NULL);
        _people = [NSMutableArray new];
        _lockPeople = [NSLock new];
        _lockActive = [NSLock new];
    }
    return self;
}

#pragma mark - _people KVC

-(void) insertObject:(Man *)object inPeopleAtIndex:(NSUInteger)index{
    [_lockPeople lock];
    [_people insertObject:object atIndex:index];
    [_lockPeople unlock];
}
-(void)removeObjectFromPeopleAtIndex:(NSUInteger)index{
    [_lockPeople lock];
    [_people removeObjectAtIndex:index];
    [_lockPeople unlock];
}

-(NSArray * )people{
    NSArray * people;
    [_lockPeople lock];
    people = _people;
    [_lockPeople unlock];
    return _people;
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
    }
    [_lockActive unlock];
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
        double delay = (arc4random() % 10) / 10.0 + 0.4;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), _serialQueue, ^{
            [self performUpdate];
            dispatch_async(_serialQueue, ^{
                [self nextUpdate];
            });
            
        });
    }
}
-(void)startUpdates{
    [self nextUpdate];
}

@end
