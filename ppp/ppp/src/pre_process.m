function result = pre_process(data, raw_file_address, filter_mode)

%% Determine number of channels
chan_excl256  = [ 31 67 73 82 91 92 102 111 120 133 145 165 174 187 199 208 ... 
    209 216 217 218 219 225 226 227 228 229 230 231 232 233 234 235 236 ...
    237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 ...
    254 255 256];
load('chan111')  % the file chan111.mat is in the General matlab folder. 
                 % it contains the file, which defines the 111 (204 in the 
                 % 256) electrodes of the 128 (256 electrodes) electrodes
switch data.nbchan
    case 128
        channels = chan111;
        eog_channels = sort([1 32 8 14 17 21 25 125 126 127 128]);
        data.data(end+1,:) = 0;
        data.nbchan = data.nbchan + 1;
        data = pop_chanedit(data,  ...
            'load',{ ['GSN-HydroCel-129.sfp'], 'filetype', 'sfp'});
    case (128 + 1)
        channels = chan111;
        eog_channels = sort([1 32 8 14 17 21 25 125 126 127 128]);
        data = pop_chanedit(data, ...
            'load',{ 'GSN-HydroCel-129.sfp', 'filetype', 'sfp'});
    case 256
        channels = setxor(1:257, chan_excl256);
        eog_channels = sort([31 32 37 46 54 252 248 244 241 25 18 10 1 226 ...
            230 234 238]);
        data.data(end+1,:) = 0;
        data.nbchan = data.nbchan + 1;
        data = pop_chanedit(data, ...
            'load',{ 'GSN-HydroCel-257_be.sfp', 'filetype', 'sfp'});
    case (256 + 1)
        channels = setxor(1:257, chan_excl256);
        eog_channels = sort([31 32 37 46 54 252 248 244 241 25 18 10 1 226 ...
            230 234 238]);
        data = pop_chanedit(data, ...
            'load',{ 'GSN-HydroCel-257_be.sfp', 'filetype', 'sfp'});
    case 395  %% .fif files
        % Get rid of two wrong channels 63 and 64
        eegs = arrayfun(@(x) strncmp('EEG',x.labels, length('EEG')), data.chanlocs, 'UniformOutput', false);
        not_ecg = arrayfun(@(x) ~ strncmp('EEG063',x.labels, length('EEG063')), data.chanlocs, 'UniformOutput', false);
        not_wrong = arrayfun(@(x) ~ strncmp('EEG064',x.labels, length('EEG064')), data.chanlocs, 'UniformOutput', false);
        channels = find(cell2mat(eegs) & cell2mat(not_ecg) & cell2mat(not_wrong));
        [~, data] = evalc('pop_select( data , ''channel'', channels)');
        % Convert channel positions to EEG_lab format 
        [~, hd] = evalc('ft_read_header(raw_file_address)');
        hd_idx = true(1,74);
        hd_idx(63:64) = false;
        positions = hd.elec.chanpos(hd_idx,:);
        fid = fopen( 'pos_temp.txt', 'wt' );
        fprintf( fid, 'NumberPositions=	72\n');
        fprintf( fid, 'UnitPosition	cm\n');
        fprintf( fid, 'Positions\n');
        for pos = 1:length(positions)
          fprintf( fid, '%.8f %.8f %.8f\n', positions(pos,:));
        end
        fprintf( fid, 'Labels\n');
        fprintf( fid, ['EEG01	EEG02	EEG03	EEG04	EEG05	EEG06	EEG07	EEG08	EEG09	EEG010	EEG011	EEG012 '...
                      'EEG013	EEG014	EEG015	EEG016	EEG017	EEG018	EEG019	EEG020	EEG021	EEG022	EEG023	EEG024 '...
                      'EEG025	EEG026	EEG027	EEG028	EEG029	EEG030	EEG031	EEG032	EEG033	EEG034	EEG035	EEG036 '...
                      'EEG037	EEG038	EEG039	EEG040	EEG041	EEG042	EEG043	EEG044	EEG045	EEG046	EEG047	EEG048 '...
                      'EEG049	EEG050	EEG051	EEG052	EEG053	EEG054	EEG055	EEG056	EEG057	EEG058	EEG059	EEG060 '...
                      'EEG061	EEG062 EEG065	EEG066	EEG067	EEG068	EEG069	EEG070	EEG071	EEG072 '...
                      'EEG073	EEG074']);
        fprintf( fid, '\n');
        fclose(fid);
        eeglab_pos = readeetraklocs('pos_temp.txt');
        delete('pos_temp.txt');
        data.chanlocs = eeglab_pos;
        
        % Distinguish EOGs(61 & 62) from EEGs
        eegs = arrayfun(@(x) strncmp('EEG',x.labels, length('EEG')), data.chanlocs, 'UniformOutput', false);
        eog1 = arrayfun(@(x) strncmp('EEG061',x.labels, length('EEG061')), data.chanlocs, 'UniformOutput', false);
        eog2 = arrayfun(@(x) strncmp('EEG062',x.labels, length('EEG062')), data.chanlocs, 'UniformOutput', false); 
        channels = find((cellfun(@(x) x == 1, eegs)));
        channel1 = find((cellfun(@(x) x == 1, eog1)));
        channel2 = find((cellfun(@(x) x == 1, eog2)));
        eog_channels = [channel1 channel2];
    otherwise
        error('This number of channel is not supported.')

end
clear chan111
s = size(data.data);
assert(data.nbchan == s(1)); clear s;

%% Preprocess data
% filtering on the whole dataset
filtered_data = perform_filter(data, filter_mode);

% seperate EEG channels from EOG ones
unique_chans = setdiff(channels, eog_channels);
[~, EEG] = evalc('pop_select( filtered_data , ''channel'', channels)');
[~, EOG] = evalc('pop_select( filtered_data , ''channel'', eog_channels)');
[~, EEG_unique] = evalc('pop_select( filtered_data , ''channel'', unique_chans)');

% Detect artifact channels
rejected_chans = reject_channels(EEG);

% Remove effect of EOG
EEG_regressed = EOG_regression(EEG_unique, EOG);

% PCA
[EEG_cleared, noise] = perform_pca(EEG_regressed);
% Replace common channels of eeg and eog by zeros and put together with
% unique eeg channels
eeg_cleaned = zeros(size(filtered_data.data));
eeg_cleaned(unique_chans,:) = EEG_cleared.data;
EEG_cleaned = EEG;
EEG_cleaned.data = eeg_cleaned(channels,:);

% interpolate zero and artifact channels:
display('Interpolating...');
if ~isempty(rejected_chans)
    [~, interpolated] = evalc('eeg_interp(EEG_cleaned ,rejected_chans ,''spherical'')');
end
interpolated.auto_badchans = rejected_chans;
% detrending
res = bsxfun(@minus, interpolated.data, mean(interpolated.data,2));
result = interpolated;
result.data = res;
