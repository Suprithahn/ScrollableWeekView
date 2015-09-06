//
//  WeekView.m
//  ScrollableWeekView
//
//  Created by Suprithahn on 04/08/15.
// 
//

#import "WeekView.h"
#import "DayView.h"

#define DAYS  7


@interface WeekView ()

@property (nonatomic, strong) NSCalendar *gregorianCalendar;

@end

@implementation WeekView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        self.frame = frame;
    }
    return self;
}

-(void)setWeekStartDate:(NSDate *)weekStartDate{
    
    _weekStartDate = weekStartDate;
    [self configureWeekView];
}


#pragma Private methods

- (NSString *)weekdayNameFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [[[dateFormatter stringFromDate:date] uppercaseString] substringToIndex:1];
}

- (NSInteger)weekdayNumberFromDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dateComponent = [calendar component:NSCalendarUnitDay fromDate:date];
    return dateComponent;
}

- (NSDate *)newDateByAddingDays:(NSInteger)numberOfdays toDate:(NSDate *)date{
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:numberOfdays];
    return  [self.gregorianCalendar dateByAddingComponents:dateComponents toDate:date options:0];
}

- (void)configureWeekView{

    //Clear off old data if any
    for(UIView *view in [self subviews]){
        [view removeFromSuperview];
    }
    CGFloat dayCellheight = CGRectGetHeight(self.frame);
    CGFloat dayCellWidth = CGRectGetWidth(self.frame)/DAYS;
    
    for (int day = 0; day < DAYS; day++) {
        NSDate *date = [self newDateByAddingDays:day toDate:self.weekStartDate];
        CGRect frame = CGRectMake(dayCellWidth*day, 0, dayCellWidth, dayCellheight);
        UIView *dayCell = [self dayCellViewForDate:date withFrame:frame];
        dayCell.tag = day;
        [self addSubview:dayCell];
    }

}

- (UIView *)dayCellViewForDate:(NSDate *)date withFrame:(CGRect) frame{
    
    DayView *dayView = [[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:self options:0] objectAtIndex:0];
    dayView.frame = frame;
    dayView.dayLabel.text = [self weekdayNameFromDate:date];
    dayView.dateBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)[self weekdayNumberFromDate:date]] ;
    [dayView.dateBtn setTitle:[NSString stringWithFormat:@"%ld",(long)[self weekdayNumberFromDate:date]]
                     forState:UIControlStateNormal];
    [dayView.dateBtn addTarget:self action:@selector(dayTapped:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isToday = [self isDate:date sameAsOtherDate:[NSDate date]];
    dayView.dateBtn.layer.cornerRadius = 3.5;
    dayView.date = date;
    if (isToday) {
        dayView.dateBtn.layer.borderWidth = 2;
        dayView.dateBtn.layer.borderColor = [UIColor blueColor].CGColor;
        dayView.dateBtn.backgroundColor = [UIColor cyanColor];
    }
    return dayView;
}

- (void)dayTapped:(id)sender{
    
    [self clearSelection];
    UIButton *dateBtn = (UIButton *)sender;
    DayView *dayView =(DayView *) dateBtn.superview;
    dayView.dateBtn.backgroundColor = [UIColor cyanColor];
    if ([self.delegate respondsToSelector:@selector(WeekView:didSelectDate:)]) {
        [self.delegate WeekView:self didSelectDate:dayView.date];
    }
}

-(void)setWeekViewWithSelectedDate:(NSDate *)date{
    for(DayView *view in [self subviews]){
        BOOL isMatching = [self isDate:view.date sameAsOtherDate:date];
        if (isMatching) {
            [self dayTapped:view.dateBtn];
        }
    }
}

- (void)clearSelection{
    for(DayView *view in [self subviews]){
        view.dateBtn.backgroundColor = [UIColor clearColor];
    }
}

- (BOOL)isDate :(NSDate *)date sameAsOtherDate:(NSDate *)otherDate{
    
    NSDateComponents *dateComponents = [self.gregorianCalendar components:(NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay)
                                                                 fromDate:date];
    NSDateComponents *otherDateComponents = [self.gregorianCalendar components:(NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay)
                                                                      fromDate:otherDate];
    return ([dateComponents isEqual:otherDateComponents]);
}
@end
