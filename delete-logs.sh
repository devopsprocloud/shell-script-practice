A script to delete/archive old logs in source directory, if user action is delete, delete them. If user action is archive zip them and keep it into destination directory
User have to provide
Source directory
Action. Either archive or delete
If archive, he must provide destination. If delete no need of destination
Days. How many days old. by default 14 days
Memory. Optional. if user gives consider it otherwise dont consider memory
Example
sh old-logs.sh -s <source-dir> -a <archive|delete> -d <destination> -t <day> -m <memory-in-mb>

Sample
sh old-logs.sh -s "/tmp/shellscript-logs" -a delete  -t 7 -m 10

Validations

User has given all required input or not
Directories are exist or not