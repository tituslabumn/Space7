function angles = angular(path, name, framerate, pixel, minframe, maxframe, maxpunctaperfilo, shaftmax)


%name = 'p1-1-1';
namePun = strsplit(name,'-');
namePun = strcat(namePun{1},'-',namePun{2})

%if isfile(strcat(path, 'space7-in\cell\', name, '.csv'))
cellData = readtable(strcat(path, 'space7-in\cell\', name, '.csv'));
%else
%   strcat('No cell body', name, 'found');
%   break
%end
%if isfile(strcat(path, 'space7-in\puncta\', name, '.csv'))


punctaData = readtable(strcat(path, 'space7-in\puncta\', namePun, '.csv'));
%else
%    strcat('No puncta', name, 'found');
%    break
%end

%% combining tips and cell

%Change minframe and maxframe to number of frames you want to use


%how many puncta per filo is there?

mdata = table(cellData.Label+1, cellData.X, cellData.Y, zeros(numel(cellData.Label),maxpunctaperfilo),...
    zeros(numel(cellData.Label),maxpunctaperfilo),zeros(numel(cellData.Label), maxpunctaperfilo), ...
    zeros(numel(cellData.Label),1),zeros(numel(cellData.Label),1),zeros(numel(cellData.Label),1),...
    zeros(numel(cellData.Label),1),zeros(numel(cellData.Label),1));
mdata.Properties.VariableNames{1} = 'framenum';
mdata.Properties.VariableNames{2} = 'X';
mdata.Properties.VariableNames{3} = 'Y';
mdata.Properties.VariableNames{4} = 'shaft';
mdata.Properties.VariableNames{5} = 'tipX';
mdata.Properties.VariableNames{6} = 'tipY';
mdata.Properties.VariableNames{7} = 'theta';

%% finding shaftlenght

params.centrX = [];
params.centrY = [];
maxframe = max(cellData.Label)+1;



for frame = 1:maxframe
    [row col] = find(mdata.framenum == frame);
    params.centrX(frame) = mean(mdata.X(row));
    params.centrY(frame) = mean(mdata.Y(row));
    params.pixelnum(frame) = numel(row);
   % params.centrX(frame) = mean(mdata_dynamic.X(shaftloc2glob(frame)+1:shaftloc2glob(frame+1)-1));  
    %params.centrY(frame) = mean(mdata_dynamic.Y(shaftloc2glob(frame)+1:shaftloc2glob(frame+1)-1));
end

shaftloc2glob(1) = 0; %% vector that converts local number of tip to global index
shaftloc2glob(2:numel(cumsum(params.pixelnum))+1) = cumsum(params.pixelnum);
for frame = minframe:maxframe
%frame = 1;
puncta = punctaData((frame-1) == punctaData.timestep,:);
outline = mdata(frame == mdata.framenum,:);
if isempty(puncta)
     %sprintf ('No puncta at the frame %d', frame);
elseif isempty(outline)
     %sprintf ('No outline at the frame %d', frame);
else 
    %%plot the outline
    %plot(outline.X, outline.Y, puncta.CenterOfTheObject_0, puncta.CenterOfTheObject_1,'ro') 
    %xlim ([1 620])
    %ylim ([1 620])
    %ax = gca;
    %ax.YDir = 'reverse';

    %to find a perpendicular from a tip to the outline we find min distance xy  
    %since we are in MATLAB, let's try to keep things efficient: (https://gist.github.com/jboner/2841832) 
    %L1 cache is only 128 Kb, which means that from the big data perspective it is better to loop over the
    % oultine points and mark tips that are closest so the tip coordinates are still in
    % L1. However, it is unclear how to distinguish puncta along the same tip,
    % so do vice versa
    punctanum = size(puncta,1);
      for i = 1:punctanum
        distances{i} = (puncta.CenterOfTheObject_0(i)-outline.X).^2+(puncta.CenterOfTheObject_1(i)-outline.Y).^2;
        [puncta.shaftlength(i) puncta.shaftbase(i)] = min(distances{i});
            if mdata.shaft(shaftloc2glob(frame)+puncta.shaftbase(i),1) == 0
                mdata.shaft(shaftloc2glob(frame)+puncta.shaftbase(i),1) = sqrt(puncta.shaftlength(i));
                mdata.tipX(shaftloc2glob(frame)+puncta.shaftbase(i),1) =  puncta.CenterOfTheObject_0(i);
                mdata.tipY(shaftloc2glob(frame)+puncta.shaftbase(i),1) = puncta.CenterOfTheObject_1(i);
            else 
                for j = 2:maxpunctaperfilo
                    if mdata.shaft(shaftloc2glob(frame)+puncta.shaftbase(i),j) == 0
                        mdata.shaft(shaftloc2glob(frame)+puncta.shaftbase(i),j) = sqrt(puncta.shaftlength(i));
                        mdata.tipX(shaftloc2glob(frame)+puncta.shaftbase(i),j) =  puncta.CenterOfTheObject_0(i);
                        mdata.tipY(shaftloc2glob(frame)+puncta.shaftbase(i),j) = puncta.CenterOfTheObject_1(i);
                        break;
                    else
                        continue;
                    end
                end
            end;
              %% if you don't care about the outline
%         puncta.shaftlength(i) = sqrt(puncta.shaftlength(i));
%         puncta.baseX(i) = outline.X(puncta.shaftbase(i));
%         puncta.baseY(i) = outline.Y(puncta.shaftbase(i));
    end
    end
end

% sprintf ('mdata has %d puncta, and there are %d total puncta detected', numel(mdata.shaft(mdata.shaft>0)), numel(punctaData.timestep));
%  if ~exist(strcat(pathdata, '\space7'))
%        mkdir(pathdata, 'space7');
%     end
% pathAnalysis = strcat(pathdata, '\space7'); 
% writetable(mdata, strcat(pathAnalysis,'\mdata.csv'));




%% Calculating theta from the topmost pixel
%clearvars mdata_dynamic.theta;

mdata_dynamic = mdata;

mdata_dynamic.Properties.VariableNames{8} = 'thetanorm';
mdata_dynamic.Properties.VariableNames{11} = 'curvature';


%% plot trajectory

% plot(params.centrX,params.centrY)
% xlim ([1 512])
% ylim ([0 512])
% ax = gca;
% ax.YDir = 'reverse';
% plot(params.centrX,params.centrY)

for frame = minframe:maxframe
%mdata_dynamic(params.pixelnum(frame)+1) = 0;
    for i = shaftloc2glob(frame)+1:shaftloc2glob(frame+1)-1
        %% angular coordinate
        mdata_dynamic.theta(i+1) = mdata_dynamic.theta(i) + sqrt((mdata_dynamic.X(i)-...
        mdata_dynamic.X(i+1))^2+(mdata_dynamic.Y(i)-mdata_dynamic.Y(i+1))^2);
%         %% curvature
%         if i == shaftloc2glob(frame)+1 && i == shaftloc2glob(frame+1)-1
%             continue
%         else
%             xprime = (mdata_dynamic.X(i+1)-mdata_dynamic.X(i-1))
%         end
    end
end
params.perimeter = mdata_dynamic.theta(shaftloc2glob(2:maxframe+1));
for i = 1:size(mdata_dynamic.framenum,1)
    if i == 98
        t = 1;
    end
     mdata_dynamic.thetanorm(i) = 360*mdata_dynamic.theta(i)/params.perimeter(mdata_dynamic.framenum(i));
end 
 
%% filtering and plotting

[rowTipNL colTipNL] = find(mdata_dynamic.shaft < shaftmax);
mdata_NL = mdata_dynamic(rowTipNL, :);

 
 [rowPunct colPunct] = find(mdata_NL.shaft(:,1) ~= 0);
 mdata_puncta = mdata_NL(rowPunct, :);
%   mdata_puncta.thetanorm = zeros(numel(mdata_puncta.framenum),1);
%  for i = 1:size(mdata_puncta.framenum)
%      mdata_puncta.thetanorm(i) = 360*mdata_puncta.theta(i)/params.perimeter(mdata_puncta.framenum(i));
%  end


% figure
% polaraxes
% h = colorbar;
% ylabel(h, 'filopodia length (um)')
% 
% hold on
% %%in frames
% polarscatter(mdata_puncta.thetanorm, mdata_puncta.framenum, 15, mdata_puncta.shaft*pixel)
% %%in seconds
% %timeaxis = 0.25*(minframe:maxframe-1);
% %scatter(timeaxis', mdata_NS_NL.thetanorm, 15, mdata_NS_NL.shaftum(:,1))
% %xlim([minframe maxframe])
% %ylim([0.000 360])
% %xlabel('Frame')
% %xlabel('Angular coordinate of the tips')
% %h = colorbar;
% %ylabel(h, 'filopodia length')
% %filename = sprintf ('filo500nm_6um_frame%d_%d.png',window*100,window*100+100);
% %print(strcat(pathAnalysis, '\', filename),'-r300', '-dpng');
% hold off



if ~exist(strcat(path, '\space7-out\cell'))
       mkdir(path, '\space7-out\cell');
end
if ~exist(strcat(path, '\space7-out\puncta'))
   mkdir(path, '\space7-out\puncta');
end
angles = mdata_puncta.thetanorm;
%writetable(mdata_dynamic, strcat(path, '\space7-out\cell\', name, '.csv'));
writetable(mdata_puncta, strcat(path, '\space7-out\puncta\', name, '.csv'));


end


