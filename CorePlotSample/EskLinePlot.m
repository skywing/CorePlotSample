//
//  EskLinePlot.m
//  CorePlotSample
//
//  Created by Ken Wong on 8/9/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import "EskLinePlot.h"

#define kHighPlot @"HighPlot"
#define kLinePlot @"LinePlot"
#define kNumberOfMarkerPlotSymbols 3

@implementation EskLinePlot

@synthesize delegate;
@synthesize sampleData, sampleYears;

- (id)init
{
    self = [super init];
    if (self) 
    {
        // setting up the sample data here.
        sampleData = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:6000],
                                                      [NSNumber numberWithInt:3000],
                                                      [NSNumber numberWithInt:2000],
                                                      [NSNumber numberWithInt:5000],
                                                      [NSNumber numberWithInt:7000],
                                                      [NSNumber numberWithInt:8500],
                                                      [NSNumber numberWithInt:6500], nil];
        
        sampleYears = [[NSArray alloc] initWithObjects:@"2010", @"2011", @"2012", @"2013", @"2014", @"2015", @"2016", nil];
        
    }
    
    return self;
}

- (void)dealloc
{
    [sampleData release];
    [sampleYears release];
    [linePlot release];
    [touchPlot release];
    [super dealloc];
}

- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGRect bounds = layerHostingView.bounds;
    
    // Create the graph and assign the hosting view.
    graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    layerHostingView.hostedGraph = graph;
    [graph applyTheme:theme];
    
    graph.plotAreaFrame.masksToBorder = NO;
    
    // chang the chart layer orders so the axis line is on top of the bar in the chart.
    NSArray *chartLayers = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:CPTGraphLayerTypePlots],
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeMajorGridLines], 
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeMinorGridLines],  
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLines], 
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisLabels], 
                                                            [NSNumber numberWithInt:CPTGraphLayerTypeAxisTitles], 
                                                            nil];
    graph.topDownLayerOrder = chartLayers;    
    [chartLayers release];
    
    
    // Add plot space for horizontal bar charts
    graph.paddingLeft = 90.0;
	graph.paddingTop = 50.0;
	graph.paddingRight = 20.0;
	graph.paddingBottom = 60.0;
    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate = self;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(6.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(10000)];
    
    // Setup grid line style
    CPTMutableLineStyle *majorXGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorXGridLineStyle.lineWidth = 1.0f;
    majorXGridLineStyle.lineColor = [[CPTColor grayColor] colorWithAlphaComponent:0.25f];
    
    // Setup x-Axis.
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.majorGridLineStyle = majorXGridLineStyle;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.minorTicksPerInterval = 1;

    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.title = @"Years";
    x.timeOffset = 30.0f;
 	NSArray *exclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)], nil];
	x.labelExclusionRanges = exclusionRanges;
    
    // Use custom x-axis label so it will display year 2010, 2011, 2012, ... instead of 1, 2, 3, 4
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[sampleYears count]];
    int idx = 0;
    for (NSString *year in sampleYears)
    {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:year textStyle:x.labelTextStyle];
        label.tickLocation = CPTDecimalFromInt(idx);
        label.offset = 5.0f;
        [labels addObject:label];
        [label release];
        idx++;
    }
    x.axisLabels = [NSSet setWithArray:labels];
    [labels release];
    
    // Setup y-Axis.
    CPTMutableLineStyle *majorYGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorYGridLineStyle.lineWidth = 1.0f;
    majorYGridLineStyle.dashPattern =  [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
    majorYGridLineStyle.lineColor = [[CPTColor lightGrayColor] colorWithAlphaComponent:0.25];
    
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorGridLineStyle = majorYGridLineStyle;
    y.majorIntervalLength = CPTDecimalFromString(@"1000");
    y.minorTicksPerInterval = 1;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.title = @"Consumer Spending";
    NSArray *yExlusionRanges = [NSArray arrayWithObjects:
                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(0.0)],
                                nil];
    y.labelExclusionRanges = yExlusionRanges;
    
    // Create a high plot area
	CPTScatterPlot *highPlot = [[[CPTScatterPlot alloc] init] autorelease];
    highPlot.identifier = kHighPlot;
    
    CPTMutableLineStyle *highLineStyle = [[highPlot.dataLineStyle mutableCopy] autorelease];
	highLineStyle.lineWidth = 2.f;
    highLineStyle.lineColor = [CPTColor colorWithComponentRed:0.50f green:0.67f blue:0.65f alpha:1.0f];
    highPlot.dataLineStyle = highLineStyle;
    highPlot.dataSource = self;
	
    CPTFill *areaFill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.50f green:0.67f blue:0.65f alpha:0.4f]];
    highPlot.areaFill = areaFill;
    highPlot.areaBaseValue = CPTDecimalFromString(@"0");
    [graph addPlot:highPlot];

    
    // Create the Savings Marker Plot
    selectedCoordination = 2;
    
    touchPlot = [[[CPTScatterPlot alloc] initWithFrame:CGRectNull] autorelease];
    touchPlot.identifier = kLinePlot;
    touchPlot.dataSource = self;
    touchPlot.delegate = self;
    [self applyTouchPlotColor];
    [graph addPlot:touchPlot];
    
    [pool drain];

}

