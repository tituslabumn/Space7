%clc
%clear all

%% read in data
%data = readtable('puncta1.csv');

%% function
% INPUT: data frame with columns tipX, tipY, and framenum

% OUTPUT: dataBD = table with unique BDs assigned to each filo tip 

%assignTipID(data,20);

function dataInit = assignInit(data)


if ~isempty(data)
    
%data = puncta1ID;
id = 1;    
    for i = 1:numel(data.framenum)
           if data.id(i) == id
                dataInit(id,:) = data(i,:);
                id = id + 1;
           else 
                continue;
           end
    end
    
end 
end