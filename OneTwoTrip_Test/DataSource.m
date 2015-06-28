//
//  DataSource.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//


#import "DataSource.h"
#import "Man.h"

@interface DataSource ()
@end

@implementation DataSource

#pragma mark - singltone

+(DataSource *)sharedInstance {
    static DataSource *singltone = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^
                  {
                      singltone = [[DataSource alloc] init];
                      singltone.serialQueue = dispatch_queue_create(SERIAL_QUEUE_IDENTIFIER, NULL);
                      [singltone initPeople];
                  });

    return singltone;
}


-(void) initPeople{
    int delayInSeconds = arc4random() % 4 + 1;
//    int delayInSeconds = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), _serialQueue, ^{
        NSMutableArray * people = [[NSMutableArray alloc] init];
        int size = arc4random() % 100;
        for (int i = 0; i < size; i++) {
            [people addObject:[[Man alloc] init]];
        }
        [self willChangeValueForKey:@"people"];
        _people = [NSArray arrayWithArray:people];
        [self didChangeValueForKey:@"people"];
        NSLog(@"Data source configured");
    });
}


@end
