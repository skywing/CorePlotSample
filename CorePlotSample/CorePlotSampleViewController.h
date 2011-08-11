//
//  CorePlotSampleViewController.h
//  CorePlotSample
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Essence Work LLC.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "EskBarPlot.h"
#import "EskLinePlot.h"

@interface CorePlotSampleViewController : UIViewController <EskBarPlotDelegate, EskLinePlotDelegate>
{
  @private
    EskBarPlot *barPlot;
    EskLinePlot *linePlot;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet CPTGraphHostingView *barHostingView;
@property (nonatomic, retain) IBOutlet CPTGraphHostingView *lineHostingView;
@property (nonatomic, retain) IBOutlet UILabel *selectedYearLabel;
@property (nonatomic, retain) IBOutlet UILabel *spendingPerYearLabel;
@property (nonatomic, retain) IBOutlet UILabel *selectedProductLabel;
@property (nonatomic, retain) IBOutlet UILabel *costPerUnitLabel;

@end
