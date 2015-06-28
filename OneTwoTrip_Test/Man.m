//
//  Man.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "Man.h"

@implementation Man

-(instancetype)init{
    self = [self init];
    if (self){
        //set name in serial queue in random time
        int delayInSeconds = arc4random() % 10;
        [NSTimer timerWithTimeInterval:delayInSeconds target:self selector:@selector(initName) userInfo:nil repeats:NO];
    }
    return self;

}

-(void) initName{
    _name = @"Name";
}

@end
