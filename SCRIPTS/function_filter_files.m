% Select folder containing .c and .h files
folderPath = uigetdir('', 'Select folder containing .c and .h files');

if folderPath == 0
    disp('Folder selection cancelled.');
    return;
end

% Generate path string including the selected folder and its subfolders
allDirectories = strsplit(genpath(folderPath), ';');

% Initialize arrays to store .c and .h files
cFiles = [];
hFiles = [];

% Iterate through each directory in the selected path
for i = 1:length(allDirectories)
    %.c files in the current directory
    cFilesInDir = dir(fullfile(allDirectories{i}, '*.c'));
    cFiles = [cFiles; cFilesInDir];

    %.h files in the current directory
    hFilesInDir = dir(fullfile(allDirectories{i}, '*.h'));
    hFiles = [hFiles; hFilesInDir];
end

% Exclude 'ert_main.c'
excludeFileName = 'ert_main.c';
excludeIndex = strcmp({cFiles.name}, excludeFileName);
cFiles(excludeIndex) = []; % Remove the excluded file from the list

% Check if there are any files to process
if isempty(cFiles) && isempty(hFiles)
    disp('No .c or .h files found in the selected folder and its subfolders.');
    return;
end

% Create folders for .c and .h files if they don't exist
cFolderPath = fullfile(folderPath, 'src');
hFolderPath = fullfile(folderPath, 'include');

if ~exist(cFolderPath, 'dir')
    mkdir(cFolderPath);
else
    % Delete existing files in .c_files folder
    delete(fullfile(cFolderPath, '*.c'));
end

if ~exist(hFolderPath, 'dir')
    mkdir(hFolderPath);
else
    % Delete existing files in .h_files folder
    delete(fullfile(hFolderPath, '*.h'));
end

% Copy all .c files (excluding 'ert_main.c') to the .c_files folder
for i = 1:length(cFiles)
    destination = fullfile(cFolderPath, cFiles(i).name);
    % Check if the destination folder is different from the source folder
    if ~strcmp(cFiles(i).folder, cFolderPath) && ~strcmp(cFiles(i).folder, destination)
        copyfile(fullfile(cFiles(i).folder, cFiles(i).name), destination);
    end
end

% Copy all .h files to the .h_files folder
for i = 1:length(hFiles)
    destination = fullfile(hFolderPath, hFiles(i).name);
    % Check if the destination folder is different from the source folder
    if ~strcmp(hFiles(i).folder, hFolderPath) && ~strcmp(hFiles(i).folder, destination)
        copyfile(fullfile(hFiles(i).folder, hFiles(i).name), destination);
    end
end


disp('Files copied to src , include folders.');

% Create a zip file in the selected folder
zipsFolderPath = fullfile(folderPath, 'zip_files');
if ~exist(zipsFolderPath, 'dir')
    mkdir(zipsFolderPath);
end
asw_ver= 01; %get_param('BMS_MAIN/BMS_ASW/ASW_VER', 'Value');
asw_ver=string(asw_ver);
currentTime = datetime('now','Format','yyyy-MM-dd_HH-mm-ss');

% Create a zip file for both .c_files and .h_files folders
zipFileName = fullfile(zipsFolderPath, 'MCU_FOC_'+asw_ver+'_'+ string(currentTime));
zip(zipFileName, {cFolderPath, hFolderPath});

disp(['Zip file created in: ', zipFileName]);
