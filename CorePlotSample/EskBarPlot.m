//
//  EskBarPlot.m
//  CorePlotSample
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import "EskBarPlot.h"

#define kDefaultPlot @"default"
#define kSelectedPlot @"selected"

@implementation EskBarPlot

@synthesize sampleData, sampleProduct;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // Setting up sample data here.
        sampleData = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0],
                                                      [NSNumber numberWithInt:2000], 
                                                      [NSNumber numberWithInt:5000], 
                                                      [NSNumber numberWithInt:3000], 
                                                      [NSNumber numberWithInt:7000],
                                                      [NSNumber numberWithInt:8500],
                                                      nil];
        
        sampleProduct = [[NSArray alloc] initWithObjects:@"", @"A", @"B", @"C", @"D", @"E", nil];
        
        // Initialize the currency formatter to support negative with the default currency style.
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setNegativePrefix:@"-"];
        [currencyFormatter setNegativeSuffix:@""];
    }
    
    return self;
}

- (void)dealloc
{
    [sampleData release];
    [sampleProduct release];
    [super dealloc];
}

- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme
{
    CGRect bounds = layerHostingView.bounds;
    
    // create and assign chart to the hosting view.
    graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    layerHostingView.hostedGraph = graph;
    [graph applyTheme:theme];
    
    graph.plotAreaFrame.masksToBorder = NO;
    
    graph.paddingLeft = 90.0;
	graph.paddingTop = 50.0;
	graph.paddingRight = 20.0;
	graph.paddingBottom = 60.0;
    
    
    // chang the chart layer orders so the axis line is on top of the bar in the chart.
    NSArray *chartLayers = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:CPTGraphLayerTypeAxisLines],  
                                                            [NSNumber numberWithInt:CPTGraphLayerTypePlots], 
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeMajorGridLines], 
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeMinorGridLines],
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLabels], 
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisTitles], nil];
    
    graph.topDownLayerOrder = chartLayers;
    [chartLayers release];
    
    
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(10000)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(6)];
    
    // Setting X-Axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.title = @"Product from diffrent company";
    x.titleOffset = 30.0f;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.labelExclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(6) length:CPTDecimalFromInt(1)], nil];
    
    // Use custom x-axis label so it will display product A, B, C... instead of 1, 2, 3, 4
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[sampleProduct count]];
    int idx = 0;
    for (NSString *product in sampleProduct)
    {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:product textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromInt(idx);
        label.offset = 5.0f;
        [labels addObject:label];
        [label release];
        idx++;
    }
    x.axisLabels = [NSSet setWithArray:labels];
    [labels release];
    
    // Setting up y-axis
	CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromInt(1000);
    y.minorTicksPerInterval = 0;
    y.minorGridLineStyle = nil;
    y.title = @"Cost Per Unit";
    y.labelExclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)], nil];
    
    barChart = [[CPTBarPlot alloc] init];
    barChart.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.22f green:0.55f blue:0.71f alpha:0.4f]];
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineWidth = 2.f;
    borderLineStyle.lineColor = [CPTColor colorWithComponentRed:0.22f green:0.55f blue:0.71f alpha:1.0f];

    
    barChart.lineStyle = borderLineStyle;
    barChart.barWidth = CPTDecimalFromString(@"0.6");
    barChart.baseValue = CPTDecimalFromString(@"0");
    
    barChart.dataSource = self;
    barChart.barCornerRadius = 2.0f;
    barChart.identifier = kDefaultPlot;
    barChart.delegate = self;
    [graph addPlot:barChart toPlotSpace:plotSpace];
    
    //selected Plot
    selectedPlot = [[CPTBarPlot alloc] init];
    selectedPlot.fill = [CPTFill fillWithColor:[[CPTColor orangeColor] colorWithAlphaComponent:0.35f]];
    
    CPTMutableLineStyle *selectedBorderLineStyle = [CPTMutableLineStyle lineStyle];
	selectedBorderLineStyle.lineWidth = 3.0f;
    selectedBorderLineStyle.lineColor = [CPTColor orangeColor];
    selectedBorderLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:10.0f], [NSNumber numberWithFloat:8.0f], nil];
    
    selectedPlot.lineStyle = selectedBorderLineStyle;
    selectedPlot.barWidth = CPTDecimalFromString(@"0.6");
    selectedPlot.baseValue = CPTDecimalFromString(@"0");
    
    selectedPlot.dataSource = self;
    selectedPlot.barCornerRadius = 2.0f;
    selectedPlot.identifier = kSelectedPlot;
    selectedPlot.delegate = self;
    [graph addPlot:selectedPlot toPlotSpace:plotSpace];

}

// We can decide what color to fill the bar in the chart at the given index here.
// In this case, when the given index match the selected bar index, we change the color
// to clear color, so we select Plot layer on top of the default one can has it own transparent color.
-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    if (barPlot.identifier == kDefaultPlot && index == selectedBarIndex)
    {
        CPTFill *fillColor = [CPTFill fillWithColor:[CPTColor clearColor]];
        return fillColor;
    }
    return nil;
}

#pragma mark - CPTBarPlot Delegates
- (void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    selectedBarIndex = index;
    [graph reloadData];
    
    // Notify the view controller that a bar was selected, so it can change the label description.
    if ([delegate respondsToSelector:@selector(barPlot:barWasSelectedAtRecordIndex:)])
    {
        [delegate barPlot:self barWasSelectedAtRecordIndex:index];
    }
}

// This method is call to put the number figure on the top tip of the bar.
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    if (index == selectedBarIndex && [plot.identifier isEqual:kSelectedPlot]) 
    {
        CPTTextLayer *selectedText = [CPTTextLayer layer];
        selectedText.text = [currencyFormatter stringFromNumber:[sampleData objectAtIndex:index]];
        CPTMutableTextStyle *labelTextStyle = [CPTMutableTextStyle textStyle];
        labelTextStyle.fontSize = 16;
        labelTextStyle.color = [CPTColor purpleColor];
        selectedText.textStyle = labelTextStyle;
        return selectedText;
    }
    return nil;
}


#pragma mark - CPTPlotDataSource Delegates
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [sampleData count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (index == 0)
        return nil;
    
    NSNumber *num = nil;
    if (fieldEnum == CPTBarPlotFieldBarLocation)
    {
        num = [NSNumber numberWithInt:index];
    }
    else if (fieldEnum == CPTBarPlotFieldBarTip)
    {
        // The select plot will only return a value when a bar was selected.
        if (plot.identifier == kDefaultPlot || 
            (plot.identifier == kSelectedPlot && index == selectedBarIndex))
        {
            num = [sampleData objectAtIndex:index];
        }

    }

    return num;
}


@end
