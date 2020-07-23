
mainDir = getDirectory("Choose a main directory"); 
openDir = mainDir+"ijm-in/";
openList = getFileList(openDir); 
File.makeDirectory(mainDir+"ijm-out/");
saveDir=mainDir+"ijm-out/"

setBatchMode(true);

for (i=0; i<openList.length; i++) {

open(openDir+openList[i]);
run("Make Binary", "method=Huang background=Dark calculate black");
run("Set Measurements...", "area mean min centroid perimeter stack redirect=None decimal=3");
setOption("BlackBackground", true);

str = split(getTitle(), ".");
str = str[0]+"_roi-";


run("Analyze Particles...", "size=10-Infinity clear add stack");


n = roiManager("count");

for ( j=0; j<n; j++ ) { 
	roiManager("select", j);
	run("Interpolate", "interval=1");
	outline2results(str+(j+1));
}

csvname = split(getTitle(), ".");
csvname = csvname[0];
saveAs("Results", saveDir+csvname+".csv");
close();
}
//"-"+i+"-"+i+"-"+i+i+
setBatchMode(false); //newly opnened images will be displayed
exit();//terminates the macro

function outline2results(lbl) {
	nR = nResults;  //Returns the current measurement counter value. The parentheses "()" are optional. See also: getValue("results.count").
	
	Roi.getCoordinates(x, y);
	for (i=0; i<x.length; i++) {
		setResult("Label", i+nR, j); //col title, row number, row value
		setResult("X", i+nR, x[i]);
		setResult("Y", i+nR, y[i]);
	}
}

