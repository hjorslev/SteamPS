# Base PowerShell 5 Class

class Class1 {
    # Public Properties are exposed and can be {get; set;}
    # Public poperties are Instance type properties
    [String] $StringProperty
    [Int32] $IntegerPropery

    # Static Properties are Class type properties
    # Static properties are the same across all instances of the Class
    static [String] $StaticProperty = "This is a static property of the class"

    # Hidden Properties are typically hidden
    # but can be exposed in PowerShell Classes
    hidden [String] $HiddenProperty

    Class1() {
        # Empty Class1 Constructor
    }

    # Overloaded Constructor
    Class1 ([String] $SomeString, [int32] $SomeInteger) {
        # $this is used to access or modify the current instance of the Class1 class
        $this.StringProperty = $SomeString
        $this.IntegerPropery = $SomeInteger
    }

    # Overloaded Constructor
    Class1([String] $SomeString) {
        # Set StringProperty for CLass1 to the passed in $SomeString value
        $this.StringProperty = $SomeString
    }

    # Instance Method
    # An Instance Method will be created for every instance of the Class
    [String] getStringProperty() {
        return $this.StringProperty
    }

    # Static Method
    # A static method will be used across all instance of the Class
    static [String] getClan() {
        return [Class1]::StaticProperty
    }

    # VOID Method: Method that changes $Name to the default name
    # A VOID method will not return any information
    [void] IncreaseIntegerPropertyByOne() {
        $this.IntegerPropery += 1
    }
}