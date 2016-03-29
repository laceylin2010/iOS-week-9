//
//  BurgerContainerViewController.m
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "BurgerContainerViewController.h"
#import "MenuViewController.h"
#import "UserSearchViewController.h"
#import "QuestionSearchViewController.h"

CGFloat const kBurgerOpenScreenDivider = 3.0;
CGFloat const kBurgerOpenScreenMultiplier = 2.0;

CGFloat const kBurgerButtonWidth = 50.0;

NSTimeInterval const kTimeToSlideOpen = 0.2;
NSTimeInterval const kTimeToSlideClosed = 0.15;


@interface BurgerContainerViewController () <UITableViewDelegate>

@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) QuestionSearchViewController *questionSearchVC;
@property (strong, nonatomic) UserSearchViewController *userSearchVC;

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) NSArray *viewControllers;

@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation BurgerContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuViewController];
    [self setupInitialContentViewController];
    [self setupAdditionViewController];
    
    
    self.viewControllers = @[self.questionSearchVC, self.userSearchVC];
    
    self.topViewController = self.viewControllers[0];
    
    [self setupPanGesture];
    [self setupBurgerButtonWithImageName:@"menu"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

+(NSString *)identifier
{
    return @"BurgerContainerViewController";
}

-(void)setupMenuViewController
{
    MenuViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:[MenuViewController identifier]];
    
    [self setupChildViewController:menuVC onScreen:YES];
    self.menuViewController = menuVC;
    
    menuVC.tableView.delegate = self;
}

-(void)setupInitialContentViewController
{
    QuestionSearchViewController *questionsSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:[QuestionSearchViewController identifier]];
    [self setupChildViewController:questionsSearchVC onScreen:true];
    
    self.questionSearchVC = questionsSearchVC;
}

-(void)setupAdditionViewController
{
    UserSearchViewController *userSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:[UserSearchViewController identifier]];
    
    [self setupChildViewController:userSearchVC onScreen:false];
    
    self.userSearchVC = userSearchVC;
    
    
}

-(void)setupChildViewController:(UIViewController *)viewController onScreen:(BOOL)onScreen
{
    if (onScreen) {
        viewController.view.frame = self.view.frame;
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }else {
        viewController.view.frame = [self offScreenLocation];
    }
}

-(void)removeChildVC:(UIViewController *)viewController
{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

-(CGRect)offScreenLocation
{
    CGFloat offScreenLocationX = self.view.frame.size.width;
    CGFloat offScreenLoactionY = self.view.frame.origin.y;
    CGFloat offScreenWidth = self.view.frame.size.width;
    CGFloat offScreenHeight = self.view.frame.size.height;
    
    CGRect result = CGRectMake(offScreenLocationX, offScreenLoactionY, offScreenWidth, offScreenHeight);
    
    return result;
}

#pragma mark - Pan Gesture

-(void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
    
    [self.topViewController.view addGestureRecognizer:pan];
    
    self.panGesture = pan;
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self panGestureStateChangedWithSender:sender];
    } else {
        [self panGestureStateEnded];
    }
}

-(void)panGestureStateChangedWithSender:(UIPanGestureRecognizer *)sender
{
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    
    CGPoint centerBeforeChange = self.topViewController.view.center;
    CGPoint newCenter = CGPointMake(centerBeforeChange.x + translation.x, centerBeforeChange.y);
    
    if (velocity.x > 0) {
        self.topViewController.view.center = newCenter;
        [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
}

-(void)panGestureStateEnded
{
    CGFloat currentX = self.topViewController.view.frame.origin.x;
    CGFloat widthValue = self.topViewController.view.frame.size.width;
    CGPoint menuOpenLocation = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
    CGPoint menuCloseLocation = CGPointMake(self.view.center.x, self.view.center.y);
    
    if (currentX > widthValue / kBurgerOpenScreenDivider) {
        [UIView animateWithDuration:kTimeToSlideOpen animations:^{
            self.topViewController.view.center = menuOpenLocation; //memory leaks because of self within a block
        } completion:^(BOOL finished) {
            [self setupTapGesture];
            self.burgerButton.userInteractionEnabled = false;
        }];
    } else {
        [UIView animateWithDuration:kTimeToSlideOpen animations:^{
            self.topViewController.view.center = menuCloseLocation;
        } completion:^(BOOL finished) {
            NSLog(@"User Did not open menu far enough to lock");
        }];
    }
    
}


-(void)setupTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    
}


-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap
{
    [self.topViewController.view removeGestureRecognizer:tap];
    [UIView animateWithDuration:kTimeToSlideClosed animations:^{
        self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
        self.burgerButton.userInteractionEnabled = true;
    }];
}

-(void)setupBurgerButtonWithImageName:(NSString *)imageNamed
{
    CGRect burgerSize = CGRectMake(0,30, kBurgerButtonWidth, kBurgerButtonWidth);
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:burgerSize];
    UIImage *buttonImage = [UIImage imageNamed:imageNamed];
    
    [burgerButton setImage:buttonImage forState:UIControlStateNormal];
    [self.topViewController.view addSubview:burgerButton];
    
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.burgerButton = burgerButton;
}

-(void)burgerButtonPressed:(UIButton *)sender
{
    CGPoint newCenter = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
    [UIView animateWithDuration:kTimeToSlideOpen animations:^{
        self.topViewController.view.center = newCenter;
    } completion:^(BOOL finished) {
        [self setupTapGesture];
        sender.userInteractionEnabled = false;
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = self.viewControllers[indexPath.row];
    
    if (![viewController isEqual:self.topViewController]) {
        
        [self switchToViewController:viewController];
    }
}

-(void)replaceTopViewControllerWith:(UIViewController *)viewController
{
    [self setupChildViewController:viewController onScreen:false];
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    [self removeChildVC:self.topViewController];
    self.topViewController = viewController;
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
}

-(void)switchToViewController:(UIViewController *)viewController
{
    [UIView animateWithDuration:kTimeToSlideOpen animations:^{
        self.topViewController.view.frame = [self offScreenLocation];
    } completion:^(BOOL finished) {
        [self replaceTopViewControllerWith:viewController];
        
        [UIView animateWithDuration:kTimeToSlideClosed animations:^{
            self.topViewController.view.center = self.view.center;
        } completion:^(BOOL finished) {
            [self.topViewController.view addGestureRecognizer:self.panGesture];
            self.burgerButton.userInteractionEnabled = true;
        }];
    }];
    
}

@end
