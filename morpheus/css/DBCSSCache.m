//
//  DBCSSCache.m
//  morpheus
//
//  Created by Andrey Moskvin on 01.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBCSSCache.h"
#import "DBStylesheet.h"

@interface DBCSSCache ()

@property (nonatomic, readonly) NSMutableSet* styles;

@end

@implementation DBCSSCache

@synthesize styles = _styles;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _styles = [NSMutableSet set];
    }
    return self;
}

- (void)resetCache
{
    [self.styles removeAllObjects];
}

- (void)importStyleshhets:(NSArray *)stylesheets
{
    [self.styles addObjectsFromArray:stylesheets];
}



- (NSSet *)stylesForSelector:(NSString*)selector type:(enum DBCSSSelectorType)type
{
    NSSet* result =[self.styles objectsPassingTest:^BOOL(DBStylesheet* sheet, BOOL *stop) {
        return ((sheet.selectorType == type) &&
                [sheet.selector isEqualToString:selector]);
    }];
    return result;
}

- (NSSet *)stylesForClass:(NSString *)clazz
{
    return [self stylesForSelector:clazz type:DBCSSSelectorType_Class];
}

- (NSSet *)stylesForIdentifier:(NSString *)identifier
{
    return [self stylesForSelector:identifier type:DBCSSSelectorType_Id];
}

- (NSSet *)stylesForType:(NSString *)type
{
    return [self stylesForSelector:type type:DBCSSSelectorType_Type];
}

- (NSSet *)allStyles
{
    return [self.styles copy];
}
@end
