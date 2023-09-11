#  iOS app architecture

This app is created using Onion Architecture / Clean Architecture to provide testability and modularity. It enables us to having an isolated component and trivial test.
We have our domain layer that responsible to model our app that its business case is asking for a weather information based on its current location or user input location.
Thus the infrastructure layer will only act as an I/O to the GUI(using UIKit), Network request(using URLSession) and Persistent(using CoreData).
Each component is being develop by using Test-First development. It enables us to have a test as our documentation about how every module works.
We use Factory pattern to inject dependency by filling in the functions that is needed for each module to work correctly. Later on we could use DI library as [Swinject](https://github.com/Swinject/Swinject) to automate the process.

GetPostItem acts as the Domain use case for showing all the Post. It fetches both data from Network and Persistent layer. It makes the ViewModel has no information where does the data come from and can be develop later if we need to cache the Data in the future or any other feature improvement.

When you check the test cases. We have several target tests.
- dbIntegrationTests
- dbTests
- dbUITests

### dbIntegrationTests
this test target consists of test cases for api class that requesting our API server. It can be execute daily or every BE deployment to check if our API server still respond with the same expected responses.
It is also check the Persistent store that can validate when there is migration in the persistent scheme.

### dbTests
it consists of Unit tests for our domain and can be executed every time we are doing development. It has to be fast and we could have fast feedback and check if business case keep its behavior.

### dbUITests
It is created as our Acceptance test to check every feature is working correctly and integrated in the app. 
