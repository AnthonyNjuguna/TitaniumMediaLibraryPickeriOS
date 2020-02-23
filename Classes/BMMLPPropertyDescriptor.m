//
//  PropertyHelper.m
//  BMCommons
//
//  Created by Werner Altewischer on 09/11/09.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import "BMMLPPropertyDescriptor.h"

@interface BMMLPPropertyDescriptor()

- (void)setPropertyName:(NSString *)theName;

@end


@implementation BMMLPPropertyDescriptor

@synthesize keyPath, target;
@synthesize getters;
@synthesize setter;
@synthesize propertyName;
@synthesize valueTransformer;

//Private
- (void)setGetters:(NSArray *)theGetters {
	if (getters != theGetters) {
		getters = theGetters;
	}
}

- (void)setSetter:(NSString *)theSetter {
	if (setter != theSetter) {
		setter = theSetter;
	}
}

- (id)initWithKeyPath:(NSString *)theKeyPath target:(id)theTarget {
	if ((self = [super init])) {
		self.keyPath = theKeyPath;
		self.target = theTarget;
	}
	return self;
}

- (void)dealloc {
	self.keyPath = nil;
}

- (id)callGetter {
	return [self callGetterOnTarget:target];
}

- (void)callSetter:(id)value {
	[self callSetterOnTarget:target withValue:value];
}

- (id)callGetterOnTarget:(id)t {
	return [self callGetterOnTarget:t ignoreFailure:NO];
}

- (void)callSetterOnTarget:(id)t withValue:(id)value {
	[self callSetterOnTarget:t withValue:value ignoreFailure:NO];
}

- (id)callGetterWithIgnoreFailure:(BOOL)ignoreFailure {
	return [self callGetterOnTarget:self.target ignoreFailure:ignoreFailure];
}
- (void)callSetter:(id)value ignoreFailure:(BOOL)ignoreFailure {
	[self callSetterOnTarget:self.target withValue:value ignoreFailure:ignoreFailure];
}


/**
 @brief Calls the getter on a specified target, optionally ignoring a failure if the property could not be read
 */
- (id)callGetterOnTarget:(id)t ignoreFailure:(BOOL)ignoreFailure {
	for (NSString *ivar in self.getters) {
		if (t == nil) {
			break;
		}
		SEL getter = NSSelectorFromString(ivar);
		if (!ignoreFailure || [t respondsToSelector:getter]) {
			t = [t performSelector:getter];
		} else {
			t = nil;
			break;
		}
	}
	if (self.valueTransformer && t) {
		//Convert the value first if a value transformer was set
		t = [self.valueTransformer reverseTransformedValue:t];
	}
	return t;
}

/**
 @brief Calls the setter on a specified target, optionally ignoring a failure if the property could not be written
 */
- (void)callSetterOnTarget:(id)t withValue:(id)value ignoreFailure:(BOOL)ignoreFailure {
	if (self.getters.count > 0) {
		for (int i = 0; i < (self.getters.count - 1); ++i) {
			if (t == nil) {
				break;
			}
			NSString *ivar = [self.getters objectAtIndex:i];
			SEL getterSelector = NSSelectorFromString(ivar);
			
			if (!ignoreFailure || [t respondsToSelector:getterSelector]) {
				t = [t performSelector:getterSelector];
			} else {
				t = nil;
				break;
			}
		}
	}
	if (t != nil) {
		SEL setterSelector = NSSelectorFromString(setter);
		if (!ignoreFailure || [t respondsToSelector:setterSelector]) {
			if (self.valueTransformer && value) {
				//Convert the value first if a value transformer was set
				value = [self.valueTransformer transformedValue:value];
			}
			[t performSelector:setterSelector withObject:value];
		}
	}
}


- (void)setKeyPath:(NSString *)theKeyPath {
	if (keyPath != theKeyPath) {
		keyPath = theKeyPath;
		
		if (keyPath) {
            NSArray *components = [keyPath componentsSeparatedByString:@"."];
            NSMutableArray *theGetters = [NSMutableArray arrayWithCapacity:components.count];
            for (NSString *ivar in components) {
                [theGetters addObject:ivar];
            }
            
            NSString *setterSelector = nil;
            if (components.count > 0) {
                NSString *ivar = [components objectAtIndex:(components.count - 1)];
                
                if (ivar.length > 0) {
                    NSString *firstCharUpperCase = [[ivar substringToIndex:1] capitalizedString];
                    NSString *remainingPart = [ivar substringFromIndex:1];
                    
                    setterSelector = [NSString stringWithFormat:@"set%@%@:", firstCharUpperCase, remainingPart];
                }
                
                self.propertyName = ivar;
            }
            
            self.getters = theGetters.count == 0 ? nil : theGetters;
            self.setter = setterSelector;
        } else {
            self.getters = nil;
            self.setter = nil;
        }
    }
}

- (BOOL)validateValue:(id *)value withError:(NSError **)error {
	return [self validateValue:value onTarget:self.target withError:error];
}

- (BOOL)validateValue:(id *)value onTarget:(id)t withError:(NSError **)error {
	if (self.getters.count > 0) {
		for (int i = 0; i < (self.getters.count - 1); ++i) {
			NSString *ivar = [self.getters objectAtIndex:i];
			SEL getterSelector = NSSelectorFromString(ivar);
			t = [t performSelector:getterSelector];
		}
	}
	return t == nil || [t validateValue:value forKey:self.propertyName error:error];
}

- (BMMLPPropertyDescriptor *)parentDescriptor {
	BMMLPPropertyDescriptor *pd = nil;
	if (self.getters.count > 1) {
		NSMutableString *theKeyPath = [NSMutableString string];
		for (int i = 0; i < self.getters.count - 1; ++i) {
			NSString *getter = [self.getters objectAtIndex:i];
			if (i > 0) {
				[theKeyPath appendString:@"."];
			}
			[theKeyPath appendString:getter];
		}
		pd = [BMMLPPropertyDescriptor propertyDescriptorFromKeyPath:theKeyPath withTarget:self.target];
	} 
	return pd;
}

+ (BMMLPPropertyDescriptor *)propertyDescriptorFromKeyPath:(NSString *)theKeyPath withTarget:(NSObject *)theTarget {
	BMMLPPropertyDescriptor *pd = [[BMMLPPropertyDescriptor alloc] initWithKeyPath:theKeyPath target:theTarget];
	return pd;
}

- (void)setPropertyName:(NSString *)theName {
	if (propertyName != theName) {
		propertyName = theName;
	}
}

@end
