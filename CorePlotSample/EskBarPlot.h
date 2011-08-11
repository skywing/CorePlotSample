//
//  EskBarPlot.h
//  CorePlotSample
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

- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme;

@end

@protocol EskBarPlotDelegate <NSObject>

- (void)barPlot:(EskBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index;

@end
