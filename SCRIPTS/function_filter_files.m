function function_filter_files()
    % Select folder containing .c and .h files
    folderPath = uigetdir('', 'Select folder containing .c and .h files');
    
    if folderPath == 0
        disp('Folder selection cancelled.');
        return;
    end
    
    % List all .c and .h files in the selected folder
    cFiles = dir(fullfile(folderPath, '*.c'));
    hFiles = dir(fullfile(folderPath, '*.h'));
    
    % Check if there are any files to zip
    if isempty(cFiles) && isempty(hFiles)
        disp('No .c or .h files found in the selected folder.');
        return;
    end
    
    % Exclude a specific .c file (e.g., excludeFile.c)
    excludeFileName = 'ert_main.c';
    excludeIndex = strcmp({cFiles.name}, excludeFileName);
    cFiles(excludeIndex) = []; % Remove the excluded file from the list
    
    % Create a zip file
    asw_ver=get_param('MCU_main/MCU_main/ASW_VER', 'Value');
    asw_ver=string(asw_ver);
    currentTime = datetime('now','Format','yyyy-MM-dd_HH-mm-ss');
    zipFileName = fullfile(folderPath,'MCU_'+asw_ver+'_'+string(currentTime));
    zip(zipFileName, {cFiles.name, hFiles.name}, folderPath);
    
    disp(['Zip file created: ', zipFileName]);
end
