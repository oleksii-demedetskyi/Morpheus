//
//  DBFileGuard.m
//  morpheus
//
//  Created by Moskvin Andrey on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBFileGuard.h"
#include <sys/event.h>
#include <sys/time.h> 
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

@interface DBFileGuard()
{
    CFFileDescriptorRef _kqRef;
}

@property (nonatomic, strong) NSString* bundlePath;

@end

@implementation DBFileGuard
@synthesize bundlePath;
@synthesize delegate;

#pragma mark - Init Methods

- (id)initWithBundlePath:(NSString *)aBundlePath
{
    self = [super init];
    if (self) 
    {
        self.bundlePath = aBundlePath;
    }
    return self;
}

+(id)fileGuardWithBundlePath:(NSString *)path
{
    return [[self alloc] initWithBundlePath:path];
}

#pragma mark - Private methods

- (void)kqueueFired
{
    int             kq;
    struct kevent   event;
    struct timespec timeout = { 0, 0 };
    int             eventCount;
    
    kq = CFFileDescriptorGetNativeDescriptor(self->_kqRef);
    assert(kq >= 0);
    
    eventCount = kevent(kq, NULL, 0, &event, 1, &timeout);
    assert( (eventCount >= 0) && (eventCount < 2) );
    
    if (eventCount == 1) 
    {
        NSLog(@"Directory changed!!");
    }    
    
    [self.delegate fileGuardDidChangedFileInBundle:self];
    CFFileDescriptorEnableCallBacks(self->_kqRef, kCFFileDescriptorReadCallBack);
}

static void KQCallback(CFFileDescriptorRef kqRef, CFOptionFlags callBackTypes, void *info)
{
    DBFileGuard *obj;
    
    obj = (__bridge DBFileGuard *) info;
    assert([obj isKindOfClass:[DBFileGuard class]]);
    assert(kqRef == obj->_kqRef);
    assert(callBackTypes == kCFFileDescriptorReadCallBack);
    
    [obj kqueueFired];
}

-(void)testReadWriteCallbacks
{
    int                     dirFD;
    int                     kq;
    int                     retVal;
    struct kevent           eventToAdd;
    CFFileDescriptorContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
    CFRunLoopSourceRef      rls;
    
    dirFD = open([self.bundlePath fileSystemRepresentation], O_EVTONLY);
    assert(dirFD >= 0);
    
    kq = kqueue();
    assert(kq >= 0);
    
    eventToAdd.ident  = dirFD;
    eventToAdd.filter = EVFILT_VNODE;
    eventToAdd.flags  = EV_ADD | EV_CLEAR;
    eventToAdd.fflags = NOTE_WRITE;
    eventToAdd.data   = 0;
    eventToAdd.udata  = NULL;
    
    retVal = kevent(kq, &eventToAdd, 1, NULL, 0, NULL);
    assert(retVal == 0);
    
    assert(self->_kqRef == NULL);
    
    self->_kqRef = CFFileDescriptorCreate(NULL, kq, true, KQCallback, &context);
    assert(self->_kqRef != NULL);
    
    rls = CFFileDescriptorCreateRunLoopSource(NULL, self->_kqRef, 0);
    assert(rls != NULL);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
    
    CFRelease(rls);
    
    CFFileDescriptorEnableCallBacks(self->_kqRef, kCFFileDescriptorReadCallBack);
}

@end
