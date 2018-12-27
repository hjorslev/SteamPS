# Class1 is the parent class
class Class1 {
    [string] $Message = "Hello!"

    [string] GetMessage() {
        return ("Message: {0}" -f $this.Message)
    }
}

# Class2 extends Class1 and inherits its members
class Class2 : Class1 {

}

# Class3 extends Class1 and uses the base (Class1) Constructor
class Class3 : Class1 {
    Class3() : base() {
        # Since Class3 is extending Class1, it inherits all its members
        # Specificying the : base() at the end of the Class3 constructor will
        # automatically inherit the Class1 constructor
    }
}