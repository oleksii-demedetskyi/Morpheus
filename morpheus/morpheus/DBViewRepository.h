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
-(void)removeView:(UIView *)view fromClass:(NSString *)aClass;

- (NSSet*)viewsForClass:(NSString*)clazz;
- (NSSet*)viewsForType:(NSString*)type;
- (NSSet*)viewsForIdentifier:(NSString*)identifier;

- (void)addListener:(id)listener;

@end
