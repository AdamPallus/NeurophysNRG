# NRG Additional Figures
#Results
We isolated 163 neurons (94 from S and 69 from U) in NRG while monkeys performed head-unrestrained gaze shifts and gaze pursuit tasks. We chose 51 of these neurons for further analysis in this report, based on apparent head-movement-related activity as perceived by the researchers during recording, and the recording of at least 50 successful trials while isolation was maintained. The behavior tasks that our monkeys performed provided us with a large variety of head movements to investigate. Controlling initial eye position provided us with examples of pursuit and gaze shifts of similar velocities and amplitudes with varying amounts of head contribution. This provided us with the ability to identify neurons with head-related activity during recording. For offline analysis, we can compare the firing rate of the neurons to the actual head and eye kinematics on a trial-by-trial basis. While our focus was on horizontal movements, we recorded the vertical positions of the gaze, eyes and head at all times. 



Since we have preselected our neurons based on apparent task-related activity, we first look for evidence that the rate of activity is correlated with the velocity of head movements. In the following figure, we plot the peak velocity of the head (negative values indicate that the fastest head movement was leftward), and the peak discharge rate of the cell during each trial. We show data observed during all trial types. For pursuit trials, we restrained our search for the peak values to the first trajectory only, to avoid including effects from vertical or oblique movements. 


![](extrafigs2_files/figure-html/peakAnalysisDUMP-1.png) 

From the figure above, it is apparent that we have a heterogenious sample of neurons. The peak firing rate of many cells never exceeds 200 spikes/s, while some have a peak firing rate greater than 400 spikes/s. There seem to be correlations between the peak head velocity and peak firing rate in many neurons, and this correlation appears to be directionly selective. 

For our first statistical test, we use linear regression to find the relationship between peak head velocity and peak firing rate for each neuron. We fit leftward and rightward movements using separate models. In the figure below, we show an example cell demonstrating this process. Panel 1A shows the head velocity and corresponding activity of the neuron during a fast, leftward head movement, while 1B shows the same during a slower head movement. For each trial, we record the peak head velocity and the peak firing rate of the neuron, which are plotted in 1C. We fit a linear regression model for the relationship between peak firing rate and peak velocity in each direction. For the example neuron shown in 1C, this regression was significant (p<0.001) for leftward movements only. 

![Example of correlation between peak head velocity and peak firing rate.](Example1sc21dec11.png)



In the figure below, we plot the 20 neurons with significant leftward regressions, followed by the 20 cells with signficant rightward regressions. We found that 9 cells had signficant regressions in both directions.


```r
#In this figure, we're showing all the cells with significant regressions for leftward movements
qplot(head_peak,maxsdf*1400,
      data=filter(pp,head_peak< -20,p.left<0.001))+
  facet_wrap(~Neuron,ncol=2)+stat_smooth(method='lm',col='black')+
  stat_smooth_func(method='lm',geom='text',parse=TRUE,hjust=0.3,size=4)+
  theme_bw()+
  ylab('Peak Firing Rate (spikes/s)')+
  xlab('Peak Head Velocity (deg/s)')
```

![](extrafigs2_files/figure-html/leftRegressions-1.png) 


```r
#In this figure, we're showing all the cells with significant regressions for rightward movements
qplot(head_peak,maxsdf*1400,
      data=filter(pp,head_peak > 20,p.right<0.001))+
  facet_wrap(~Neuron,ncol=2)+stat_smooth(method='lm',col='black')+
  stat_smooth_func(method='lm',geom='text',parse=TRUE,hjust=-0.2,size=4)+
  theme_bw()+
  ylab('Peak Firing Rate (spikes/s)')+
  xlab('Peak Head Velocity (deg/s)')
```

![](extrafigs2_files/figure-html/rightRegressions-1.png) 

Of the cells with significant regressions for all head movements, we further tested for the significance of the type of task that was used to elicit the head movements on this relationship. We fit the model $$Fr_{peak} = x_{0}+x_{1} H_{peak}+x_{2} T_{type}+x_{3} H_{peak}*T_{type},$$ where $Fr_{peak}$ is the peak firing rate, $H_{peak}$ is the peak head velocity, and $T_{type}$ is the task  (delayed gaze shift or head-unrestrained pursuit) that was required during each trial,and the $*$ indicates an interaction between the two parameters. A significant $x_{2}$ term indicates a difference in the intercepts for the relationship between peak head velocity and peak firing rate for the trial types, while a significant $x_{3}$ term indicates a difference in slope between the two.  

In the figures below, we plot data from the  5 cells with significant effects of the task type on either the slope or intercept of the fit for leftward head movements, followed by the 7 cells significant during rightward movements.



