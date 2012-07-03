function values = cosineFilter(spikes, samples, width)
% values = cosineFilter(spikes, samples, width)
% Efficiently convolves a spike train with a cosine-shaped filter.
%
% For example if we have one spike at time 0, filter with a cosine of width
% 1 and sample at -5:.01:5 we get a nice bump function:
%   samples = cosineFilter([0], -5:.01:5, 1);
%   plot(-5:.01:5, samples)
%
% You can do this by binning, convolving and downsampling but for low
% sampling rates this is way faster / more accurate.
%
% Arguments:
%
% spikes ~ spike times SORTED IN ASCENDING ORDER!!!!
% samples ~ sample times
% width ~ width of cosine filter (looks like a hill)
%
% Returns:
%
% values ~ ( cos(x/width)/2+.5 * boxcar(width) ) # diracdelta(spikes)
%   where # represents convolution
values = cosineFilterMex(spikes, samples, width);