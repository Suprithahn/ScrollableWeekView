//
//  WeekView.h
//  ScrollableWeekView
//
//  Created by Suprithahn on 04/08/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DayType){
    DayTypeUnKnown = 0,
    DayTypeSunday,
    DayTypeMonday,
    DayTypeTuesday,
    DayTypeWednesday,
    DayTypeThursday,
    DayTypeFriday,
    DayTypeSaturday
};

@class WeekView;

@protocol WeekViewDelegate <NSObject>

- (void)WeekView:(WeekView *)weekView didSelectDate:(NSDate*) dateSelecetd;

@end

@interface WeekView : UIView

@property (nonatomic, strong) NSDate* weekStartDate;
@property (nonatomic, assign) id <WeekViewDelegate> delegate;

- (void)clearSelection;
- (void)setWeekViewWithSelectedDate:(NSDate *)date;

@end