```r
qplot(head_peak,maxsdf*1400,col=isgs,
      data=filter(pp,head_peak< -20,p.left<0.001,p.left.slope<0.001 | p.left.int<0.001))+
  facet_wrap(~Neuron,ncol=3)+stat_smooth(method='lm')+
  ylab('Peak Firing Rate (spikes/s)')+
  xlab('Peak Head Velocity (deg/s)')+
  theme_bw()+
  scale_colour_grey(start = 0, end = .7,name='Task Type')+
  theme(legend.position='bottom')
```

![](extrafigs2_files/figure-html/gspsLeftward-1.png) 


```r
qplot(head_peak,maxsdf*1400,col=isgs,
      data=filter(pp,head_peak> 20,p.right<0.001,p.right.slope<0.001 | p.right.int<0.001))+
  facet_wrap(~Neuron,ncol=3)+stat_smooth(method='lm')+
  ylab('Peak Firing Rate (spikes/s)')+
  xlab('Peak Head Velocity (deg/s)')+
  theme_bw()+
  scale_colour_grey(start = 0, end = .7,name='Task Type')+
  theme(legend.position='bottom')
```

![](extrafigs2_files/figure-html/gspsRightward-1.png) 

Following the methods described above (see Methods: Modeling), for each cell, we generated a model to predict the firing rate of the neuron in terms of eye and head position, velocity and acceleration. Each model includes only terms that increase the R^2^ of the model by 0.05 or more. When describing velocity and position, we typically use negative values to indicate leftward, but for these models, we treat leftward and rightward values as separate variables. The table below shows the resulting best model for each cell, the shift, or latency between neural activity and behavior that provides the best model (measured by R^2^) and the R^2^ of the resulting model compared to the real neural activity.


```r
tab<-xtable(d[,1:4],caption='This table shows the results of a step-wise fitting procedure that with a threshold for inclusion of an increase of 0.5 in the R2')
#print(tab,comment=FALSE)
kable(d[,1:4],digits=2,align='l')
```



Neuron      shift   rsquared   f                        
----------  ------  ---------  -------------------------
SB21Oct11   120     0.77       fr ~ 1 + rhv + rep       
UB21dec11   60      0.70       fr ~ 1 + lep             
UB22may12   70      0.64       fr ~ 1 + rhv + lhv       
SE17Oct11   150     0.58       fr ~ 1 + rhv             
SB10Oct11   170     0.58       fr ~ 1 + rhp + rhv       
UC22may12   80      0.57       fr ~ 1 + rhv + lhv       
SC23Sep11   130     0.47       fr ~ 1 + lhv             
UBA4jun12   90      0.46       fr ~ 1 + rhv + lhv       
SD09Jan12   130     0.41       fr ~ 1 + lhv             
UB23mar12   80      0.40       fr ~ 1 + lhv + rep       
SC12Dec11   70      0.40       fr ~ 1 + lhv             
UB16feb12   90      0.40       fr ~ 1 + lhv             
UB05jan12   60      0.39       fr ~ 1 + lhp + lhv + rha 
SB15Sep11   110     0.37       fr ~ 1 + rhv             
UB28sep11   20      0.35       fr ~ 1 + rhp + rhv + rep 
SD03Nov11   160     0.34       fr ~ 1 + lhv             
SC18Oct11   40      0.33       fr ~ 1 + rhv + lep       
SB16Sep11   70      0.32       fr ~ 1 + lhv             
UD16sep11   130     0.32       fr ~ 1 + lhv             
UB04nov11   70      0.31       fr ~ 1 + rhv + lhv       
UBB4jun12   130     0.30       fr ~ 1 + rhv + lhv       
SB18Oct11   70      0.30       fr ~ 1 + rhv             
UB26mar12   80      0.30       fr ~ 1 + lhv             
UE31oct11   40      0.29       fr ~ 1 + rhv + lhv       
SC21Dec11   130     0.29       fr ~ 1 + lhv             
SC07Oct11   80      0.28       fr ~ 1 + lhp + lhv       
SD13Jan12   190     0.27       fr ~ 1 + lhv             
UC17feb12   100     0.26       fr ~ 1 + lhv + rep       
SC16Sep11   60      0.26       fr ~ 1 + lhv + lep       
UB24oct11   50      0.24       fr ~ 1 + rhv             
UC03jan12   110     0.23       fr ~ 1 + lhv + rep       
UB14may12   100     0.23       fr ~ 1 + rhv + lhv       
SC19Oct11   70      0.22       fr ~ 1 + rhv             
SD30Sep11   200     0.22       fr ~ 1 + rhp + rhv       
SC28Nov11   110     0.21       fr ~ 1 + lhv + lep       
SC14Oct11   180     0.20       fr ~ 1 + rhv             
SD04Jan12   60      0.20       fr ~ 1 + rhv             
SC19Jan12   190     0.20       fr ~ 1 + lhv             
SB28Sep11   50      0.19       fr ~ 1 + rhv + lep       
SD21Sep11   60      0.18       fr ~ 1 + rhv + lhv       
SB05Oct11   80      0.17       fr ~ 1 + rhv + lhv       
SB10Jan12   90      0.17       fr ~ 1 + lhv + lep       
SB30Sep11   130     0.16       fr ~ 1 + rhv             
SB19Jan12   120     0.16       fr ~ 1 + rhv             
SD06Dec11   50      0.15       fr ~ 1 + rhv + lhv       
SB04Nov11   90      0.15       fr ~ 1 + rhv + lhv       
UB07oct11   80      0.14       fr ~ 1 + lhp + rhv       
UB23feb12   50      0.13       fr ~ 1 + rhv             
SD28Sep11   130     0.09       fr ~ 1 + rep             
UB11jan12   40      0.06       fr ~ 1 + lhp             
SB07Oct11   200     0.05       fr ~ 1 + rhv             
SC15Sep11   20      0.00       fr ~ 1                   
UB14dec11   20      0.00       fr ~ 1                   


