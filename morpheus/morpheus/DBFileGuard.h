//
//  DBFileGuard.h
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBFileGuard;
@protocol DBFileGuardProtocol <NSObject>

- (void)fileGuardDidChangedFileInBundle:(DBFileGuard *)fileGuard;

@end

@interface DBFileGuard : NSObject

@property (nonatomic, weak) id<DBFileGuardProtocol> delegate;

+(id)fileGuardWithBundlePath:(NSString*)path;

@end
