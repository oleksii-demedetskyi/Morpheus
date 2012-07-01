//
//  DBCSSCache.h
//  morpheus
//
//  Created by Andrey Moskvin on 01.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBCSSCache : NSObject

- (void)resetCache;
- (void)importStyleshhets:(NSArray*)stylesheets;

- (NSSet*)allStyles;

- (NSSet*)stylesForClasses:(NSSet*)classes;
- (NSSet*)stylesForClass:(NSString*)clazz;
- (NSSet*)stylesForType:(NSString*)type;
- (NSSet*)stylesForIdentifier:(NSString*)identifier;

@end
