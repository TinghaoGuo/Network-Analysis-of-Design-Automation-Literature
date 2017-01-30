Topic Assignment: Key phrase extraction and topic assignment (run scripts in Jupyter Notebook)

1. run ‘1.clean_pre-process.ipynb’ (‘code’ folder) in Jupiter Noteboothis step will: 
- create a new file named ‘r1_keyword_list_post.csv’ (in ‘code’ folder)	
- print information in Jupyter Notebook

2. manually revise ‘r1_keyword_list_post.csv’ according to the printed information; manually delete or revise repeated/inconsistent lines

3. rename the new csv file as ‘r2_keyword_list_post.csv’

4. run ‘2. csv files with paper_id in each year.ipynb’ in Jupyter Notebook; this step will create 14 csv files (’20xx_with_id.csv’) and each paper will be assigned an id randomly

5. run ‘3. nb_topics and record for each year.ipynb’ in Jupyter Notebook; this step will create:
- ’20xx_record.txt’ files (extracted sentences and matching key phrases in 20xx year papers)
- ’20xx_nTopic_Freq.xlsx’ files (frequency of each narrow topic in different papers in 20xx year; narrow topics and papers are represented by their ids)
- ’20xx_bTopic_Freq.xlsx’ files (frequency of each broad topic in different papers in 20xx year; broad topics and papers are represented by their ids)
- ’50_nTopics.txt’ (narrow topics with ids)
- ’10_bTopics.txt’ (broad topics with ids)
