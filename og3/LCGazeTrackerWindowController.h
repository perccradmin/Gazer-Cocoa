//
//  LCGazeTrackerWindowController.h
//  og3
//
//  Created by David Pitman on 12/7/11.
//  Copyright (c) 2011 Lab Cogs Co. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LCGazeFoundation.h"

@interface LCGazeTrackerWindowController : NSWindowController{
    CALayer* _gazeTargetLayer;
    NSScreen* _screen;
    BOOL _isActive;
}

@property BOOL isActive;

// Init to cover a particular screen
- (id)initWithScreen:(NSScreen*)screen;

// Move the gaze estimation target
-(void) moveGazeTarget:(LCGazePoint*) point;

// Setup the gaze target layer and add it to the relevant view, etc
-(CALayer*)setupGazeTargetLayer:(CALayer*)parentLayer;

// Move the gaze estimation target
-(void) moveGazeTarget:(LCGazePoint*) point;

// Show the gaze estimation target
-(void) show:(BOOL)show;

// Notification to move the gaze estimation target
-(void)moveGazeEstimationTarget:(NSNotification*)note;

@end
