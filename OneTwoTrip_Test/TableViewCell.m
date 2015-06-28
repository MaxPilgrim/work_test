//
//  TableViewCell.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

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
            preloader.center = self.center;
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
