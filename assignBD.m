%clc
%clear all

%% read in data
%data = readtable('puncta1.csv');

%% function
% INPUT: data frame with columns tipX, tipY, and framenum

% OUTPUT: dataBD = table with unique BDs assigned to each filo tip 

%assignTipID(data,20);

function [dataIDs] = assignInit(data)
    for i = 1:numel(data.framenum)
        data.init
end 