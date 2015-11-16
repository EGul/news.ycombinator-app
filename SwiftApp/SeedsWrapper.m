//
//  SeedsWrapper.m
//  SwiftApp
//
//  Created by Evan on 11/15/15.
//  Copyright © 2015 none. All rights reserved.
//

#import "SeedsWrapper.h"

#define SERVER @"http://dash.playseeds.com"
#define API_KEY @"3e6b87bb21deec0e5a87a7c44feeee412e97a6ce"

@implementation SeedsWrapper

-(id)init {
    
    if (self = [super init]) {
        [[Seeds sharedInstance]start:API_KEY withHost:SERVER];
        Seeds.sharedInstance.inAppMessageDelegate = self;
    }
    
    return self;
}

-(void)seedsInAppMessageClicked:(SeedsInAppMessage *)inAppMessage {
    [self.delegate seedsWrapperInAppMessageClicked];
}

-(void)seedsInAppMessageClosed:(SeedsInAppMessage *)inAppMessage andCompleted:(BOOL)completed {
    [self.delegate seedsWrapperInAppMessageClosed];
}

-(void)seedsInAppMessageLoadSucceeded:(SeedsInAppMessage *)inAppMessage {
    [self.delegate seedsWrapperInAppMessageLoadSucceeded];
}

-(void)seedsInAppMessageShown:(SeedsInAppMessage *)inAppMessage withSuccess:(BOOL)success {
    [self.delegate seedsWrapperInAppMessageShown];
}

-(void)seedsNoInAppMessageFound {
    [self.delegate seedsWrapperNoInAppMessageFound];
}

@end
