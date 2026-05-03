function list = findPatternFiles(rootDir)
%FINDPATTERNFILES Return full paths to pattern files under rootDir (recursive).
    list = {};
    exts = {'fz', 'uan', 'ffs', 'ffd', 'ffe', 'out'};
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
            list = [list, findPatternFiles(fullfile(rootDir, name))]; %#ok<AGROW>
        else
            [~, ~, ext] = fileparts(name);
            if isempty(ext)
                continue
            end
            ext = lower(ext(2:end));
            if any(strcmp(ext, exts))
                list{end+1} = fullfile(rootDir, name); %#ok<AGROW>
            end
        end
    end
end
