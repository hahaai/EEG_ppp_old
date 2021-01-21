function name = get_name(raw_address)
name = strsplit(raw_address,'/');
name = strsplit(name{end},'.');
name = name{1};