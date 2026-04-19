
---------Demonstrate demographic and viewing attributes that help explain who is watching BrightTV and what they watch

             SELECT   DISTINCT UserID0 ,
                       Name,
                       Surname,
                     Province,  
                     Race, 
                     Age,
                     Channel2,
                     Gender,
              
         
-------------Extract session date, Extract session time and Convert Duration2 into minutes watched 
         
          DATE_FORMAT(RecordDate2, 'yyyy-MM-dd') AS DATE, DATE_FORMAT(RecordDate2 +INTERVAL '2 hour', 'HH:mm:ss') AS TIme,
         (unix_timestamp(Duration2) - unix_timestamp('1899-12-31 00:00:00')) /60 AS duration_minutes, 

  ----------Viewer segmentation category based on session duration (in minutes)              
      CASE 
           WHEN duration_minutes BETWEEN 100 AND 199 THEN 'short'
           WHEN duration_minutes BETWEEN 200  AND 299 THEN 'Medium'     
           WHEN duration_minutes BETWEEN 300 AND 400 THEN 'Long'
           ELSE 'fan'
           END AS viewer,

  ----------Create a new column called NAME_DAY that shows the day of the week (like Monday, Tuesday, etc)

          DAYNAME(RecordDate2) AS NAME_DAY,

     --------classify each viewing session as either Weekend or Weekday based on the day name.    
           CASE
              WHEN  NAME_DAY IN ('Sun','Sat') THEN 'Weekend'
              ELSE 'Weekday'
              END AS day_classification,

 ------creates time-of-day viewing buckets from session timestamps, it helps identify when users watch content most.
       CASE 
            WHEN DATE_FORMAT(RecordDate2 +INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN '01. Graveyard'
            WHEN DATE_FORMAT(RecordDate2 +INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning'
            WHEN DATE_FORMAT(RecordDate2 +INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '12:00:00' AND '15:59:59' THEN '03. Afternoon'
            WHEN DATE_FORMAT(RecordDate2 +INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '16:00:00' AND '21:59:59' THEN '04.Evening '
            ELSE '05. Night'
            END AS time_buckets,

  ------- Creating a new column for Age classification thats viewer segmantetion  
     CASE
        WHEN Age IS NULL THEN '00.Unknown' 
        WHEN Age BETWEEN 0 AND 17 THEN '01.Children' 
        WHEN Age BETWEEN 18 AND 34 THEN '02.Young Adult'
        WHEN Age BETWEEN 35 AND 54 THEN '03.Adult'   
        WHEN Age BETWEEN 55 AND 64 THEN '04.Senior'         
        ELSE '05. Elderly'
        END AS Age_Group
 from `testu`Left JOIN`testv`
ON `testu`.UserID= `testv`.UserID0  
WHERE Duration2 IS NOT NULL 
AND RecordDate2 IS NOT NULL
AND UserID0 IS NOT NULL
ORDER BY duration_minutes DESC;

