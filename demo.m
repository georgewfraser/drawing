% Load all the data into a common format.  A bunch of cell arrays will be
% loaded into the workspace with names like coutRate, coutKin, drawingKin,
% etc.  They have the format:
%
% data ~ #days x 1 cell array
% data{i} ~ struct where each field is a piece of data (kinematic variable,
%   neural firing rate, etc)
% data{i}.variable ~ #trials x #timeslices matrix of values for variable
%
% When the data has a name like dataMean, it's a mean across trials so it
%   has the format:
%
% data{i}.variable ~ #conditions x #timeslices matrix of values
%
% There are a few special data arrays:
%
% drawing and centerOut are the raw data
% drawingSnips and coutSnips give metadata about how each trial was sliced up

%tupacCollectAllSnips;
frankCollectAllSnips;

% Look at some center-out firing rate data from day 3
showFilmstripPlot(coutRateMean{3});
disp('Press any key to continue...');
pause % press any key!
close all

% Kinematic data is in the same format so we can look at it with the same
% function
showFilmstripPlot(coutKinMean{3});
disp('Press any key to continue...');
pause
close all

% Look at some drawing data
figure(1);
showAllDrawingPlots(drawingRateMean{3});

% Drawing kinematics
figure(2);
showAllDrawingPlots(drawingKinMean{3});

% Canonical correlation analysis
% Identify canonical coefficients with 5-fold cross validation
[canA, canB, canR, canLag, fold] = drawingCanonical(drawingSnips, drawingKin, drawing);
% Reconstruct canonical variables from firing rates while respecting
% cross-validation
canRate = projectCanonical(drawingSnips, drawingRate, canB, fold);
% Take mean of canonical variables across trials within condition
% (illusion, ellipse, circle)
canRateMean = meanByDrawing(drawingSnips, canRate);
% Plot the canonical variables!
figure(3);
for i=1:length(canRateMean)
    showAllDrawingPlots(canRateMean{i}); 
end