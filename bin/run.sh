# delete previous output
hadoop dfs -rmr /usr/$USER/wordcount/output

# actually run the job
hadoop jar wordcount.jar org.myorg.WordCount /usr/$USER/wordcount/input /usr/$USER/wordcount/output

# cat the output
 hadoop dfs -cat /usr/$USER/wordcount/output/part-r-00000
