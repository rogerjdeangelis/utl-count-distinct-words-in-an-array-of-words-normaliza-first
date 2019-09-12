# utl-count-distinct-words-in-an-array-of-words-normaliza-first
    Count distinct words in an array of words normaliza first                                                                    
                                                                                                                                 
    "With a bunch of similar character variables, what's the easiest way to                                                      
    check there are at least one pair of non-missing variables with different values?                                            
    Variables with missing values are present but should be excluded from comparison."                                           
                                                                                                                                 
    SAS-L                                                                                                                        
    https://listserv.uga.edu/cgi-bin/wa?A2=SAS-L;7baa5da.1909b                                                                   
                                                                                                                                 
    gothub                                                                                                                       
    https://tinyurl.com/y6pbh64w                                                                                                 
    https://github.com/rogerjdeangelis/utl-count-distinct-words-in-an-array-of-words-normaliza-first                             
                                                                                                                                 
     Four Solutions                                                                                                              
                                                                                                                                 
         a. HASH datastep                                                                                                        
            Bartosz Jablonski                                                                                                    
            yabwon@gmail.com                                                                                                     
                                                                                                                                 
         b. SQL                                                                                                                  
                                                                                                                                 
         c. Simple clever algorithm by Ben Herman                                                                                
            First non-missing is the same as the last value in the sorted data                                                   
            Ben Herman                                                                                                           
            baherman@gmail.com                                                                                                   
                                                                                                                                 
         d. Looping solution by Ben with bells and whistles                                                                      
            Ben Herman                                                                                                           
            baherman@gmail.com                                                                                                   
                                                                                                                                 
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
                                                                                                                                 
    *    _     ____                                                                                                              
      __| |   | __ )  ___ _ __                                                                                                   
     / _` |   |  _ \ / _ \ '_ \                                                                                                  
    | (_| |_  | |_) |  __/ | | |                                                                                                 
     \__,_(_) |____/ \___|_| |_|                                                                                                 
                                                                                                                                 
    ;                                                                                                                            
                                        NICE                                                                                     
    WORK.TRY total obs=8           ==================                                                                            
                                                                                                                                 
    ID    V1    V2    V3    FLAG    PAIRS              MINC    MAXC    MISSC                                                     
                                                                                                                                 
     1          AB    AB      0                         AB      AB       1                                                       
     2    AA    AA    AA      0                         AA      AA       0                                                       
     3          AA    BB      1     [2,3]               AA      BB       1                                                       
     4          AA    BB      1     [2,3]               AA      BB       1                                                       
     5    AA    BB    CC      1     [1,2][1,3][2,3]     AA      CC       0                                                       
     6          AA    AA      0                         AA      AA       1                                                       
     7                AA      0                         AA      AA       2                                                       
     8                        0                                          3                                                       
                                                                                                                                 
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
                                                                                                                                 
    *         ____                                                                                                               
      ___    | __ )  ___ _ __                                                                                                    
     / __|   |  _ \ / _ \ '_ \                                                                                                   
    | (__ _  | |_) |  __/ | | |                                                                                                  
     \___(_) |____/ \___|_| |_|                                                                                                  
                                                                                                                                 
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
                                                                                                                                 
    /* we can create a simple check to see if the first non-missing is the same as the last value in the sorted data*/           
    Data Simple;                                                                                                                 
     set have;                                                                                                                   
     array Comp(*) V:;                                                                                                           
     Flag =0;                                                                                                                    
     call sortc(of Comp(*));                                                                                                     
     if coalescec(of Comp(*))^= Comp(dim(Comp))then Flag = 1;                                                                    
     MissC=cmiss(of Comp(*)) ;                                                                                                   
    run;                                                                                                                         
     proc print data=Simple; run;                                                                                                
                                                                                                                                 
    WORK.SIMPLE total obs=8                                                                                                      
                                                                                                                                 
     ID    V1    V2    V3    FLAG                                                                                                
                                                                                                                                 
      1          AB    AB      0                                                                                                 
      2    AA    AA    AA      0                                                                                                 
      3          AA    BB      1                                                                                                 
      4          AA    BB      1                                                                                                 
      5    AA    BB    CC      1                                                                                                 
      6          AA    AA      0                                                                                                 
      7                AA      0                                                                                                 
      8                        0                                                                                                 
                                                                                                                                 
    *    _     _          _ _      ___            _     _     _   _                                                              
      __| |   | |__   ___| | |___ ( _ ) __      _| |__ (_)___| |_| | ___  ___                                                    
     / _` |   | '_ \ / _ \ | / __|/ _ \/\ \ /\ / / '_ \| / __| __| |/ _ \/ __|                                                   
    | (_| |_  | |_) |  __/ | \__ \ (_>  <\ V  V /| | | | \__ \ |_| |  __/\__ \                                                   
     \__,_(_) |_.__/ \___|_|_|___/\___/\/ \_/\_/ |_| |_|_|___/\__|_|\___||___/                                                   
                                                                                                                                 
    ;                                                                                                                            
                                                                                                                                 
    /*the cde below includes some expalantory text and also provides the more                                                    
    complex looping through the valiable to find which pairs are actually unequal*/                                              
    Data try;                                                                                                                    
      set have;                                                                                                                  
        array Comp(*) V:;                                                                                                        
        flag=0; length pairs $ 200;;                                                                                             
               /* emulate min/Max by sorting the data and selecting the ends */                                                  
        call sortc(of Comp(*));                                                                                                  
              /*Min is the first non-missing*/                                                                                   
         MinC=coalescec(of Comp(*));                                                                                             
             /*Max is the last value*/                                                                                           
         MaxC=Comp(dim(Comp));                                                                                                   
         if MinC ^=MaxC then flag =1;                                                                                            
         MissC=cmiss(of Comp(*)) ;                                                                                               
             /* if you need to know which is the pairs are unequal that is a little more computationally intensive.*/            
          Do i = 1 to dim(Comp)-1;                                                                                               
               Do j= i+1 to dim(Comp);                                                                                           
                   if missing (comp{i}) then Continue; /*skip the missings*/                                                     
                   if Comp{i} ^= Comp{j} then  pairs=cats(pairs,"[",i,",",j,"]");                                                
               end;                                                                                                              
          end;                                                                                                                   
     run;                                                                                                                        
     proc print data=try; run;                                                                                                   
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
    WORK.TRY total obs=8                                                                                                         
                                                                                                                                 
      ID    V1    V2    V3    FLAG    PAIRS              MINC    MAXC    MISSC                                                   
                                                                                                                                 
       1          AB    AB      0                         AB      AB       1                                                     
       2    AA    AA    AA      0                         AA      AA       0                                                     
       3          AA    BB      1     [2,3]               AA      BB       1                                                     
       4          AA    BB      1     [2,3]               AA      BB       1                                                     
       5    AA    BB    CC      1     [1,2][1,3][2,3]     AA      CC       0                                                     
       6          AA    AA      0                         AA      AA       1                                                     
       7                AA      0                         AA      AA       2                                                     
       8                        0                                          3                                                     
                                                                                                                                 
                                                                                                                                 
                                                                                                                                 
