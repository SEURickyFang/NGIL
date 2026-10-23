function tests=test_slip_reference
tests=functiontests(localfunctions);
end

function setupOnce(testCase)
controlDir=fullfile(fileparts(fileparts(mfilename('fullpath'))),'control');
addpath(controlDir);
testCase.addTeardown(@()rmpath(controlDir));
end

function testGroupedWheelOrder(testCase)
base=[0.11;0.12;0.13;0.21;0.22;0.23];
action=[0.25;0.75;0.04];
expected=[0.0825;0.09;0.0975;0.0525;0.055;0.0575];
verifyEqual(testCase,slip_reference(action,base),expected,'AbsTol',1e-12);
end

function testLeftReleaseOnly(testCase)
base=[0.11;0.12;0.13;0.21;0.22;0.23];
verifyEqual(testCase,slip_reference([1;0;0],base), ...
    [0;0;0;0.21;0.22;0.23],'AbsTol',1e-12);
end

function testRightReleaseOnly(testCase)
base=[0.11;0.12;0.13;0.21;0.22;0.23];
verifyEqual(testCase,slip_reference([0;1;0],base), ...
    [0.11;0.12;0.13;0;0;0],'AbsTol',1e-12);
end

function testManuscriptPermutation(testCase)
basePaper=[0.11;0.21;0.12;0.22;0.13;0.23];
codeFromPaper=[1 3 5 2 4 6];
paperFromCode=[1 4 2 5 3 6];
action=[0.25;0.75;0.04];
actualPaper=slip_reference(action,basePaper(codeFromPaper));
actualPaper=actualPaper(paperFromCode);
expectedPaper=basePaper.*[0.75;0.25;0.75;0.25;0.75;0.25];
verifyEqual(testCase,actualPaper,expectedPaper,'AbsTol',1e-12);
end
