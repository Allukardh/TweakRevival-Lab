#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>

// SnapVela - original, experimental, Photos-only tweak.
// There is no PHPhotoLibrary/PHAsset deletion interception.
static char kSVActionHandler;
static NSString *const kSVPrefs = @"/var/mobile/Library/Preferences/com.allukardh.snapvela.plist";

static NSDictionary *SVPrefs(void) {
    id o = [NSDictionary dictionaryWithContentsOfFile:kSVPrefs];
    return [o isKindOfClass:NSDictionary.class] ? o : @{};
}
static BOOL SVFlag(NSDictionary *p, NSString *key, BOOL def) {
    id o = p[key];
    return [o respondsToSelector:@selector(boolValue)] ? [o boolValue] : def;
}
static NSString *SVNormalize(NSString *s) {
    return [[(s ?: @"") stringByFoldingWithOptions:NSDiacriticInsensitiveSearch
                  locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]] lowercaseString];
}
static BOOL SVAny(NSString *s, NSArray *tokens) {
    for (NSString *token in tokens) if ([s containsString:token]) return YES;
    return NO;
}
static UIAlertAction *SVSafeCandidate(UIAlertController *alert) {
    if (alert.actions.count != 2) return nil;
    UIAlertAction *destructive = nil;
    BOOL cancel = NO;
    for (UIAlertAction *a in alert.actions) {
        if (a.style == UIAlertActionStyleCancel) cancel = YES;
        if (a.style == UIAlertActionStyleDestructive) {
            if (destructive) return nil;
            destructive = a;
        }
    }
    if (!cancel || !destructive || !destructive.enabled) return nil;
    NSString *button = SVNormalize(destructive.title);
    NSString *text = SVNormalize([NSString stringWithFormat:@"%@ %@ %@",
        alert.title ?: @"", alert.message ?: @"", destructive.title ?: @""]);
    // Fail closed unless destructive button clearly names photo/video.
    if (!SVAny(button, @[@"delete", @"apagar", @"excluir"]) ||
        !SVAny(button, @[@"photo", @"foto", @"video"])) return nil;
    // These UI contexts MUST always preserve native confirmations.
    if (SVAny(text, @[@"permanent", @"definitiv", @"irreversib", @"forever",
                      @"para sempre", @"shared album", @"album compartilh",
                      @"album partilh", @"remove from album", @"remover do album",
                      @"retirar do album", @"itens apagados"])) return nil;
    return destructive;
}

// Capture the action's original public UIKit callback, rather than KVC
// access to an undocumented UIAlertAction "handler" private property.
%hook UIAlertAction
+ (instancetype)actionWithTitle:(NSString *)title
                          style:(UIAlertActionStyle)style
                        handler:(void (^)(UIAlertAction *action))handler {
    UIAlertAction *action = %orig;
    if (action && handler)
        objc_setAssociatedObject(action, &kSVActionHandler,
                                 [handler copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    return action;
}
%end

%hook UIViewController
- (void)presentViewController:(UIViewController *)controller
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (![controller isKindOfClass:[UIAlertController class]]) {
        %orig;
        return;
    }
    NSDictionary *settings = SVPrefs();
    UIAlertController *alert = (UIAlertController *)controller;
    UIAlertAction *target = SVSafeCandidate(alert);
    if (SVFlag(settings, @"DiagnosticAlerts", NO))
        NSLog(@"[SnapVela] alert actions=%lu candidate=%d",
              (unsigned long)alert.actions.count, target != nil);
    if (!target || !SVFlag(settings, @"SkipConfirmation", NO) ||
        SVFlag(settings, @"DryRun", YES)) {
        %orig;
        return;
    }
    void (^originalHandler)(UIAlertAction *) = objc_getAssociatedObject(target, &kSVActionHandler);
    if (!originalHandler) {
        NSLog(@"[SnapVela] handler absent, falling back to native dialog");
        %orig;
        return;
    }
    // EXPERIMENTAL: Photos might require alert presentation/lifecycle.
    // The original Photos action, not a replacement delete API, is invoked.
    dispatch_async(dispatch_get_main_queue(), ^{
        originalHandler(target);
        if (completion) completion();
    });
}
%end

// Zoom is independent and opt-in. Only exact user-allowlisted scroll
// view class names can change; NEVER change every UIScrollView in Photos.
%hook UIScrollView
- (void)setMaximumZoomScale:(CGFloat)scale {
    NSDictionary *settings = SVPrefs();
    if (SVFlag(settings, @"DiagnosticZoom", NO) && scale > 1.1) {
        static NSMutableSet *seen;
        static dispatch_once_t once;
        dispatch_once(&once, ^{ seen = [NSMutableSet new]; });
        NSString *name = NSStringFromClass([self class]);
        @synchronized(seen) {
            if (![seen containsObject:name]) {
                [seen addObject:name];
                NSLog(@"[SnapVela] zoom class=%@ max=%g", name, (double)scale);
            }
        }
    }
    if (SVFlag(settings, @"ExtendedZoom", NO)) {
        NSArray *allowed = settings[@"ZoomClassNames"];
        NSString *name = NSStringFromClass([self class]);
        if ([allowed isKindOfClass:[NSArray class]] &&
            [allowed containsObject:name]) {
            id number = settings[@"ZoomMaxScale"];
            CGFloat limit = [number respondsToSelector:@selector(doubleValue)]
                            ? [number doubleValue] : 24.0;
            if (limit >= 2.0 && limit <= 40.0 && scale < limit)
                scale = limit;
        }
    }
    %orig(scale);
}
%end

%ctor {
    @autoreleasepool {
        if (![[NSBundle.mainBundle bundleIdentifier]
            isEqualToString:@"com.apple.mobileslideshow"]) return;
        %init;
        NSLog(@"[SnapVela] loaded (experimental)");
    }
}
