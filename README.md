## Example of running a local AWS StepFunctions server and state machines

A AWS StepFunctions server can be run locally on your machine by running it as a container.
.
This can be helpful for testing things like state machine path processing for InputPath, ResultPath and OutputPath.
This can also be used as examples of running the aws cli to interact with the StepFunctions service.

### Requirements

* docker installed and running

### Files

* Makefile - runs the various functions
* sf1.json - a state machine definition

### Usage

A Makefile is used to run the various functions.

The expected usage flow would be as follows

* make startup - run the local StepFunctions sever using a container
* make create - create a local state machine using the sf1.json definition
* make run - run a local state machine execution using the input in the Makefile
* make update - update the definition of an existing local state machine using the sf1.json definition
* make stop - stop the local StepFunctions server

