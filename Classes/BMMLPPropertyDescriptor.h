//
//  PropertyHelper.h
//  BMCommons
//
//  Created by Werner Altewischer on 09/11/09.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief Class to describe/access a property on a specified target object.
 */
@interface BMMLPPropertyDescriptor : NSObject {
	NSString *propertyName;
	NSString *keyPath;
	NSString *setter;
	NSArray *getters;
	NSObject *target;
	NSValueTransformer *valueTransformer;
}

/**
 @brief the keyPath to the property.
 */
@property (nonatomic, strong) NSString *keyPath;

/**
 @brief ordered array of selector names for the getters for the specified property (if keyPath is multiple levels deep more that one getter may be present, one for each level).
 */
@property (nonatomic, readonly) NSArray *getters;

/**
 @brief selector name of the setter for the property.
 */
@property (nonatomic, readonly) NSString *setter;

/**
 @brief the name of the leaf property, is the last part of the keypath or equal to the key path if the keypath is single level (contains no dots).
 */
@property (nonatomic, readonly) NSString *propertyName;

/**
 @brief the target object to access the property from.
 */
@property (nonatomic, strong) NSObject *target;

/**
 @brief Optional value transformer for converting the value before settings it (forward transformation) or convert it back before getting it (reverse transformation).
 */
@property (nonatomic, strong) NSValueTransformer *valueTransformer;

/**
 @brief Constructs and returns a property descriptor with the specified key path and target
 */
+ (BMMLPPropertyDescriptor *)propertyDescriptorFromKeyPath:(NSString *)theKeyPath withTarget:(NSObject *)theTarget;

/**
 @brief Initializer
 */
- (id)initWithKeyPath:(NSString *)theKeyPath target:(id)theTarget;

/**
 @brief Calls the getter on the target and returns the value.
 */
- (id)callGetter;

/**
 @brief Calls the setter on the target with the specified value.
 */
- (void)callSetter:(id)value;

/**
 @brief Calls the getter on the target set by optionally ignoring any failures.
 */
- (id)callGetterWithIgnoreFailure:(BOOL)ignoreFailure;

/**
 @brief Calls the setter on the target set by optionally ignoring any failures.
 */
- (void)callSetter:(id)value ignoreFailure:(BOOL)ignoreFailure;

/**
 @brief Calls the getter on a specified target. Fails if the property could not be found or read.
 */
- (id)callGetterOnTarget:(id)target;

/**
 @brief Calls the setter on a specified target with the specified value. Fails if th property could not be found or written.
 */
- (void)callSetterOnTarget:(id)target withValue:(id)value;

/**
 @brief Calls the getter on a specified target, optionally ignoring a failure if the property could not be found or read
 */
- (id)callGetterOnTarget:(id)target ignoreFailure:(BOOL)ignoreFailure;

/**
 @brief Calls the setter on a specified target, optionally ignoring a failure if the property could not be found or written
 */
- (void)callSetterOnTarget:(id)target withValue:(id)value ignoreFailure:(BOOL)ignoreFailure;

/**
 @brief Validates the value corresponding with the property using KVO validation methods. Returns true if valid, false otherwise.
 */
- (BOOL)validateValue:(id*)value withError:(NSError **)error;

/**
 @brief Validates the value corresponding with the property using KVO validation methods. Returns true if valid, false otherwise.
 */
- (BOOL)validateValue:(id*)value onTarget:(id)target withError:(NSError **)error;

/**
 @brief Returns the descriptor for the parent property in case the keypath contains more than 1 components. Otherwise nil is returned.
 */
- (BMMLPPropertyDescriptor *)parentDescriptor;

@end
