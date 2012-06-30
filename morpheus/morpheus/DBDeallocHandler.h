//
//  DBDeallocHandler.h
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^DeallocBlock)(UIView* view);

@interface DBDeallocHandler : NSObject

+(id)handlerWithDeallocBlock:(DeallocBlock)deallocBlock forView:(UIView *)view;

@end
