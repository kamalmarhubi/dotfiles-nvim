; inherits: c
(class_specifier
  body: (_) @class.inner) @class.outer

(for_range_loop 
  (_)? @loop.inner) @loop.outer

(template_declaration
  (function_definition) @function.outer) @function.outer.start

(template_declaration
  (struct_specifier) @class.outer) @class.outer.start

(template_declaration
  (class_specifier) @class.outer) @class.outer.start

(parameter_list
  (optional_parameter_declaration) @parameter.inner)

(new_expression
  (argument_list) @call.inner) @call.outer
