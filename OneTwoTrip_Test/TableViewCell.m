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
@property (nonatomic, strong) Man * man;
@end

@implementation TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self addObserver:self forKeyPath:@"man.name" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"man.name"];
}


-(void)configureCellWithMan:(Man *)man{
    self.man = man;
    [self configurePreloaderWithName:nil];
}


-(void)configurePreloaderWithName:(NSString *)name{
    if (!name){
        [self setPreloaderActive];
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

-(void)setPreloaderActive{
    if (!preloader){
        preloader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        preloader.center = CGPointMake(20, self.center.y);
        [self addSubview:preloader];
    }
    self.textLabel.text = @"";
    preloader.hidden = NO;
    [preloader startAnimating];
}

#pragma mark - Man KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([keyPath isEqualToString:@"man.name"]){
            NSLog(@"change = %@",change);
            id name = [change objectForKey:NSKeyValueChangeNewKey];
            if ([name isKindOfClass:[NSNull class]]) name = nil;
            [self configurePreloaderWithName:name];

        }
    });
}


@end
