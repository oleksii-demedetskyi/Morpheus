//
//  DBStylesheet.h
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DBCSSSelectorType {
    DBCSSSelectorType_Unknown = 0,
    DBCSSSelectorType_Type = 1,
    DBCSSSelectorType_Class = 2,
    DBCSSSelectorType_Id = 3,
};

@interface DBStylesheet : NSObject

@property (nonatomic, readonly) enum DBCSSSelectorType selectorType;
@property (nonatomic, readonly) NSString* selector;
@property (nonatomic, readonly) NSDictionary* properties;

+ (id)sheetForSelector:(NSString*)selector 
         selectorTypes:(enum DBCSSSelectorType)type
            properties:(NSDictionary*)properties;

@end
