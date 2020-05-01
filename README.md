## Example of running a local AWS StepFunctions server and state machines

A AWS StepFunctions server can be run locally on your machine by running it as a container.
.
This can be helpful for testing things like state machine path processing for InputPath, ResultPath and OutputPath.
This can also be used as examples of running the aws cli to interact with the StepFunctions service.

### Requirements

* docker installed and running

### Usage

The expected usage flow would be as follows

* make startup - run the local StepFunctions sever using a container
* make create - create a local state machine
* make run - run a local state machine
* make update - update the definition of an existing local state machine
* make stop - stop the local StepFunctions server

