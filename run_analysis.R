## ###############################################
## Getting and Cleaning Data - Course Project
## 
## Create a Tidy Merged Training and Test Data Set
## ###############################################

##  #######################
##
## Load Description Files


## Load Activity Labels File

  activity_lbl <- read.table("activity_labels.txt", sep = "", header = FALSE)
  
 
  # Add Column Heading
  
    colnames(activity_lbl) <- c("Act_Cde", "Activity")
  
    
## Load Features File
  
  features <- read.table("features.txt", sep = " ", header = FALSE)
  

  ## Get mean and Std Deviation column positions
  ## use sql
  
      library(sqldf)  

      lst_feat <- sqldf("select * from features where V2 like '%mean()%' or V2 like '%std()%'")
  
       
      lst_col <- lst_feat[,1]
  
        
      lst_colname <- lst_feat[,2]
      
  
      
  
##  #####################
##
##  CREATE TEST DATA.FRAME



## Load Test - Reading File
  
  tst_x <- read.table("x_test.txt", sep = "", header = FALSE)
  
  ## count nbr of records
  
  nrow(tst_x)
  ##[1] 2947
  
  
  ## create new data.frame with mean and std dev columns only
  
  tst_x_mean <- tst_x[, lst_col]
  
  
  ## add column heading
  
  colnames(tst_x_mean) <- lst_colname
  
  
  
  
## Load Test - Activity File

  tst_y <- read.table("y_test.txt", sep = "", header = FALSE)
  
  
  ## Add Column Heading
  
      colnames(tst_y) <- "Act_Cde"
        
  
## Load Test - Subject File
  
  tst_subject <- read.table("subject_test.txt", sep = "", header = FALSE)

  
## Add Column Heading
  
  colnames(tst_subject) <- "Subject_Nbr"
  
 
## Combine test files into 1
  
  test_df <- cbind(tst_subject, tst_y, tst_x_mean)
  

  
  ### ##########################
  ###
  ### CREATE TRAINING DATA.FRAME
  ###
  
  trn_x <- read.table("x_train.txt", sep = "", header = FALSE)
  
  
  ## create new data.frame with mean and std dev columns only
  
  trn_x_mean <- trn_x[, lst_col]
  
  
  ## add column heading
  
  colnames(trn_x_mean) <- lst_colname
  
  
  
  ## Load train - Activity File
  
  trn_y <- read.table("y_train.txt", sep = "", header = FALSE)
  
  
  ## Add Column Heading
  
  colnames(trn_y) <- "Act_Cde"
  
  
  
  ## Load train - Subject File
  
  trn_subject <- read.table("subject_train.txt", sep = "", header = FALSE)
  
  
  ## Add Column Heading
  
  colnames(trn_subject) <- "Subject_Nbr"
  
  
  
  ## Combine train files into 1
  
  train_df <- cbind(trn_subject, trn_y, trn_x_mean)
  
  
  
  ##  ################################
  ##
  ##  CREATE COMBINED Training and Test Data Frames
  ##
  
  train_test_df <- rbind(train_df, test_df)
  
  ## Merge Activity Description
  
  tt_merge_df <- merge(train_test_df, activity_lbl, by = "Act_Cde")
  
  
  ##
  ## Reformat and Create Final Train + Test Details File
  
  train_test_dtl <- select(tt_merge_df, Activity, Subject_Nbr, 3:68)
  
  train_test_dtl <- arrange(train_test_dtl, Activity, Subject_Nbr)
  
 
  ##
  ## Create Train + Test Summary File
  
  train_test_sum <- aggregate(train_test_dtl, by = c(train_test_dtl[1], train_test_dtl[2]), mean)
  
 
  
  train_test_sum <- select(train_test_sum, 1, 4:70)
  
  
  
  
  ##
  ## Output Train + Test (Ave) Data Set
  
  write.table(train_test_sum, file = "train_test_ave.txt", row.names = FALSE)
  
  
  
