%clc
%clear all

%% read in data
%data = readtable('puncta1.csv');

%% function
% INPUT: data frame with columns tipX, tipY, and framenum
% maxDist: the maximum distance a filo tip should move from from one frame

% OUTPUT: dataIDs = table with unique IDs assigned to each filo tip 

%maxDist = 10;
%maxF = 5;
function dataID = assignTipID(data, maxDist, maxF)
%     if nargin < 2
%         maxDist = 5;
%     end 
if ~isempty(data)
data.id = zeros(numel(data.framenum),1);
totalframes = max(data.framenum);
    % find number filo tips in first frame
    Frame1 = data.framenum(1);
    nFrame1 = sum(data.framenum == Frame1); 

    % make a master list of filo ids to keep track of what has been added
    listFiloIDs = 1:1:nFrame1;
    
    % Assign filo IDs to each filo in the first frame
    data.id(1:1:nFrame1,1) = listFiloIDs;
    % Construct conversion vector
    [frameC, frameN] = hist(data.framenum, unique(data.framenum));
    FrGroup2Fr = cumsum(frameC');
    
    
    % iterate over groups of frames starting with second
    for k=1:numel(frameC)-1
        %frame 1 requires care
        if k == 1
            startFr = 1;
        else
            startFr = FrGroup2Fr(k-1)+1;
        end
        for i = startFr:FrGroup2Fr(k)
            if i ==6
                
            end
            for j = FrGroup2Fr(k)+1:FrGroup2Fr(k+1)
                if j == 2
                
                end
                if data.id(j) ~= 0
                    continue
                end
                dist(i,j) = (data.tipX(i)-data.tipX(j))^2+(data.tipY(i)-data.tipY(j))^2;
                if dist(i,j) < maxDist^2
                    data.id(j) = data.id(i);
                    break;
                else
                    continue;
                end;
            end;
        end;
        % here we go back in time until maxF         
        %% after reaching limit in maxF you can assign new id
    duplicateTest = [];
        for j = FrGroup2Fr(k)+1:FrGroup2Fr(k+1)
            duplicateTest = data.id([FrGroup2Fr(k)+1:FrGroup2Fr(k+1)]);
            if j == 19
            end
            if data.id(j) == 0
                %% go over all previous frames within maxPix
                if k ~= 1
                    for jj = FrGroup2Fr(k-1):-1:1
                        if data.framenum(j) - data.framenum(jj) > maxF
                            break
                        end
                        if data.framenum(j)-data.framenum(jj) < maxDist
                            dist(jj,j) = (data.tipX(jj)-data.tipX(j))^2+(data.tipY(jj)-data.tipY(j))^2;
                        if dist(jj,j) < maxDist^2
                            duplicateTestjj = [duplicateTest; data.id(jj)];
                            if all(diff(sort(duplicateTestjj(duplicateTestjj ~= 0))))
                                data.id(j) = data.id(jj);
                                break;
                            end;
                        else
                            continue;
                        end;
                    elseif data.framenum(j)-data.framenum(jj) >= maxDist
                        break;
                    end
                end
                end
                if data.id(j) == 0
                    data.id(j) = max(data.id) + 1;
                end
            end
          end
    anyDuplicates(k) = ~all(diff(sort(duplicateTest(duplicateTest ~= 0))));
   end
    Duplicates = sum(anyDuplicates);
    strcat(num2str(Duplicates), ' duplicates')
    dataID = data;

%end
 %[frameC, frameN] = hist(data.framenum, unique(data.framenum));
 %[idC, idN] = hist(data.id, unique(data.id));
end
end 
 