function selected_datastructure_process(app_properties)
selected_data_format = app_properties.selected_data_format;
if(isequal(selected_data_format.name,'BrainStorm') && is_checked_datastructure_properties(selected_data_format) )
    bst_db_path = selected_data_format.bst_db_path;
    if(isfolder(bst_db_path))
        protocols = dir(fullfile(bst_db_path,'**','protocol.mat'));
        if(~isempty(protocols))
            for i = 1: length(protocols)
                if(~protocols(i).isdir)
                    protocol = load(fullfile(protocols(i).folder,protocols(i).name));
                    protocol_base_path = fileparts(protocols(i).folder);
                    protocol_data_path = protocols(i).folder;
                    protocol_anat_path = fullfile(protocol_base_path,'anat');
                    for j=1: length(protocol.ProtocolSubjects.Subject)
                        subject = protocol.ProtocolSubjects.Subject(j);
                        CortexFile = fullfile(protocol_anat_path, subject.Surface(subject.iCortex).FileName);
                        ScalpFile =  fullfile(protocol_anat_path,subject.Surface(subject.iScalp).FileName);
                        InnerSkullFile = fullfile(protocol_anat_path,subject.Surface(subject.iInnerSkull).FileName);
                        OuterSkullFile = fullfile(protocol_anat_path,subject.Surface(subject.iOuterSkull).FileName);
                        for k=1: length(protocol.ProtocolStudies.Study)
                            study = protocol.ProtocolStudies.Study(k);
                            if(isequal(fileparts(study.BrainStormSubject),subject.Name) && ~isempty(study.iChannel) && ~isempty(study.iHeadModel))
                                ChannelsFile = fullfile(protocol_data_path,study.Channel(study.iChannel).FileName);
                                HeadModelFile = fullfile(protocol_data_path,study.HeadModel(study.iHeadModel).FileName);
                                modality = char(study.Channel.Modalities);
                                break;
                            end
                        end       
                        %% Save here all files or do other things
                        % These are all files
                        modality
                        CortexFile
                        ScalpFile
                        InnerSkullFile
                        OuterSkullFile
                        ChannelsFile
                        HeadModelFile
                    end
                end
            end
        else
            disp('No one protocol in this foldes:');
            disp('C:\Users\Ariosky\.brainstorm\local_db');
        end
    end
end

disp("-->> Process finished....")

end