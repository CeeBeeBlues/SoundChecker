function [PNGrslts_MetaData,fs] = getnumrows(PNGrslts_MetaData,butt,CheckNum);

% updates the number of rows for the team calibration quiz if the zoom and
% png functions don't work.


val = get(butt.numrows,'String');
val = str2num(val);

PNGrslts_MetaData(CheckNum).rowsPerPlot = val;
if val == 4;
    PNGrslts_MetaData(CheckNum).maxHz = 4096;
    fs = 8192;
elseif val == 2;
PNGrslts_MetaData(CheckNum).maxHz = 8192;
fs = 16384;
end