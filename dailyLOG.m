function dailyLOG(pngs2go,AnalysisFolder, WhoRan, Recorder,CheckNum);

% Dan Woodrich
% Nov 2016
% turned into a function by cb on 12/20/16 and some edits and headers added.

%--------------------------------------------------------------------------
%Dan: check to see if there is a png counter file
clockk = clock;
% single_entry = [pngs2go clock now-693960]; % It seems you just want an overall
% date/time stamp column, so this does it faster.
% the 693... value is the difference between excel and matlab date starts
logfilename = [AnalysisFolder '\dailyLOG_' upper(WhoRan) '.xlsx']; % one per person
if exist(logfilename) == 0;  % if it doesn't exist yet
    sz = 0;
 else
    [nums,txt] = xlsread(logfilename,'', '' , 'basic'); % speed this up a bit with basic 

    txt = txt(2:end,2:4); % just add headers back in at end.
    sz = size(nums,1);
end

if CheckNum ==3; CN = 'SHI';
elseif CheckNum == 2; CN = 'REG';
elseif CheckNum == 1; CN = 'LOW';
end

% then add new entry for this session: 
nums(sz+1,:) = [pngs2go, nan,nan,nan,0,0,0,clockk(1), ...
    clockk(2),clockk(3),clockk(4),clockk(5),clockk(6),datenum(now)];
txtstuff = {datestr(datenum(now),'yyyy-mm-dd HH:MM:SS');Recorder;CN};
txt(sz+1,:) = txtstuff';

% determine if this is a new recorder.

if sz >0;
    if strmatch(Recorder,char(txt(sz,2))) == 1;
        new = 0;
    else
        new = 1;
    end
else
    new = 2;
end

% this should now be a nums/txt list of all past effort


% From this list calculate the number of pngs done in the last session and the overall
% # pngs done for that day


% get the current day date:
Today = datenum(datestr(now,'yyyy-mm-dd'));

% Find the last entry before this one and do the 2 calculations;
if size(nums,1) >1 & new == 0; % but only do this if there is more than one entry
    % and it isn't a new recorder
    
    Dates = datenum(datestr(nums(:,end),'yyyy-mm-dd')); % these are all the date stamps, rounded to day.
    
    LastPngTotal = nums(end-1,1);
    Totalpngs4session = LastPngTotal-pngs2go;
    nums(sz,5) = Totalpngs4session;
    % need to determine if that last entry was a different day than today
    if Dates(end-1) == Today; % then it is the same day and you can tally.
        if size(nums,1) <=2; % can't sum if not there.
            Totalpngs4day = Totalpngs4session;
        else
            if Dates(end-2) < Today; % if two ago was a different day, then start over at 0.
                Totalpngs4day = 0+Totalpngs4session; % add the last one to the one before that
            else
                Totalpngs4day = nums(end-2,6)+Totalpngs4session; % add the last one to the one before that
            end
        end
        nums(sz,6) = Totalpngs4day;
    else % then it is a new day;
        
        % make sure that there isn't just one entry
        
        if size(nums,1) >2 % has to be a 2 here because this code adds the new line
            
            % first finish off the previous day
            Totalpngs4dayhier = nums(end-2,6)+Totalpngs4session; % add the last one to the one before that
            nums(sz,6) = Totalpngs4dayhier;
            % and flag that row as the total for that day
            nums(sz,7) = 1;
        else % it is either a single run for that day
            nums(sz,7) = 1;
        end
        
    end
elseif new == 1;
    nums(sz,7) = 1;
end

% max the giant cell matrix out of this all



metaDataHeaders = {'Pngsdone'; 'CurrentDate'; 'Mooring';'FreqBand';'TotalPngs4Session'; ...
    'TotalPngs4Day';'Max4day';'Year' ; 'Month'; 'Day'; 'Hour'; 'Minute'; 'Second'; 'Datenum'};

C = metaDataHeaders';  % this is the header row
C = [C; num2cell(nums)]; % add in all the values here
C(2:end,2) = txt(:,1); % add in the Mooring names
C(2:end,3) = txt(:,2); % add in the Mooring names
C(2:end,4) = txt(:,3); % add in the analysis frequency bands
idx=cellfun(@isstr,C); % convert the strings into something
C(idx)=strcat('''',C(idx)); %excel can handle without getting its panties in a bunch

xlswrite(logfilename,C);


system('taskkill /F /IM EXCEL.EXE');
