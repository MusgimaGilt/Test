cohortst=array(1:6)
cohortst[1:6]= c ("2010-01-01","2010-02-01","2010-03-01","2010-12-1","2011-01-1","2011-02-1")
cohorted=array(1:6)
cohorted=array(1:6)
cohorted[1:6]= c("2010-01-31","2010-02-28","2010-03-31","2010-12-31","2011-01-31","2011-02-28")

datest= array(1:60)
datest=seq(as.Date("2010/1/1"), as.Date("2014/12/1"), "month")
dateed=array(1:60)
dateed=seq(as.Date("2010-02-01"), length=60, by="1 month") - 1

j=1
i=1
temp=data.frame(matrix(ncol = 2, nrow = 1))
tempcust=data.frame(matrix(ncol = 60, nrow = 5))
temprev=data.frame(matrix(ncol = 60, nrow = 5))
library(RODBC)

sr = odbcConnect("db_japan", uid = "amadhavan", pwd = "U6Sn.6US$Xus")
for(i in 1:6)
  {for (j in 1:60)
    {  
      temp=sqlQuery(sr,paste("select count(distinct u.id),sum(oi.unit_price) from order_items oi join orders o on o.id=oi.order_id join users u on u.id=o.user_id where u.created_at at time zone 'JST' between '",cohortst[i],"' and '",cohorted[i],"' and u.id in (select distinct u.id from users u join orders o on u.id = o.user_id where o.status not in ('o','c') and u.status not in ('i') group by 1 having min(o.submitted_at at time zone 'JST') < '",datest[j],"' ) and o.submitted_at at time zone 'JST' between '",datest[j],"' and '",dateed[j],"' and u.status not in ('i') and o.status not in ('o','c')"))
       tempcust[i,j]=temp[1,1]
       temprev[i,j]=temp[1,2]
    
    
    }
   }