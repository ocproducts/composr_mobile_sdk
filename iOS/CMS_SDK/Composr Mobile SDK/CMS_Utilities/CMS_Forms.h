//
//  CMS_Forms.h
//  Composr Mobile SDK
//
//  Created by Aaswini on 06/08/14.
//  Copyright (c) 2014 Aaswini. All rights reserved.
//

/*
 
 CMS_Forms (non-static, each object will track display coordinates as new fields are added, hidden parameters, the intro text, the target URL, the button name, and references between UI inputs and parameter names)
 
 form_input_field_spacer(string heading, string text) - put a heading into the form
 void form_input_hidden(string paramName, string paramValue) -
 object form_input_integer(string prettyName, string description, string paramName, string defaultValue, bool isRequired) - defaultValue is either blank or a numeric string
 object form_input_float(string prettyName, string description, string paramName, string defaultValue, bool isRequired) - defaultValue is either blank or a numeric string
 object form_input_line(string prettyName, string description, string paramName, string defaultValue, bool isRequired) - inputs a single line of text
 object form_input_list(string prettyName, string description, string paramName, map options, string defaultValue, bool isRequired) - options is a map between actual inputted values and the displayed labels
 object form_input_text(string prettyName, string description, string paramName, string defaultValue, bool isRequired) - inputs multiple lines of text
 object form_input_tick(string prettyName, string description, string paramName, bool defaultValue)
 object form_input_uploaded_picture(string prettyName, string description, string paramName, bool isRequired)
 object form_input_date(string prettyName, string description, string paramName, bool isRequired, string defaultValue, bool includeTimeChoice) - defaultValue is either blank or a numeric string (unix timestamp)
 int get_input_date(string paramName) - get unix timestamp from a named date input
 string post_param_string(string paramName) - get value of a named input
 int post_param_integer(string paramName) - get value of a named input, as an integer
 void set_intro_text(string text)
 void set_url(string url)
 void set_button(string name, callback callback)
 void do_http_post_request(callback callback) - converts form into an HTTP request, and sends the HTTP response to the given callback; should automatically add and remove a progress spinner and lock out the UI temporarily
 
 */

#import <Foundation/Foundation.h>

typedef enum
{
	Input_Field_Hidden = 0,
	Input_Field_Spacer = 1,
	Input_Field_Integer = 2,
	Input_Field_Float = 3,
	Input_Field_Line = 4,
	Input_Field_List = 5,
	Input_Field_Text = 6,
	Input_Field_Tick = 7,
	Input_Field_Upload_Picture = 8,
	Input_Field_Date = 9
} fieldType;

@interface CMS_Forms : UIView<UITextFieldDelegate>

- (void)form_input_field_spacer_withHeading:(NSString *)heading withText:(NSString *)text;
- (void)form_input_hidden_withParamName:(NSString *)paramName withParamValue:(NSString *)paramValue;
- (id)form_input_integer_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired;
- (id)form_input_float_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired;
- (id)form_input_line_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired;
- (id)form_input_password_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired;
- (id)form_input_list_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withOptions:(NSDictionary *)options withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired;
- (id)form_input_text_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(NSString *)defaultValue isRequired:(BOOL)isRequired;
- (id)form_input_tick_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName withDefaultValue:(BOOL)defaultValue;
- (id)form_input_uploaded_picture_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName isRequired:(BOOL)isRequired;
- (id)form_input_date_withPrettyName:(NSString *)prettyName withDescription:(NSString *)description withParamName:(NSString *)paramName isRequired:(BOOL)isRequired withDefaultValue:(NSString *)defaultValue includeTimeChoice:(BOOL)includeTimeChoice;
- (int)get_input_date:(NSString *)paramName;
- (NSString *)post_param_string:(NSString *)paramName;
- (int)post_param_integer:(NSString *)paramName;
- (void)set_intro_text:(NSString *)text;
- (void)set_url:(NSString *)url;
- (void)set_button_withName:(NSString *)name preSubmitGuard:(SEL)preSubmitGuard postCallback:(SEL)postCallback autoSubmit:(BOOL)autoSubmit;
- (void)do_http_post_request;

- (NSDictionary *)getFormValues;

@property (nonatomic,weak) id delegate;

@end
