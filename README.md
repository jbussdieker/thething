# thething

## Launching it

```bash
aws cloudformation create-stack --stack-name foo --template-body file://cloudformation.json --parameters ParameterKey=KeyName,ParameterValue=fookey
aws cloudformation describe-stacks --stack-name foo
...
            "Outputs": [
                {
                    "Description": "Instance Public DNS Name", 
                    "OutputKey": "PublicIp", 
                    "OutputValue": "x.x.x.x"
                }
            ], 
...
ssh ec2-user@x.x.x.x
```

## Updating CloudFormation UserData

```bash
ruby -r json -e 'puts JSON.pretty_generate(File.read("bootstrap.sh").split(/(?<=\n)/))'
```
