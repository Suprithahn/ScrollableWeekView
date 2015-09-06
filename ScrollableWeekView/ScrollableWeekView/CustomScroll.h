//
//  CustomScroll.h
//  WeekViewSample
//
//  Created by Suprithahn on 03/08/15.
// 
//

#import <UIKit/UIKit.h>

@protocol WeekSelectorDelegate <NSObject>

-(void)weekSelectorDidSelectDate:(NSDate *)selectedDate;

@end

@interface CustomScroll : UIScrollView

@property (nonatomic, assign) id <WeekSelectorDelegate> WeekSelectorDelegate;
@property (nonatomic, strong) NSDate *selectedDate;

- (void) buildWeekViewsWithSelectedDate:(NSDate *)selectedDate;

- (void) weekViewScolledIndirection:(BOOL)isRight;

- (void) rebuildViews;

@end
