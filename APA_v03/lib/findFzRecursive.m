function list = findFzRecursive(rootDir)
%FINDFZRECURSIVE Return full paths to all .fz files under rootDir.
    list = {};
    if exist(rootDir, 'dir') ~= 7
        return
    end
    D = dir(rootDir);
    for k = 1:numel(D)
        name = D(k).name;
        if D(k).isdir
            if strcmp(name, '.') || strcmp(name, '..')
                continue
            end
            list = [list, findFzRecursive(fullfile(rootDir, name))]; %#ok<AGROW>
        elseif endsWith(lower(name), '.fz')
            list{end+1} = fullfile(rootDir, name); %#ok<AGROW>
        end
    end
end
