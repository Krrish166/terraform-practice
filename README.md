case-1 same state file and two developers:-
         if dev-1 is creating s3 and push the code to github now if dev-2 didn't pull the code and created lamda and run tf plan then output is == s3 is to destroy and add lamda.
         if dev-1 is creating instace and tags and didn't push the code and if dev-2 pull the code or run tf plan then output is then tags is not in this code so terraform will think he didn't want tags code so what in the tf.statefile code is there that will apply so 1 change will show .
