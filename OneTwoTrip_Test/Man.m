//
//  Man.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "Man.h"
#import "DataSource.h"

@implementation Man

-(instancetype)init{
    self = [super init];
    if (self){
        //set name in serial queue in random time
        double delayInSeconds = arc4random() % 3 + 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), DATASOURCE.serialQueue, ^{
            [self initName];
        });
    }
    return self;

}

-(void) initName{
//    NSLog(@"name set");
    [self willChangeValueForKey:@"name"];
    _name = @"Name";
    [self didChangeValueForKey:@"name"];
}

@end
