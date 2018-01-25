Linear regressions using arrays or row wise regressions

  WPS PROC R/SAS (same result)

see
https://goo.gl/xnUcUX
https://communities.sas.com/t5/General-SAS-Programming/Multiple-regressions-using-arrays/m-p/431083


INPUT
=====

   Algorithm
      Perform 20 regression by row where Y = Ax +e


   SD1.HAVE total obs=20
                                                                                  |  RULES
              INDEPENDENT VARIABLE                   DEPENDENT VARIABLE           |
                                                                                  |
    Obs   X1     X2     X3     X4     X5         Y1     Y2     Y3     Y4     Y5   |  INTERCEPT      SLOPE
                                                                                  |
      1   12    -15      8      3      6         12    -15    -26    -21     -9   |   -13.1349     0.47675
      2  -27      6     -4      8     -8          0     -1     -9      4     14   |     1.5362    -0.01276
      3   11      1      0      8     38        -14     -9      3      3      9   |    -5.1847     0.30903
      4    5      2    -19      0     25          2     -1     -1     -6      7   |    -0.3284     0.20322
      5    9      7     15      5      2          0     -3     15      4     40   |    20.9076    -1.27731
      6   -3    -11      8     -8     22         -7    -20     15     12     -3   |    -1.0472     0.27948
      7    7     -5     -6     28     -7          3    -15     10     24     -9   |    -0.1916     0.82106
      8   -9     -2      8      7      4         38     14      7     -1    -13   |    12.5388    -2.21173
      9   -3     22     -2    -33    -29         11     12    -15     28      9   |     6.6899    -0.25668
     10   -2     19    -33    -25     13         -6    -14     -1      2      4   |    -3.8114    -0.14489
     11    6    -14     -3     19     17          0      1     24    -31     -2   |     2.7668    -0.87337
     12  -22     22     26     -5      5         -9    -21     15    -13    -22   |   -11.1375     0.21876
     13   -4     12     10    -11     23        -13     -4      5     27     -8   |     5.2548    -0.64247
     14    9      4      2     17      2        -16    -27    -24     26     -8   |   -28.9803     2.82064
     15  -13      0     -8     -8    -32         -7      9     -5     15     -4   |     6.6044     0.41019
     16  -26     -2     -7      6    -25         28     -7     -2     -4    -17   |    -4.6916    -0.39737
     17   -7      7     19     31      3        -17     10     -6    -16     -3   |    -5.2901    -0.10470
     18   29    -13      2      1    -11         15    -17    -14     -6     -5   |    -6.4259     0.64120
     19  -19     20      8     -3     14         11     14     12     30     15   |    16.5726    -0.04316
     20    8    -17    -29      9     -9         -4     14      6     -9     -4   |    -2.7200    -0.43684


PROCESS (working code)
======================

    mat<-data.frame(intercept=rep(1,nrow(have)), slope=rep(1,nrow(have))); * matrix to replace with intercept and slope;
    for (i in c(1:nrow(have)) )
        { mat[i,]<-as.data.frame(t(coef(lm(t(have[i,c(6:10)]) ~ t(have[i,c(1:5)]))))) }; *load model coeficients;

OUTPUT
======

WORK.WANTWPS total obs=20

  Obs    INTERCEPT      SLOPE

    1     -13.1349     0.47675
    2       1.5362    -0.01276
    3      -5.1847     0.30903
    4      -0.3284     0.20322
    5      20.9076    -1.27731
    6      -1.0472     0.27948
    7      -0.1916     0.82106
    8      12.5388    -2.21173
    9       6.6899    -0.25668
   10      -3.8114    -0.14489
   11       2.7668    -0.87337
   12     -11.1375     0.21876
   13       5.2548    -0.64247
   14     -28.9803     2.82064
   15       6.6044     0.41019
   16      -4.6916    -0.39737
   17      -5.2901    -0.10470
   18      -6.4259     0.64120
   19      16.5726    -0.04316
   20      -2.7200    -0.43684

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  call streaminit(1234);
  array xs[5] x1-x5;
  array ys[5] y1-y5;
  do model=1 to 20;
  do i=1 to 5;
     ys[i]=int(15*rand('normal',0,1));
     xs[i]=int(15*rand('normal',0,1));
  end;
  output;
  end;
  drop model i;
run;quit;

*                      __
__      ___ __  ___   / / __  _ __ ___   ___   _ __
\ \ /\ / / '_ \/ __| / / '_ \| '__/ _ \ / __| | '__|
 \ V  V /| |_) \__ \/ /| |_) | | | (_) | (__  | |
  \_/\_/ | .__/|___/_/ | .__/|_|  \___/ \___| |_|
         |_|           |_|
;


%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
libname hlp sas7bdat "C:\Program Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(haven);
library(zoo);
have<-read_sas("d:/sd1/have.sas7bdat");
have;
mat<-data.frame(intercept=rep(1,nrow(have)), slope=rep(1,nrow(have)));
for (i in c(1:nrow(have)) ) { mat[i,]<-as.data.frame(t(coef(lm(t(have[i,c(6:10)]) ~ t(have[i,c(1:5)]))))) };
endsubmit;
import r=mat data=wrk.wantwps;
run;quit;
');

*     _               _
  ___| |__   ___  ___| | __
 / __| '_ \ / _ \/ __| |/ /
| (__| | | |  __/ (__|   <
 \___|_| |_|\___|\___|_|\_\

;

* check the 3rd row;
data xy;
 set sd1.have(obs=3 firstobs=3);
  array xs[5] x1-x5;
  array ys[5] y1-y5;
  do i=1 to 5;
    x=xs[i];
    y=ys[i];
    keep x y;
    output;
  end;
run;quit;

proc reg data=xy;
  model y=x;
run;quit;


     intercept       slope
1  -13.1349134  0.47675479
2    1.5362245 -0.01275510

3   -5.1847054  0.30902633  matches SAS

4   -0.3283734  0.20322055
5   20.9075630 -1.27731092
6   -1.0471750  0.27948437
7   -0.1915951  0.82105739


                     Parameter
Variable     DF       Estimate

Intercept     1       -5.18471
X             1        0.30903


