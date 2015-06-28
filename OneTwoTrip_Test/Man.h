//
//  Man.h
//  OneTwoTrip_Test
//
//  Created by Kotov Max on 28/06/15.
//  Copyright (c) 2015 kotovmd. All rights reserved.
//

#import <Foundation/Foundation.h>
// all updates are performed on backgroud serial queue (or single thread)
@interface Man : NSObject

// is loaded asynchronously (nil if not loaded yet), KVO-compatible
@property (nonatomic, copy, readonly) NSString *name;


@end

