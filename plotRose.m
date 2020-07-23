function plotRose(pathSet, name, pixel)

for i =1:numel(pathSet)
    path = pathSet{i};
    
    puncta = readtable(strcat(path, 'space7-out\puncta\', name, '.csv'));


    f1 = figure;
    polarhistogram(puncta.thetanorm*2*pi/360,36);
    title(name);
    print(f1, strcat(path, 'space7-out\', name, 'rose'), '-dpng','-r300');

    mean(puncta.shaft)*pixel;

    %f2 = figure;
    %histogram(puncta.shaft*pixel,20);
    %xlabel('filopodia length (um)');
    %ylabel('count');
    %title(name);
    %print(f2, strcat(path, 'space7-out\', name, 'lenght'), '-dpng','-r300');

    % figure
    % originframe = 0;
    % hold on
    % %%in frames
    % scatter(originframe+puncta2ID.framenum,puncta2ID.thetanorm, 25, puncta2ID.shaft*pixel, 'filled')
    % %%in seconds
    % %timeaxis = 0.25*(minframe:maxframe-1);
    % %scatter(timeaxis', mdata_NS_NL.thetanorm, 15, mdata_NS_NL.shaftum(:,1))
    % xlim([minframe maxframe])
    % ylim([-10 360])
    % xlabel('Frame')
    % ylabel('Angular coordinate of the tips (degrees)')
    % 
    %  textCell = arrayfun(@(x) sprintf('%3.0f',x),puncta2ID.id,'un',0);
    %  for ii = 1:numel(puncta2ID.id) 
    %      text(originframe+puncta2ID.framenum(ii)-3, puncta2ID.thetanorm(ii)-10,textCell{ii},'FontSize',6) 
    %  end
    % 
    % % Plot scatter
    % % Add textCell
    % h = colorbar;
    % ylabel(h, 'filopodia length (um)')
    % %filename = sprintf ('filo500nm_6um_frame%d_%d.png',window*100,window*100+100);
    % %print(strcat(pathAnalysis, '\', filename),'-r300', '-dpng');
    % hold off
end

end

