function slices = ijm2space7(path)

%import outline file
%cd(strcat(path,'ijm-out\'))
cd(strcat(path,'ijm-out\'))
cellDataList = dir('*.csv');

for i=1:numel(cellDataList)
    [~, cellDataName, ~] = fileparts(cellDataList(i).name)
    cellData = readtable(strcat(path,'ijm-out\',cellDataList(i).name));

    [Col ~] = find(cellData.Label == 0);
    numSlice = min(Col);
    
    
    if ~exist(strcat(path, '\trajectory'))
           mkdir(path, '\trajectory');
    end
    %cellDataTraj = cellData(1:numSlice,:)
    writetable(cellData(1:numSlice-1,:), strcat(path, 'trajectory\', cellDataName, '.csv'));
    if ~exist(strcat(path, '\space7-in\cell'))
           mkdir(path, '\space7-in\cell');
    end
    writetable(cellData(numSlice:end,:), strcat(path, '\space7-in\cell\', cellDataName, '.csv'));
    slices.name{i} = cellDataName;
    slices.num{i} = numSlice;
end

