//
//  AppDelegate.m
//  og3
//
//  Created by Ryan Kabir on 11/22/11.
//  Copyright (c) 2011 Grow20 Corporation. All rights reserved.
//

#import "AppDelegate.hpp"

#import "CoreFoundation/CoreFoundation.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize calibrationFlag;

-(void)applicationWillFinishLaunching:(NSNotification*)aNotification{
    [[NSApplication sharedApplication] disableRelaunchOnLogin];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    LCCalibrationWindowController *win = [[LCCalibrationWindowController alloc] initWithWindowNibName:@"CalibrationWindow"];
     [win awakeFromNib];
    // set the right path so the classifiers can find their data
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(mainBundle);
    char path[PATH_MAX];
    if (!CFURLGetFileSystemRepresentation(resourcesURL, TRUE, (UInt8 *)path, PATH_MAX))
    {
        // error!
    }
    CFRelease(resourcesURL);
    chdir(path);
    // end path settings
     NSArray *args = [[NSProcessInfo processInfo] arguments];
    //int count = [args count];
    
    NSView* view = [[self window] contentView];
    
    
    OGc* g = new OGc::OGc(0, NULL, view);
    g->loadClassifiers();

    MainGazeTracker *gazeTracker = g->gazeTracker;
//    new MainGazeTracker(argc, argv, getStores(win.hostView), win.hostView);

    win.pv = [NSValue valueWithPointer:g];

    cvNamedWindow(MAIN_WINDOW_NAME, CV_GUI_EXPANDED);
    cvResizeWindow(MAIN_WINDOW_NAME, 640, 480);

    //    createButtons();
    g->registerMouseCallbacks();

    gazeTracker->doprocessing();
    g->drawFrame();

//    findEyes();
//    YourAppDelegate *appDelegate = (YourAppDelegate *)[[UIApplication sharedApplication] delegate];
//    app.delegate.calibrationFlag = NO;
    
    // to declare an object Object* blah = &gazeTracker
    
    GlobalManager *gm = [GlobalManager sharedGlobalManager];
    gm.calibrationFlag = NO;
    NSLog(@"Entering while loop");
    while(1) {
        gazeTracker->doprocessing();

        g->drawFrame();
        if (gm.calibrationFlag) {
            gazeTracker->startCalibration();
            gm.calibrationFlag = NO;
        }
        char c = cvWaitKey(33);
        switch(c) {
            case 'c':
                gazeTracker->startCalibration();
                break;
            case 't':
                gazeTracker->startTesting();
                break;
            case 's':
                gazeTracker->savepoints();
                break;
            case 'l':
                gazeTracker->loadpoints();
                break;
            case 'x':
                gazeTracker->clearpoints();
                break;
            case 'r':
                g->findEyes();
                break;
            default:
                break;
        }

        if(c == 27) break;
    }

}

@end
