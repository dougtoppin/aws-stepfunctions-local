# Makefile

# the StepFunctions server needs to have creds, they can be dummies
AWS_ACCESS_KEY_ID=abcd
AWS_SECRET_KEY=abcd

# name of the StepFunction server container, this makes it easier to stop later
NAME=stepfunctionslocal

# a role that will work for creating a state machine
IAMROLEARN=arn:aws:iam::012345678901:role/DummyRole

# the port the Step Function server is running on on your host and in the container
PORT=8083

# the endpoint that the local Step Function server can be accessed
ENDPOINT="http://localhost:8083"

# example state machine definition
SF1=sf1.json

# example input file
INPUT1=input1.json

# name of the created state machine
NAME-test1

# start a local StepFunctions server
startup:
	docker run -t --rm --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} --env AWS_SECRET_KEY=${AWS_SECRET_KEY} -p ${PORT}:${PORT} --name ${NAME} amazon/aws-stepfunctions-local &

# stop the local server
stop:
	docker stop ${NAME}

# create a local state machine
create:
	aws stepfunctions --endpoint-url ${ENDPOINT} create-state-machine --name ${NAME} --definition file://${SF1} --role-arn ${IAMROLEARN}

# list the state machines that have been created locally
list:
	aws stepfunctions --endpoint-url ${ENDPOINT} list-state-machines

# update the definition of an existing state machine
update:
	# need the ARN of the machine to update
	$(eval STATEMACHINEARN=$(shell aws stepfunctions --endpoint-url "http://localhost:8083" list-state-machines --query stateMachines[].stateMachineArn --output text ) )

	# update the existing machine
	aws stepfunctions --endpoint-url ${ENDPOINT} update-state-machine --definition file://${SF1} --state-machine-arn ${STATEMACHINEARN}  --role-arn ${IAMROLEARN}

# start an execution of a local state machine
run:
	# get the arn of the existing machine
	$(eval STATEMACHINEARN=$(shell aws stepfunctions --endpoint-url "http://localhost:8083" list-state-machines --query stateMachines[].stateMachineArn --output text ) )

	# start an execution
	$(eval EXECUTIONARN=$(shell aws stepfunctions --endpoint-url ${ENDPOINT} start-execution  --state-machine-arn ${STATEMACHINEARN} --input file://${INPUT1} --query executionArn) )

	# get the results of the most recent execution
	@aws stepfunctions --endpoint-url ${ENDPOINT} describe-execution --execution-arn ${EXECUTIONARN} --query output

