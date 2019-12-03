#run multiple instance regression using Xiaoxiao Du method

[Parameters] = learnCIMeasureParams();

#The TrainBags input is a 1xNumTrainBags cell. Inside each cell, NumPntsInBag x nSources double -- Training bags data.

[TrainBags] = 



#The TrainLabels input is a 1xNumTrainBags double vector that takes values of "1" and "0" for two-class classfication problems -- Training labels for each bag.

[TrainLabels] = 



[measure, initialMeasure,Analysis] = learnCIMeasure_regression(TrainBags, TrainLabels, Parameters);