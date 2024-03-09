#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <Carbon/Carbon.h> // For key codes

#ifdef DEBUG
#include <stdio.h>
#endif

void simulateRightArrow();

CGEventRef eventTapCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *userInfo) {
    // Check if the event is a key down event
    if (type == kCGEventKeyDown) {
        // Get the key code and modifier flags from the event
        CGKeyCode keyCode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
        CGEventFlags modifierFlags = CGEventGetFlags(event);
        
        // Check if the Option and Shift keys are pressed and the key code matches Left Arrow (key code 123)
        BOOL isOptionShiftLeftArrow = (modifierFlags & (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)) == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift) && keyCode == kVK_LeftArrow;
        
        if (isOptionShiftLeftArrow) {
            #ifdef DEBUG
            printf("Matched ⌥ + ⇧ + ←!\n");
            #endif
            // Simulate the right arrow key press without the shift modifier
            simulateRightArrow();
            
            // Cancel the original left arrow key event by returning NULL
            return NULL;
        }
    }
    
    // For all other events, return the event as-is
    return event;
}

void simulateRightArrow() {
    CGKeyCode rightArrowKeyCode = kVK_RightArrow;
    
    // Create a source state for the keyboard event that does not include any modifier keys
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    
    // Simulate pressing the right arrow key without any modifier flags
    CGEventRef keyDownEvent = CGEventCreateKeyboardEvent(source, rightArrowKeyCode, true);
    CGEventSetFlags(keyDownEvent, 0); // Clear all modifier flags
    CGEventPost(kCGHIDEventTap, keyDownEvent);
    CFRelease(keyDownEvent);
    
    // Simulate releasing the right arrow key without any modifier flags
    CGEventRef keyUpEvent = CGEventCreateKeyboardEvent(source, rightArrowKeyCode, false);
    CGEventSetFlags(keyUpEvent, 0); // Clear all modifier flags
    CGEventPost(kCGHIDEventTap, keyUpEvent);
    CFRelease(keyUpEvent);
    
    CFRelease(source);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Set up the event tap
        CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown), eventTapCallback, NULL);
        
        if (!eventTap) {
            NSLog(@"Failed to create event tap");
            exit(1);
        }
        
        // Create a run loop source for the event tap
        CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        
        // Add the run loop source to the current run loop
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        
        // Enable the event tap
        CGEventTapEnable(eventTap, true);
        
        #ifdef DEBUG
        printf("Running!\n");
        #endif

        // Run the current run loop
        CFRunLoopRun();
        
        // Clean up
        CFRelease(runLoopSource);
        CFRelease(eventTap);
    }
    return 0;
}
