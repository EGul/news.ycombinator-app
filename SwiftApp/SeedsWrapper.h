//
//  SeedsWrapper.h
//  SwiftApp
//
//  Created by Evan on 11/15/15.
//  Copyright © 2015 none. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Seeds.h"
#import "SeedsInAppMessageDelegate.h"

@protocol SeedsWrapperProtocol <NSObject>

-(void)seedsWrapperInAppMessageClicked;
-(void)seedsWrapperInAppMessageClosed;
-(void)seedsWrapperInAppMessageLoadSucceeded;
-(void)seedsWrapperInAppMessageShown;
-(void)seedsWrapperNoInAppMessageFound;

@end

@interface SeedsWrapper : NSObject <SeedsInAppMessageDelegate> {
    
}

@property (nonatomic, retain) id delegate;

@end
