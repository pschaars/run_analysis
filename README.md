---
title: "README"
output: html_document
---

run_analysis.R takes the files provided and combines the training and test sets

then binds the subject and activity as new columns

the headings are applied from the features.txt file

and then the data is filtered to only the mean and standard deviation columns

finally, summary.txt is created by summarizing each column, partitioned by subject and activity, by the column mean