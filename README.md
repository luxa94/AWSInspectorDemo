# AWS Inspector demo app

#### Project for college security course

Request signing done with the help of [this blog post](http://www.codeography.com/2016/03/20/signing-aws-api-requests-in-swift.html) but translated to swift 3.1 and adjusted to fit the needs for the Inspector API.

To start this project, you will need to add a file called **Credentials.swift** in the **util** package, in it add a class called **AwsCredentials** which should look like this:

```swift
class AwsCredentials {
    static let AWS_KEY = "YOUR_AWS_KEY"
    static let AWS_SECRET_KEY = "YOUR_AWS_KEY_SECRET"
}
```

The key and secret should belong to an aws user that has access rights to your inspector service.
