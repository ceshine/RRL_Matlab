Recurrent Reinforcement Learning Implementation using Matlab/Octave
================================

20210321 Update: A PyTorch-port of this repo is available at [ceshine/RRL_PyTorch](https://github.com/ceshine/RRL_PyTorch).

Reference: [Stock Trading with Recurrent Reinforcement Learning (RRL) By Gabriel Molina]

File Description
-----------

Core Functions
-
* costFunction.m
* updateFt.m
* rewardFunction.m
* featureNormalize.m
* sharpRatio.m

Utility Functions
-
* checkRRLGradient.m : Verify the correctness of gradient function in cost function
* getNumericalGradient.m : Approximate gradient (inefficiently) for verification

Test Function:
-
* testTWSE.m : Use Taiwan Weighted Stock Index from Taiwan Stock Exchange.
* testDAX.m : Use DAX index of Germany.


[Stock Trading with Recurrent Reinforcement Learning (RRL) By Gabriel Molina]: http://cs229.stanford.edu/proj2006/Molina-StockTradingWithRecurrentReinforcementLearning.pdf

