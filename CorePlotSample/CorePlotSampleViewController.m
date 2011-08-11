//
//  CorePlotSampleViewController.m
//  CorePlotSample
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Essence Work LLC.. All rights reserved.
//

#import "CorePlotSampleViewController.h"
#import "EskPlotTheme.h"

@implementation CorePlotSampleViewController

@synthesize titleLabel;
@synthesize barHostingView, lineHostingView;
@synthesize selectedYearLabel, selectedProductLabel, costPerUnitLabel, spendingPerYearLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [titleLabel release];
    [barPlot release];
    [linePlot release];
    [selectedYearLabel release];
    [selectedProductLabel release];
    [costPerUnitLabel release];
    [spendingPerYearLabel release];
    [super dealloc];
}

#pragma mark - BarPlot delegate
- (void)barPlot:(EskBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    selectedProductLabel.text = [NSString stringWithFormat:@"Selected Product: %@", [plot.sampleProduct objectAtIndex:index]];
    costPerUnitLabel.text = [NSString stringWithFormat:@"Cost Per Unit: $%@", [plot.sampleData objectAtIndex:index]];
}

#pragma mark - LinePlot delegate
- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index
{
    selectedYearLabel.text = [NSString stringWithFormat:@"Selected Year: %@", [plot.sampleYears objectAtIndex:index]];
    spendingPerYearLabel.text = [NSString stringWithFormat:@"Spending Per Year: $%@", [plot.sampleData objectAtIndex:index]];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // change the title label font to bold intalic and larger
    [titleLabel setFont:[UIFont fontWithName:@"Ingleby-BoldItalic" size:36.0f]];
    
    
    EskPlotTheme *defaultTheme = [[EskPlotTheme alloc] init];
    
    barPlot = [[EskBarPlot alloc] init];
    barPlot.delegate = self;
    [barPlot renderInLayer:barHostingView withTheme:defaultTheme];
    
    linePlot = [[EskLinePlot alloc] init];
    linePlot.delegate = self;
    [linePlot renderInLayer:lineHostingView withTheme:defaultTheme];
    
    [defaultTheme release];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
