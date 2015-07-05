//
//  SerialQueue.h
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//
#define SERIAL_QUEUE_IDENTIFIER "data_source_serial_queue"
#define QUEQUES_MANAGER [QueuesManager sharedInstance]

#import <Foundation/Foundation.h>

@interface QueuesManager : NSObject

@property (nonatomic, readonly) dispatch_queue_t serialQueue;


+(QueuesManager *)sharedInstance;


@end
