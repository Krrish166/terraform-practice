case-1 same state file and two developers:-
         if dev-1 is creating s3 and push the code to github now if dev-2 didn't pull the code and created lamda and run tf plan then output is == s3 is to destroy and add lamda.
         if dev-1 is creating instace and tags and didn't push the code and if dev-2 pull the code or run tf plan then output is then tags is not in this code so terraform will think he didn't want tags code so what in the tf.statefile code is there that will apply so 1 change will show .

in project same statefile will be used for all directory or files means statefile will be commaon for everyone.
if you have a backend code in one directory and now your'e creating another directory and using same backend code then conflicts wil come like what resouces are there in preivious file which your'e copying will be overriden then you're also creating new resouce so if you run tf plan your respouce is going to add and previous rewsouces is going to destroy so it's not recommended too use same backend code to different directory
always create new backend and every time modification in backend code then run tf init -reconfigure cause your'r using or creating new resources else if you want same code to be override then use tf init -migrate-state.
