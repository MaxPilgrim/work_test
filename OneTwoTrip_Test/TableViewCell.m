//
//  TableViewCell.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//
#define CELL_TEXT_ANIMATION_DURATION 0.4


#import "TableViewCell.h"

@interface TableViewCell(){
    UIActivityIndicatorView * preloader;
}

@end

@implementation TableViewCell


-(void)configureCellWithName:(NSString *)name{
    if (!name){
        if (!preloader){
            preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            preloader.center = CGPointMake(20, self.center.y);
            [self addSubview:preloader];
        }
        self.textLabel.text = @"";
        preloader.hidden = NO;
        [preloader startAnimating];
    }else{
        if (preloader){
            [preloader stopAnimating];
            preloader.hidden = YES;
        }
        self.textLabel.text = name;
        self.textLabel.alpha = 0;
        [UIView animateWithDuration:CELL_TEXT_ANIMATION_DURATION animations:^{
            self.textLabel.alpha = 1;
        }];
    }
}


@end
