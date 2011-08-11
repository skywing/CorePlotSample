//
//  EskLinePlot.h
//  Display the line chart that allow user select the plot symbol on the line
//  and slide left or right and the chart will display the value while the user
//  is moving the line along the chart.
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


// Render the chart on the hosting view from the view controller with the default theme.
- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme;

// Change the select line plot color.
- (void)applyTouchPlotColor;

@end


// Delegate to notify the view controller that the location of the line has changed.
@protocol EskLinePlotDelegate <NSObject> 

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index;

@end
