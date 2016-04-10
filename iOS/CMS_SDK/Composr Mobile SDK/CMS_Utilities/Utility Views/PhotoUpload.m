//
//  PhotoUpload.m
//  Composr Mobile SDK
//
//  Created by Aaswini on 02/09/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

#import "PhotoUpload.h"

@implementation PhotoUpload

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) initialize{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:singleTap];
    [self setUserInteractionEnabled:YES];
}

- (void)didTap:(UITapGestureRecognizer *)sender{
    [[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select from album",@"Use Camera",nil ] showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clicked action sheet button - %d",buttonIndex);
    switch (buttonIndex) {
        case 0:
            [self showPickerWithCamera:NO];
            break;
            
        case 1:
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [[[UIAlertView alloc] initWithTitle:@"Oops !!" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else{
                [self showPickerWithCamera:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void) showPickerWithCamera:(BOOL)useCamera{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (useCamera) {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
    }
    else{
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [[self viewController] presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

@end
