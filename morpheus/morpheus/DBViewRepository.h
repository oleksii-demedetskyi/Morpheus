//
//  DBViewRepository.h
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBViewRepository : NSObject

+(id)sharedRepository;
-(void)addView:(UIView *)view;
-(void)removeView:(UIView *)view;

@end