Breaking down the results shown in the above table, first we show the number of times each variable appears in any of the the final models.

![](extrafigs2_files/figure-html/coefCounts-1.png) 

It is clear that leftward and rightward head velocity are included more than any other varaibles, but we also see influence of head and eye position in several models. Only one model was improved significantly by the inclusion of head acceleration. In the figure below, we compare the model prediction of firing rate with the actual firing rate for one neuron. The model for this neuron uses a latency of 130 ms and predicts firing rate with an R^2^ of 0.47 using only leftward head velocity. The stepwise fit procedure did not find any single term that would improve the R^2^ by 0.05 or more, yet the model systematically underestimates firing rate during the gaze shift and overestimates firing rate during the pursuit task. This is consistent with the previous observation that the relationship between peak firing rate and peak head velocity was significantly different between tasks types for this neuron. 

![ModelGSPSExample](ModelDemoSC23Sep11.png)

Below, we show the model prediction for a neuron that includes a significant eye position term. In the left panels, the eyes begin the trials in the center of the orbits, while in the right panels, the eyes begin deviated to the right in the orbits. The increased firing during fixation in this position is predicted by the eye position term in the model. Similarly, after the gaze shift, the firing rate is also elevated, corresponding with the eccentric eye position.

![ModelPositionExample](ModelDemoSB21Oct11.png)

Because head position and eye position are often correlated, it may be possible to model activity equally well using either as a single parameter in the model, particularly for models with low R^2^ values. We investigate this position-related activity further by isolating the periods of fixation before and after gaze shifts. We then fit the activity of each of the cells that included a position term in the stepwise fit above with the model: 

$$Fr = x_{0}+x_{1}H_{R}+x_{2}E_{R}+x_{3}H_{L}+x_{4}E_{L}$$

In the table below, for each neuron, we show the coefficient ($x_{1-4}$) with the greatest value using this method.


  Neuron      rsquared    Highest.Coefficient    Position.Type  
-----------  ----------  ---------------------  ----------------
 UB21dec11      0.95             7.96             Leftward.Eye  
 SB21Oct11      0.76             2.16            Rightward.Eye  
 SC18Oct11      0.58             0.85            Rightward.Head 
 SC28Nov11      0.20             1.05            Rightward.Eye  
 SB10Oct11      0.19             1.26            Rightward.Eye  
 UB05jan12      0.14             0.57            Rightward.Head 
 UC03jan12      0.11             0.39            Rightward.Eye  
 UB28sep11      0.11             0.42            Rightward.Head 
 SB28Sep11      0.10             1.27            Rightward.Head 
 SC16Sep11      0.10             0.71            Rightward.Eye  
 SC07Oct11      0.09             0.66            Rightward.Head 
 UC17feb12      0.08             0.17            Rightward.Head 
 UB23mar12      0.03             0.15            Rightward.Head 

Although our focus is on horizontal movements, our data set included movements off of the horizontal axis. These movements give us the opportunity to assess the sensitivity of these neurons to oblique eye and head movements. In the table below, we show the results of allowing upward or downward movements to be included as variables in the model, using the same modeling procedure as above. In the table, we represent upward movements with u and downward movements with d. We restrict the table to show only the eight neurons that included a vertical component to the fit.


Neuron      shift   rsquared   f                        
----------  ------  ---------  -------------------------
UB28sep11   20      0.37       fr ~ 1 + rhp + rhv + uhv 
SC21Dec11   130     0.34       fr ~ 1 + lhv + uhp       
UC17feb12   100     0.31       fr ~ 1 + lhv + rep + uhv 
SC19Oct11   70      0.36       fr ~ 1 + rhv + uhv + dep 
SD04Jan12   60      0.26       fr ~ 1 + rhv + uhv       
SB30Sep11   130     0.27       fr ~ 1 + rhv + uhv       
SB04Nov11   90      0.10       fr ~ 1 + uhv             
UB11jan12   40      0.14       fr ~ 1 + dhv             
