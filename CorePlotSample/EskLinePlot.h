//
//  EskLinePlot.h
//  CorePlotSample
//
//  Created by Ken Wong on 8/9/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@protocol EskLinePlotDelegate;

@interface EskLinePlot : NSObject <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
  @private
    CPTGraph *graph;
    CPTScatterPlot *linePlot;
    CPTScatterPlot *touchPlot;
    NSUInteger selectedCoordination;
    BOOL touchPlotSelected;
}

@property (nonatomic, retain) id<EskLinePlotDelegate> delegate;
@property (nonatomic, retain) NSArray *sampleData;
@property (nonatomic, retain) NSArray *sampleYears;

- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme;
- (void)applyTouchPlotColor;

@end

@protocol EskLinePlotDelegate <NSObject> 

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index;

@end
