% === Project Startup Script ===

% Get current project root
prj = simulinkproject;
projectRoot = prj.RootFolder;

% Set CODE_GEN path
codeGenDir = fullfile(projectRoot, 'CODE_GEN');

% Create folder if it doesn't exist
if ~exist(codeGenDir, 'dir')
    mkdir(codeGenDir);
end

% Set Simulink preferences for current session (not global!)
Simulink.fileGenControl('set', ...
    'CacheFolder', codeGenDir, ...
    'CodeGenFolder', codeGenDir, ...
    'createDir', true);

disp(['✔ Simulink cache and codegen folders set to: ', codeGenDir]);
