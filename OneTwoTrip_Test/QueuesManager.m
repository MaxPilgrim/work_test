//
//  SerialQueue.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "QueuesManager.h"

@implementation QueuesManager


#pragma mark - singltone

+(QueuesManager *)sharedInstance {
    static QueuesManager *singletone = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^
                  {
                      singletone = [[QueuesManager alloc] init];
                  });

    return singletone;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create(SERIAL_QUEUE_IDENTIFIER, NULL);
    }
    return self;
}

@end
