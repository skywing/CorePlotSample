//
//  MyFontLabel.m
//  CorePlotSample
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Essence Work LLC.. All rights reserved.
//

#import "MyFontLabel.h"

@implementation MyFontLabel

- (id)init
{
    self = [super init];
    if (self) 
    {
        [self setFont:[UIFont fontWithName:@"Ingleby Regular" size:self.font.pointSize]];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setFont:[UIFont fontWithName:@"Ingleby Regular" size:self.font.pointSize]];
    }
    return self;
}

@end
