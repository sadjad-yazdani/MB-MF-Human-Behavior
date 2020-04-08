
function [Test]=GetTestDataFromRepository(TestNoiseIndex)
if nargin<1
    TestNoiseIndex=1;
end

TestData=load('Data/TestDataset2.mat');

Test.SNum=min(size(TestData.Features,1),30000);
TestNoiseIndex=min(max(TestNoiseIndex,1),size(TestData.Features,3));

Test.FeaturesName   = TestData.FeaturesName;
Test.Features       = TestData.Features(1:Test.SNum,:,TestNoiseIndex);
Test.Label          = TestData.Label(1:Test.SNum,TestNoiseIndex);
Test.FittedW        = TestData.FittedW(1:Test.SNum,:,TestNoiseIndex);
Test.BestFittedW    = TestData.BestFittedW(1:Test.SNum,:,TestNoiseIndex);
Test.NoiseRatio     = TestData.NoiseRatio(TestNoiseIndex);
