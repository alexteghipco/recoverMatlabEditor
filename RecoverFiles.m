function [recentFiles] = RecoverFiles(filename)
% [recentFiles] = RecoverFiles(filename)
% Restores .m files in MATLAB editor after a fatal crash/corruption of xml file that stores .m files to open at startup.

if isempty(filename)
    filename = [prefdir filesep 'MATLAB_Editor_State.xml'];
end
document = xmlread(filename);

% Get information about 'File' nodes
recentFiles = struct([]);
fileNodes = document.getElementsByTagName('File');
for fni = 1:(fileNodes.getLength())
    attributes = fileNodes.item(fni-1).getAttributes(); % Careful, zero based indexing !
    for ai = 1:(attributes.getLength())
        % Get node attribute
        name = char(attributes.item(ai-1).getName()); % Zero based + need marshaling COM 'string' type
        value = char(attributes.item(ai-1).getValue()); % Zero based + need marshaling COM 'string' type
        
        % Save in structure
        name(1) = upper(name(1)); % Just because I prefer capital letter for field names ...
        recentFiles(fni).(name) = value;
    end
end


for i = 1:length(recentFiles)
    disp(['Opening: ' recentFiles(i).AbsPath '/' recentFiles(i).Name])
    try
        open([recentFiles(i).AbsPath '/' recentFiles(i).Name])
        disp('Success')
    catch
        disp('Failed')
    end
end
