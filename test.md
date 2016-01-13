# test
Tim Trice  
January 13, 2016  


```r
library(data.table)

attitude <- attitude
```


```r
library(knitr)
kable(attitude, align = "c", format = "markdown")
```



| rating | complaints | privileges | learning | raises | critical | advance |
|:------:|:----------:|:----------:|:--------:|:------:|:--------:|:-------:|
|   43   |     51     |     30     |    39    |   61   |    92    |   45    |
|   63   |     64     |     51     |    54    |   63   |    73    |   47    |
|   71   |     70     |     68     |    69    |   76   |    86    |   48    |
|   61   |     63     |     45     |    47    |   54   |    84    |   35    |
|   81   |     78     |     56     |    66    |   71   |    83    |   47    |
|   43   |     55     |     49     |    44    |   54   |    49    |   34    |
|   58   |     67     |     42     |    56    |   66   |    68    |   35    |
|   71   |     75     |     50     |    55    |   70   |    66    |   41    |
|   72   |     82     |     72     |    67    |   71   |    83    |   31    |
|   67   |     61     |     45     |    47    |   62   |    80    |   41    |
|   64   |     53     |     53     |    58    |   58   |    67    |   34    |
|   67   |     60     |     47     |    39    |   59   |    74    |   41    |
|   69   |     62     |     57     |    42    |   55   |    63    |   25    |
|   68   |     83     |     83     |    45    |   59   |    77    |   35    |
|   77   |     77     |     54     |    72    |   79   |    77    |   46    |
|   81   |     90     |     50     |    72    |   60   |    54    |   36    |
|   74   |     85     |     64     |    69    |   79   |    79    |   63    |
|   65   |     60     |     65     |    75    |   55   |    80    |   60    |
|   65   |     70     |     46     |    57    |   75   |    85    |   46    |
|   50   |     58     |     68     |    54    |   64   |    78    |   52    |
|   50   |     40     |     33     |    34    |   43   |    64    |   33    |
|   64   |     61     |     52     |    62    |   66   |    80    |   41    |
|   53   |     66     |     52     |    50    |   63   |    80    |   37    |
|   40   |     37     |     42     |    58    |   50   |    57    |   49    |
|   63   |     54     |     42     |    48    |   66   |    75    |   33    |
|   66   |     77     |     66     |    63    |   88   |    76    |   72    |
|   78   |     75     |     58     |    74    |   80   |    78    |   49    |
|   48   |     57     |     44     |    45    |   51   |    83    |   38    |
|   85   |     85     |     71     |    71    |   77   |    74    |   55    |
|   82   |     82     |     39     |    59    |   64   |    78    |   39    |


```r
library(stargazer)
```

```
## 
## Please cite as: 
## 
##  Hlavac, Marek (2015). stargazer: Well-Formatted Regression and Summary Statistics Tables.
##  R package version 5.2. http://CRAN.R-project.org/package=stargazer
```

```r
stargazer(attitude, header = FALSE, type = "html")
```


<table style="text-align:center"><tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Statistic</td><td>N</td><td>Mean</td><td>St. Dev.</td><td>Min</td><td>Max</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">rating</td><td>30</td><td>64.633</td><td>12.173</td><td>40</td><td>85</td></tr>
<tr><td style="text-align:left">complaints</td><td>30</td><td>66.600</td><td>13.315</td><td>37</td><td>90</td></tr>
<tr><td style="text-align:left">privileges</td><td>30</td><td>53.133</td><td>12.235</td><td>30</td><td>83</td></tr>
<tr><td style="text-align:left">learning</td><td>30</td><td>56.367</td><td>11.737</td><td>34</td><td>75</td></tr>
<tr><td style="text-align:left">raises</td><td>30</td><td>64.633</td><td>10.397</td><td>43</td><td>88</td></tr>
<tr><td style="text-align:left">critical</td><td>30</td><td>74.767</td><td>9.895</td><td>49</td><td>92</td></tr>
<tr><td style="text-align:left">advance</td><td>30</td><td>42.933</td><td>10.289</td><td>25</td><td>72</td></tr>
<tr><td colspan="6" style="border-bottom: 1px solid black"></td></tr></table>

