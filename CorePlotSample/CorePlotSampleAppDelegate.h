//
//  CorePlotSampleAppDelegate.h
//  CorePlotSample
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Stryker Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CorePlotSampleViewController;

@interface CorePlotSampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CorePlotSampleViewController *viewController;

@end
