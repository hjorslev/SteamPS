Deploy Module {
    By PSGalleryModule {
        FromSource $env:BHProjectName
        To PSGallery
        WithOptions @{
            ApiKey = $env:NugetApiKey
        }
    }
}