Count distinct words in an array of words normaliza first                                                            
                                                                                                                     
"With a bunch of similar character variables, what's the easiest way to                                              
check there are at least one pair of non-missing variables with different values?                                    
Variables with missing values are present but should be excluded from comparison."                                   
                                                                                                                     
SAS-L                                                                                                                
https://listserv.uga.edu/cgi-bin/wa?A2=SAS-L;7baa5da.1909b                                                           
                                                                                                                     
gothub                                                                                                               
https://tinyurl.com/y6pbh64w                                                                                         
https://github.com/rogerjdeangelis/utl-count-distinct-words-in-an-array-of-words-normaliza-first                     
                                                                                                                     
 Two Solutions                                                                                                       
                                                                                                                     
     a. HASH datastep                                                                                                
        Bartosz Jablonski                                                                                            
        yabwon@gmail.com                                                                                             
                                                                                                                     
     b. SQL                                                                                                          
                                                                                                                     
Why you should normalize your input (make it long and skinny                                                         
                                                                                                                     
   a. If you have a lot of missings the disk footprint could be less.                                                
   b. Easier to parallelize                                                                                          
   c. More algorithms possible                                                                                       
                                                                                                                     
*_                   _                                                                                               
(_)_ __  _ __  _   _| |_                                                                                             
| | '_ \| '_ \| | | | __|                                                                                            
| | | | | |_) | |_| | |_                                                                                             
|_|_| |_| .__/ \__,_|\__|                                                                                            
        |_|                                                                                                          
;                                                                                                                    
                                                                                                                     
data have ;                                                                                                          
  input id (V1-V3) ($) ;                                                                                             
  cards ;                                                                                                            
1 .  AB AB                                                                                                           
2 AA AA AA                                                                                                           
3 AA .  BB                                                                                                           
4 .  AA BB                                                                                                           
5 AA BB CC                                                                                                           
6 AA AA .                                                                                                            
7 .  AA .                                                                                                            
8 .  .  .                                                                                                            
;                                                                                                                    
run ;                                                                                                                
                                                                                                                     
 WORK.HAVE total obs=8  | RULES                                                                                      
                        |                                                                                            
  ID    V1    V2    V3  | FLG                      DES                                                               
                        |                                                                                            
   1          AB    AB  |  0     no pair of non-missing with diff values                                             
   2    AA    AA    AA  |  0     no pair of non-missing with diff values                                             
   3    AA          BB  |  1     pair of non-missing with diff values                                                
   4          AA    BB  |  1     pair of non-missing with diff values                                                
   5    AA    BB    CC  |  1     pair of non-missing with diff values                                                
   6    AA    AA        |  0     no pair of non-missing with diff values                                             
   7          AA        |  0     no pair of non-missing with diff values                                             
   8                    |  0     no pair of non-missing with diff value                                              
                                                                                                                     
                                                                                                                     
*            _               _                                                                                       
  ___  _   _| |_ _ __  _   _| |_                                                                                     
 / _ \| | | | __| '_ \| | | | __|                                                                                    
| (_) | |_| | |_| |_) | |_| | |_                                                                                     
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                    
                |_|                                                                                                  
           _               _                                                                                         
  __ _    | |__   __ _ ___| |__                                                                                      
 / _` |   | '_ \ / _` / __| '_ \                                                                                     
