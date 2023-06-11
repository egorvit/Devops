#!/bin/bash
echo 'Start'
/app/app1.sh -Dconfig.file=/app/application.conf -Dhttp.port=$PORT -Dfile.encoding=UTF8 > application.log 2>&1
cat /app/application.log