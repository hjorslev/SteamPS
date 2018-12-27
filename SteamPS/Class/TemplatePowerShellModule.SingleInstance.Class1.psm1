class Class1 {
    # Single Instance Property
    [string] $SingleInstanceName

    # Static property that does not change between instances
    # And used to check if an instance is already created
    static [Class1] $StaticInstance

    # Static method to get the instance
    static [Class1] GetInstance() {
        # if our StaticInstance variable is still set to $null
        # then we create a new instance
        if ($null -eq [Class1]::StaticInstance) {
            [Class1]::StaticInstance = [Class1]::new()
        }
        # if the instance already exists or not, we return it
        return [Class1]::StaticInstance
    }
}