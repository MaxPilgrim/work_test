//
//  TableViewCell.h
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Man;

@interface TableViewCell : UITableViewCell

-(void) configureCellWithMan:(Man *)man;

@end
