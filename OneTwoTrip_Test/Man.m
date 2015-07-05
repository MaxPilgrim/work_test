//
//  Man.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "Man.h"
#import "QueuesManager.h"

@implementation Man

-(instancetype)init{
    self = [super init];
    if (self){
        //set name in serial queue in random time
        double delayInSeconds = (arc4random() % 20) / 10.0 + 0.4;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), QUEQUES_MANAGER.serialQueue, ^{
            self.name = [NSString stringWithFormat:@"Name #%d",arc4random() % 100000];
        });
    }
    return self;

}

-(void)setName:(NSString *)name{
    _name = name;
}

@end
