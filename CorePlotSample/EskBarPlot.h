//
//  EskBarPlot.h
//  Display the bar chart that allow user tab on the bar. 
//  The chart will use the highlight color and dash line border for
//  the selected chart.
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@protocol EskBarPlotDelegate;

@interface EskBarPlot : NSObject <CPTPlotDataSource, CPTBarPlotDelegate>
{
  @private
    CPTGraph *graph;
    CPTBarPlot *barChart;
    CPTBarPlot *selectedPlot;
    NSUInteger selectedBarIndex;
    NSNumberFormatter *currencyFormatter;
}

@property (nonatomic, assign) id<EskBarPlotDelegate> delegate;
@property (nonatomic, retain) NSArray *sampleData;
@property (nonatomic, retain) NSArray *sampleProduct;

// Render the chart on the hosting view from the view controller with the default theme.
- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme;

@end

// Bar Plot delegate to notify when the bar is selected.
@protocol EskBarPlotDelegate <NSObject>

- (void)barPlot:(EskBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index;

@end
