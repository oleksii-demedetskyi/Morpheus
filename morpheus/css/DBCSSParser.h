//
//  DBCSSParser.h
//  morpheus
//
//  Created by Andrey Moskvin on 30.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBCSSParser : NSObject

- (NSArray*)parseStylesheet:(NSString*)stylesheet;

@end
