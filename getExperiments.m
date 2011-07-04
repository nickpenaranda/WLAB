function [expNames expHandles] = getExperiments()
    dirList = dir();
    expNames = cell(0);
    for i = 1:size(dirList,1)
        if(dirList(i).isdir == 0)
            expName = regexp(dirList(i).name,'^do(.+)\.m$','tokens');
            if(~isempty(expName))
                name = expName{1}{1};
                expNames = [expNames name];
            end
        end
    end
    expHandles = cell(size(expNames));
    for i=1:size(expNames,2)
        expHandles{i} = str2func(['do' expNames{i}]);
    end
end