| (_| |_  | | | | (_| \__ \ | | |                                                                                    
 \__,_(_) |_| |_|\__,_|___/_| |_|                                                                                    
                                                                                                                     
;                                                                                                                    
                                                                                                                     
WORK.WANT total obs=8                                                                                                
                                                                                                                     
 ID    V1    V2    V3    FLG                      DES                                                                
                                                                                                                     
  1          AB    AB     0     no pair of non-missing with diff values                                              
  2    AA    AA    AA     0     no pair of non-missing with diff values                                              
  3    AA          BB     1     pair of non-missing with diff values                                                 
  4          AA    BB     1     pair of non-missing with diff values                                                 
  5    AA    BB    CC     1     pair of non-missing with diff values                                                 
  6    AA    AA           0     no pair of non-missing with diff values                                              
  7          AA           0     no pair of non-missing with diff values                                              
  8                       0     no pair of non-missing with diff values                                              
                                                                                                                     
*_                  _                                                                                                
| |__     ___  __ _| |                                                                                               
| '_ \   / __|/ _` | |                                                                                               
| |_) |  \__ \ (_| | |                                                                                               
|_.__(_) |___/\__, |_|                                                                                               
                 |_|                                                                                                 
;                                                                                                                    
                                                                                                                     
                                                                                                                     
WORK.WANT total obs=8                                                                                                
                                                                                                                     
  ID    FLG                                                                                                          
                                                                                                                     
   1     0                                                                                                           
   2     0                                                                                                           
   3     1                                                                                                           
   4     1                                                                                                           
   5     1                                                                                                           
   6     0                                                                                                           
   7     0                                                                                                           
   8     0                                                                                                           
                                                                                                                     
*          _       _   _                                                                                             
 ___  ___ | |_   _| |_(_) ___  _ __  ___                                                                             
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|                                                                            
\__ \ (_) | | |_| | |_| | (_) | | | \__ \                                                                            
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/                                                                            
           _               _                                                                                         
  __ _    | |__   __ _ ___| |__                                                                                      
 / _` |   | '_ \ / _` / __| '_ \                                                                                     
| (_| |_  | | | | (_| \__ \ | | |                                                                                    
 \__,_(_) |_| |_|\__,_|___/_| |_|                                                                                    
                                                                                                                     
;                                                                                                                    
                                                                                                                     
                                                                                                                     
data want;                                                                                                           
                                                                                                                     
  start_var=0;                                                                                                       
                                                                                                                     
  set have;                                                                                                          
                                                                                                                     
  end_var  =1;                                                                                                       
                                                                                                                     
  array test[*] start_var-character-end_var;                                                                         
                                                                                                                     
  if _N_ = 1 then                                                                                                    
  do;                                                                                                                
    length testvar $ 256;                                                                                            
    declare hash H();                                                                                                
      H.defineKey("testvar");                                                                                        
      H.defineData("testvar");                                                                                       
      H.defineDone();                                                                                                
  end;                                                                                                               
                                                                                                                     
                                                                                                                     
  do _I_ = lbound(test) to hbound(test);                                                                             
      testvar = test[_I_];                                                                                           
      if testvar ne " " then _iorc_ = H.add();                                                                       
  end;                                                                                                               
                                                                                                                     
  if H.NUM_ITEMS > 1 then do;                                                                                        
         flg=1;                                                                                                      
         des ="pair of non-missing with diff values   ";                                                             
         output;                                                                                                     
  end;                                                                                                               
  else do;                                                                                                           
         flg=0;                                                                                                      
         des="no pair of non-missing with diff values";                                                              
         output;                                                                                                     
  end;                                                                                                               
  _iorc_ = H.clear();                                                                                                
  keep id v:flg des;                                                                                                 
run;                                                                                                                 
                                                                                                                     
*_                  _                                                                                                
| |__     ___  __ _| |                                                                                               
| '_ \   / __|/ _` | |                                                                                               
| |_) |  \__ \ (_| | |                                                                                               
|_.__(_) |___/\__, |_|                                                                                               
                 |_|                                                                                                 
;                                                                                                                    
                                                                                                                     
proc transpose data=have out=havXpo;                                                                                 
by id;                                                                                                               
var v:;                                                                                                              
run;quit;                                                                                                            
                                                                                                                     
proc sql;                                                                                                            
  create                                                                                                             
    table want as                                                                                                    
  select                                                                                                             
    id                                                                                                               
   ,count(distinct col1)>1 as flg                                                                                    
  from                                                                                                               
    havXpo                                                                                                           
  group                                                                                                              
    by id                                                                                                            
;quit;                                                                                                               
                                                                                                                     
                                                                                                                     
