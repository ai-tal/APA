function P = loadFFE_dispatch(filePath)
%LOADFFE_DISPATCH Load *.ffe — FEKO vs other tools share this extension.
    fid = fopen(filePath, 'r');
    assert(fid >= 0, 'Cannot open file.');
    cleanup = onCleanup(@() fclose(fid));
    block = fread(fid, [1 8192], '*char');

    if contains(block, 'FEKO', 'IgnoreCase', true) || contains(block, 'Altair', 'IgnoreCase', true)
        P = io.loadFEKO_ffe(filePath);
        return
    end
    try
        P = io.loadFEKO_ffe(filePath);
    catch
        error('io:ffe', ...
            ['Could not parse .ffe file. If this is Ansys HFSS export, save as .ffd ' ...
             'or provide the vendor-specific ASCII header so it can be distinguished from FEKO .ffe.']);
    end
end
