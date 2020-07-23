function splitCSVbyLabel(path, maxNumOfCells)

if ~exist(strcat(path, '\space7-in\puncta'))
       mkdir(path, '\space7-in\puncta');
    end

%import puncta file and split it by cells
cd(strcat(path,'ilastic\'))
punctaDataList = dir('*.csv');
for i = 1:numel(punctaDataList)
    [~, punctaDataName, ~] = fileparts(punctaDataList(i).name)
    punctaData = readtable(strcat(path, 'ilastic\', punctaDataList(i).name));
    for j = 1:maxNumOfCells
        rowSingleCell = [];
        cellID = ['Label ' num2str(j)];
        cellIDcolumn = punctaData.PredictedClass;
        for k = 1:numel(cellIDcolumn)
            if numel(cellIDcolumn{k}) ~= numel(cellID)
                continue
            elseif cellIDcolumn{k} == cellID
                rowSingleCell = [rowSingleCell k];
            else
                continue;
            end    
        end
        if isempty(rowSingleCell)
            break;
        end
        writetable(punctaData(rowSingleCell, :) , strcat(path, 'space7-in\puncta\           ' , punctaDataName, '-', num2str(j), '.csv'));
    end  
end

end

