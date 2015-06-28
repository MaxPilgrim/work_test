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
    Man * _man;
}

@end

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithMan:(Man *)man{
    _man = man;
    [man addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self configurePreloader];
}

-(void)configurePreloader{
    if (!_man.name ){
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
        self.textLabel.text = _man.name;
        self.textLabel.alpha = 0;
        [UIView animateWithDuration:CELL_TEXT_ANIMATION_DURATION animations:^{
            self.textLabel.alpha = 1;
        }];
    }
}

-(void)stopObserving{
    [_man removeObserver:self forKeyPath:@"name"];
}

#pragma mark - Man KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"name"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configurePreloader];
        });
    }
}


@end
