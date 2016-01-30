# thething

## Updating CloudFormation UserData

```bash
ruby -r json -e 'puts JSON.pretty_generate(File.read("bootstrap.sh").split(/(?<=\n)/))'
```
