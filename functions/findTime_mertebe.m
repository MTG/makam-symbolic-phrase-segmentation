function [time, mertebe] = findTime_mertebe(usulName, usulFile)
% Returns the time and the "mertebe" of the piece from the usul
% If the usul is not found in the "usulFile" the function will return
% 4/4 (sofyan)
%   usulName:  e.g. 'aksak', 'duyek'
%   usulFile:  the path of the usul file. If not given as an input the
%   default usul file in the package will be loaded

if (nargin == 1) || (strcmp(usulFile, ''))
    p = fileparts(mfilename('fullpath'));
    usulFile  =fullfile(p,'files','usuller.txt');
end

%Default
time   = 4;
mertebe = 4;

fid = fopen(usulFile);

if fid == -1
    warning('findTime_mertebe:usulFile', 'usulFile cannot be opened')
else
    ok = 0;
    while ok == 0 && ~feof(fid)
        kayit = fgetl(fid);
        s = regexp(kayit, '\t', 'split');
        if strcmp(s(1), usulName)
            time = str2double(s(3));
            mertebe = 2^str2double(s(4));
            ok = 1;
        end
    end
    
    fclose(fid);
    if ok == 0
        warning('findTime_mertebe:usulName',...
            [usulName ' is not found in the usul file.'])
    end
end
end