// Assign different color to the touchable line symbol.
- (void)applyTouchPlotColor
{
    CPTColor *touchPlotColor = [CPTColor orangeColor];
    
    CPTMutableLineStyle *savingsPlotLineStyle = [CPTMutableLineStyle lineStyle];
    savingsPlotLineStyle.lineColor = touchPlotColor;
    
    CPTPlotSymbol *touchPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    touchPlotSymbol.fill = [CPTFill fillWithColor:touchPlotColor];
    touchPlotSymbol.lineStyle = savingsPlotLineStyle;
    touchPlotSymbol.size = CGSizeMake(15.0f, 15.0f); 
    
    
    touchPlot.plotSymbol = touchPlotSymbol;
    
    CPTMutableLineStyle *touchLineStyle = [CPTMutableLineStyle lineStyle];
    touchLineStyle.lineColor = [CPTColor orangeColor];
    touchLineStyle.lineWidth = 5.0f;
    
    touchPlot.dataLineStyle = touchLineStyle;
    
}

// Highlight the touch plot when the user holding tap on the line symbol.
- (void)applyHighLightPlotColor:(CPTScatterPlot *)plot
{
    CPTColor *selectedPlotColor = [CPTColor redColor];
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = selectedPlotColor;
    
    CPTPlotSymbol *plotSymbol = nil;
    plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:selectedPlotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(15.0f, 15.0f); 
    
    plot.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
    selectedLineStyle.lineColor = [CPTColor yellowColor];
    selectedLineStyle.lineWidth = 5.0f;
    
    plot.dataLineStyle = selectedLineStyle;
}

#pragma mark -
#pragma mark Plot Space Delegate Methods

// This implementation of this method will put the line graph in a fix position so it won't be scrollable.
-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate 
{
    
    if (coordinate == CPTCoordinateY) {
        return ((CPTXYPlotSpace *)space).yRange;
    }
    else
    {
        return ((CPTXYPlotSpace *)space).xRange;
    }
}

// This method is call when user touch & drag on the plot space.
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
    CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
    
    NSDecimal newPoint[2];
    [graph.defaultPlotSpace plotPoint:newPoint forPlotAreaViewPoint:pointInPlotArea];
    NSDecimalRound(&newPoint[0], &newPoint[0], 0, NSRoundPlain);
    int x = [[NSDecimalNumber decimalNumberWithDecimal:newPoint[0]] intValue];
    
    if (x < 0)
    {
        x = 0;
    }
    else if (x > [sampleData count])
    {
        x = [sampleData count];
    }
    
    if (touchPlotSelected) 
    {
        selectedCoordination = x;
        if ([delegate respondsToSelector:@selector(linePlot:indexLocation:)])
            [delegate linePlot:self indexLocation:x];
        [touchPlot reloadData];
    } 

    
    return YES;
}

#pragma mark - CPPlotSpace Delegate Methods
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    return YES;
}

#pragma mark - 
#pragma mark Scatter plot delegate methods

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    if ([(NSString *)plot.identifier isEqualToString:kLinePlot]) 
    {
        touchPlotSelected = YES;
    } 

    [self applyHighLightPlotColor:plot];
    if ([delegate respondsToSelector:@selector(linePlot:indexLocation:)])
        [delegate linePlot:self indexLocation:index];
}



#pragma mark -
#pragma mark Plot Data Source Methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot 
{
    if ([(NSString *)plot.identifier isEqualToString:kLinePlot]) 
    {
        return kNumberOfMarkerPlotSymbols;
    }
    else {
        return [sampleData count];
    }
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    NSNumber *num = nil;
    if ( [(NSString *)plot.identifier isEqualToString:kHighPlot] )
    {
        if ( fieldEnum == CPTScatterPlotFieldY ) 
        {
            num = [sampleData objectAtIndex:index];
        } 
        else if (fieldEnum == CPTScatterPlotFieldX) 
        {
            num = [NSNumber numberWithInt:index];
        }
    }
    else if ([(NSString *)plot.identifier isEqualToString:kLinePlot]) 
    {
        if ( fieldEnum == CPTScatterPlotFieldY ) 
        {
            switch (index) {
                case 0:
                    num = [NSNumber numberWithInt:0];
                    break;
                case 2:
                    num = [NSNumber numberWithInt:9700];
                    break;
                default:
                    num = [sampleData objectAtIndex:selectedCoordination];
                    break;
            }
        } 
        else if (fieldEnum == CPTScatterPlotFieldX) 
        {
            num = [NSNumber numberWithInt:selectedCoordination];
        }
    }
    return num;
}


@end
