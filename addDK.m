% addDK.m
%dan test vandalism asd fasdf asdf
% This script adds a new species (the double knock) to an existing REG png analysis.
% Since Soundchecker is updated to expect another species
% any results that are currently being run, will need to have this species
% present.

% open pngrslts file.
ccc
[PngFile,AnalysisFold] = uigetfile({'\\nmfs.local\AKC-NMML\CAEP\Acoustics\ANALYSIS\*.mat'}, ...
    'Pick a pngRESLTs file to add double knocks field to.');
load([AnalysisFold PngFile]);
%check that this is a regular mooring
rightone = isempty(PNGrslts_MetaData(2).CheckNum);
if rightone == 0;
    
    s = size(resltMTX);
    % check that the double knocks haven't already been updated.
    if size(resltMTX,3) >11;
        fprintf(1,'This mooring has already been updated\n');
    else
        resltMTX(:,:,12) = repmat(99,s(1),s(2)); % put 99's in here.
        PNGrslts_MetaData(2).CheckSpp = [ PNGrslts_MetaData(2).CheckSpp; 'dblKnck '];
        
        handleMTX = [   10.0100   11.0100   12.0100   13.0100
            16.0100   17.0100  173.0101  174.0100
            177.0100  178.0100  179.0100  180.0100
            183.0100  184.0100  185.0100  186.0100
            189.0100  190.0100  350.0099  351.0099
            354.0099  355.0099  356.0099  357.0099
            360.0099  361.0099  362.0099  363.0099
            366.0099  367.0099  368.0099  369.0099
            372.0099  373.0099  374.0099  375.0099
            378.0099  379.0099  380.0099  381.0099
            384.0099  385.0099  386.0099  387.0099
            390.0099  391.0099  392.0099  393.0099];
        
        clear s;
        save([AnalysisFold PngFile]);
        fprintf(1,'All done, you can now start SoundChecker\n');
    end
else
    fprintf(1,'This is not a regular mooring\n');
end

