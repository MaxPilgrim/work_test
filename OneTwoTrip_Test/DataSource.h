//
//  DataSource.h
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//
#define SERIAL_QUEUE_IDENTIFIER "data_source_serial_queue"
#define DATASOURCE [DataSource sharedInstance]

#import <Foundation/Foundation.h>

// all updates are performed on background serial queue (or single thread)
@protocol DataSource <NSObject>
@required

@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong, readonly) NSArray *people; // array of Man objects, KVO-compatible

@end


@interface DataSource : NSObject <DataSource>

@property (nonatomic, assign) BOOL active;
@property (nonatomic, strong, readonly) NSArray *people; // array of Man objects, KVO-compatible
@property (nonatomic) dispatch_queue_t serialQueue;

+(DataSource *)sharedInstance;

@end
