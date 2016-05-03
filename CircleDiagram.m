//  CircleDiagram.m
//  Created by Aleksandr_Bydaiev.


#import "CircleViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Period.h"
#import "Circle.h"
#import "CoreDataManager.h"

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

typedef enum : NSUInteger {
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December,
    January,
    February,
    March,
} Month;

static NSInteger const kRadius = 100;

@interface CircleViewController ()

@property (strong, nonatomic) Period *period;
@property (strong, nonatomic) IBOutlet UIView *backGround;
@property (strong, nonatomic) IBOutlet UIView *diagram;
@property (strong, nonatomic) IBOutlet UIView *frontView;
@property (strong, nonatomic) IBOutlet UIPageControl *yearPage;
@property (strong, nonatomic) IBOutlet UILabel *yearCenter;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *monthLabels;

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _backGround.layer.cornerRadius = kRadius;
    [_backGround.layer setBackgroundColor:[UIColor colorWithRed:136.0f/255.0f green:219.0f/255.0f blue:240.0f/255.0f alpha:0.5f].CGColor];
    
    _front.layer.cornerRadius = kRadius/2;
    
    NSArray *attendDays = @[@(0), @(23), @(0), @(27), @(0), @(30), @(18), @(30), @(17), @(30), @(0), @(13)];
    
    NSInteger i = 0;
    for (NSNumber *day in attendDays) {
        CAShapeLayer *layer = [self createCircle:day.integerValue month:i angle:i * 30];
        [self.view.layer addSublayer:layer];
        
        UILabel *monthLabel = _monthLabels[i];
        
        monthLabel.text = [NSString stringWithFormat:@"%@ дней", day];
        monthLabel.hidden = day.integerValue < 1;
        
        i++;
    }
}

- (CAShapeLayer *)createCircle:(NSInteger)dayCount month:(Month)month angle:(NSInteger)angle {
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = [[UIColor colorWithRed:136.0f / 255.0f green:219.0f / 255.0f blue:240.0f / 255.0f alpha:1.0f] CGColor];
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.view.frame) / 2.0f, 150.0f);
    CGFloat startAngle = DEGREES_TO_RADIANS(angle);
    CGFloat endAngle = 365.0f / 360.0f * dayCount + angle;
    
    NSLog(@"Month %@ Start %@ Finish %@",@(month), @(angle), @(endAngle));
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    
    [piePath addLineToPoint:CGPointMake(center.x + kRadius * cosf(startAngle), center.y + kRadius * sinf(startAngle))];
    [piePath addArcWithCenter:center radius:kRadius startAngle:startAngle endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:YES];
    [piePath closePath];
    
    slice.path = piePath.CGPath;
    
    return slice;
}

@end
