## Example of running a local AWS StepFunctions server and state machines

A AWS StepFunctions server can be run locally on your machine by running it as a container.

AWS documentation about it can be found at [https://docs.aws.amazon.com/step-functions/latest/dg/sfn-local.html](https://docs.aws.amazon.com/step-functions/latest/dg/sfn-local.html)

This can be helpful for testing things like state machine path processing for InputPath, ResultPath and OutputPath.
This can also be used as examples of running the aws cli to interact with the StepFunctions service.

Path processing during a state machine execution provides the ability to select and manipulate
the input to a state machine and states within it.
Paths also allow the output to be created and formatted in a manner that makes the state
machine very flexible.

Look at [https://docs.aws.amazon.com/step-functions/latest/dg/concepts-input-output-filtering.html](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-input-output-filtering.html)
for the documentation.

### Requirements

* docker installed and running

### Files

* Makefile - runs the various functions
* sf1.json - a state machine definition
* input1.json - example input to a state machine

### Usage

A Makefile is used to run the various functions.

The expected usage flow would be as follows

* make startup - run the local StepFunctions sever using a container that is run in the background

Example
```
$ make startup
docker run -t --rm --env AWS_ACCESS_KEY_ID=abcd --env AWS_SECRET_KEY=abcd -p 8083:8083 --name stepfunctionslocal amazon/aws-stepfunctions-local &
$ Step Functions Local
Version: 1.5.0
Build: 2020-02-19
2020-05-02 01:11:46.378: Loaded credentials from environment
2020-05-02 01:11:46.386: Starting server on port 8083 with account 123456789012, region us-east-1
```
* make create - create a local state machine using the sf1.json definition

Example
```
$ make create
aws stepfunctions --endpoint-url "http://localhost:8083" create-state-machine --name test1 --definition file://sf1.json --role-arn arn:aws:iam::012345678901:role/DummyRole
{
    "stateMachineArn": "arn:aws:states:us-east-1:123456789012:stateMachine:test1",
    "creationDate": 1588381994.25
}
```

* make run - run a local state machine execution using the input in the Makefile, the server will also output log data

Example
``` 
$ make run
# need the arn of the existing maching
# start an execution
# get the results of the most reecent execution
"\"World\""
```
* make update - update the definition of an existing local state machine using the sf1.json definition

Example
``` 
$ make update
# need the ARN of the machine to update
# update the existing machine
aws stepfunctions --endpoint-url "http://localhost:8083" update-state-machine --definition file://sf1.json --state-machine-arn arn:aws:states:us-east-1:123456789012:stateMachine:test1   --role-arn arn:aws:iam::012345678901:role/DummyRole
{
    "updateDate": 1588381994.25
}
```
* make stop - stop the local StepFunctions server

Example
``` 
$ make stop
docker stop stepfunctionslocal
stepfunctionslocal
```

The general intent is to support creating a state machine that uses path processing in various
ways to select input fields and output desired results.
The state machine definition file can be modified and an update performed to install it.

Then the input file can be modified to contain the input expected.
When an execution is run the output will appear.
