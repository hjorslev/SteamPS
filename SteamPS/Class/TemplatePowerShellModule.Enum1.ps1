# enums are a list of acceptable keys/values to use

enum EnumExample1 {
    Error
    Warning
    Information
    SuccessAudit
    FailureAudit
}

# enums can also have their own static value (key=value pair)
enum EnumExample2 {
    Error = 1001
    Warning = 1002
    Information = 1003
    SuccessAudit = 1004
    FailureAudit = 1005
}