%returns true if specified string is a field/column in the specified table

function o=isvariable(t,field)

o=any(strcmp(field,fieldnames(t)));