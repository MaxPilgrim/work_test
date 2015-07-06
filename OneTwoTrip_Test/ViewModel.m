//
//  ViewModel.m
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 05/07/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import "ViewModel.h"
#import <UIKit/UIKit.h>

@interface ViewModel (){
    BOOL _active;
    NSMutableArray * _people;
    DataSource * _dataSource;
}
@end


@implementation ViewModel


-(instancetype)initWithDataSource:(DataSource *)dataSource{
    self = [super init];
    if (self){
        _people = [NSMutableArray new];
        _dataSource = dataSource;
        [_dataSource addObserver:self forKeyPath:@"people" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)dealloc{
    [_dataSource removeObserver:self forKeyPath:@"people"];
}


-(void)setActive:(BOOL)active{
    if (_active != active)  {
        _active = active;
        _dataSource.active = _active;
    }
}


#pragma mark - DATASOURCE KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"people"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray * newObjects = [change objectForKey:NSKeyValueChangeNewKey];
            NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];

            switch ([[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue]) {
                case NSKeyValueChangeSetting:
                    NSLog(@"setting");
                    _people = [NSMutableArray arrayWithArray:newObjects];
                    if (self.delegate) {
                        [self.delegate didSetData];
                    }
                    break;
                case NSKeyValueChangeInsertion:
                    NSLog(@"insertion");
                    [_people insertObjects:newObjects atIndexes:indexes];
                    if (self.delegate) {
                        [self.delegate didInsertedObjectsAtIndexes:indexes];
                    }
                    break;
                case NSKeyValueChangeRemoval:
                    NSLog(@"removal");
                    [_people removeObjectsAtIndexes:indexes];
                    if (self.delegate) {
                        [self.delegate didRemovedObjectsAtIndexes:indexes];
                    }

                    break;
                case NSKeyValueChangeReplacement:
                    NSLog(@"replacement");
                    [_people replaceObjectsAtIndexes:indexes withObjects:newObjects];
                    if (self.delegate) {
                        [self.delegate didReplacedObjectsAtIndexes:indexes];
                    }

                    break;

                default:
                    break;
            }
        });

    }

}





@end
