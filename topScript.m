framerate = 1;
pixel = 0.21164;
maxpunctaperfilo = 1; %%1 for one filo per one puncta, keep it simple
shaftmax = 3/pixel; %max shaft lenght in um
path = '';
maxNumOfCells = 4;

%function below separates csv file of puncta from ilastik based on cells
%maxNumOfCells is maximum number of cells per given movie.

%this function separates trajectory data from xy data of the cell body. it
%gives a list of names of the cell with number of slices, so you can
%feed it into next functions
slices = ijm2space7(path)


for i = 1:numel(slices.name)
    angular(path, slices.name{i} , framerate, pixel, 1, slices.num{i}, maxpunctaperfilo, shaftmax)
    plotRose({path}, slices.name{i}, pixel)
end 

anglesTotal = [];
for i = 1:numel(slices.name)
    angles = angular(path, slices.name{i} , framerate, pixel, 1, slices.num{i}, maxpunctaperfilo, shaftmax);
    plotRose({path}, slices.name{i}, pixel)
    anglesTotal = [anglesTotal; angles];
end
