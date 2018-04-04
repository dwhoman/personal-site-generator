# format date for printing
function format_date(timestamp, result, cmd) {
    # timestamp = CCYYMMDDhhmm
    # date wants CCYY-MM-DD
    cmd = "date '+%B %d %Y' --date='" substr(timestamp,1,4) "-" substr(timestamp,5,2) "-" substr(timestamp,7,2) "'"
    cmd | getline result
    close(cmd)
    return result
}

# format date for xml dateTime
function format_dateTime(timestamp, dateTime) {
    # timestamp = CCYYMMDDhhmm[ss]
    # xml dateTime is CCYY-MM-DDThh:mm:ss where T is the character T
    dateTime = substr(timestamp,1,4) "-" substr(timestamp,5,2) "-" substr(timestamp,7,2) "T"\
	    substr(timestamp,9,2) ":" substr(timestamp,11,2) ":"
    if(length(timestamp) >= 14) {
	dateTime = dateTime substr(timestamp, 13,2)
    } else {
	dateTime = dateTime "00"
    }
    return dateTime
}

function timestamp_to_seconds(timestamp, result, cmd) {
    # timestamp = CCYYMMDDhhmm[ss], returns Unix time in seconds
    cmd = "date '+%s' --date='" substr(timestamp,1,4) "-" substr(timestamp,5,2) "-" substr(timestamp,7,2) " "\
	substr(timestamp,9,2) ":" substr(timestamp,11,2) ":"
    if(length(timestamp) >= 14) {
	cmd = cmd substr(timestamp, 13,2)
    } else {
	cmd = cmd "00"
    }
    cmd = cmd "'"
    cmd | getline result
    close(cmd)
    return result
}

function seconds_to_timestamp(timestamp, result, cmd) {
    cmd = "date '+%Y%m%d%H%M%S' --date='@" timestamp "'"
    cmd | getline result
    close(cmd)
    return result
}

function array_insert(array, val, position, itter) {
    if(length(array) == position - 1) {
	array[position] = val
    } else if(length(array) < position) {
	print "Trying to insert into array non-contiguously." array " " val " " position > "/dev/stderr"
	close("/dev/stderr")
	exit
    } else {
	itter = length(array) + 1
	while(itter > position) {
	    array[itter] = array[itter - 1]
	    itter--
	}
	array[position] = val
    }
}

function search_add(array, val, ind, unixtime, array_len) {
    # add val to the specified sorted array of unique elements, if val is in
    # array, increment val and try to insert again. Return the new value of val.
    if(array[1] == "") {
	array[1] = val
	return val
    }
    ind = 1
    array_len = length(array)
    while(ind <= array_len) {
	if(array[ind] == val) {
	    val++
	} else if(array[ind] > val) {
	    break
	}
	ind++
    }
    array_insert(array, val, ind)
    return val
}

function unique_update(timestamp) {
    return seconds_to_timestamp(search_add(update_dates, timestamp_to_seconds(timestamp)))
}

function unique_publish(timestamp) {
    return seconds_to_timestamp(search_add(publish_dates, timestamp_to_seconds(timestamp)))
}

function uri_encode(str) {
    gsub(/%/, "%25", str)
    gsub(/!/, "%21", str)
    gsub(/#/, "%23", str)
    gsub(/\$/, "%24", str)
    gsub(/&/, "%26", str)
    gsub(/'/, "%27", str)
    gsub(/\(/, "%28", str)
    gsub(/\)/, "%29", str)
    gsub(/\*/, "%2A", str)
    gsub(/\+/, "%2B", str)
    gsub(/,/, "%2C", str)
    gsub(/\//, "%2F", str)
    gsub(/:/, "%3A", str)
    gsub(/;/, "%3B", str)
    gsub(/=/, "%3D", str)
    gsub(/\?/, "%3F", str)
    gsub(/@/, "%40", str)
    gsub(/\[/, "%5B", str)
    gsub(/\]/, "%5D", str)
    gsub(/[[:space:]]/, "%20", str)
    gsub(/"/, "%22", str)
    gsub(/</, "%3C", str)
    gsub(/>/, "%3E", str)
    gsub(/\\/, "%5C", str)
    gsub(/\^/, "%5E", str)
    gsub(/`/, "%60", str)
    gsub(/\{/, "%7B", str)
    gsub(/\|/, "%7C", str)
    gsub(/\}/, "%7D", str)
    gsub(/~/, "%7E", str)
    return str
}

function under_space(str) {
    gsub(/[[:space:]]/,"_",str)
    return str
}

function array_max(assoc_array, max, kw) {
    max = ""
    for(kw in assoc_array) {
	if(length(max "") == 0 || assoc_array[kw] > max) {
	    max = assoc_array[kw]
	}
    }
    return max
}

function array_min(assoc_array, min, kw) {
    min = ""
    for(kw in assoc_array) {
	if(length(min "") == 0 || assoc_array[kw] < min) {
	    min = assoc_array[kw]
	}
    }
    return min
}

# use linear normalization to determine word font size
function font_size(count_i, min_count, max_count, quot) {
    if(count_i <= min_count || !(min_count < max_count)) {
	return 1
    } else {
	return int(4 * (count_i - min_count) / (max_count - min_count) + 1)
    }
}

function chomp(str, begin, end) {
    if(length(str) == 0) {
	return ""
    }
    begin = match(str, "[^[:space:]+]")
    end = match(str, "[[:space:]]*$")
    if(end - begin < 1) {
	return ""
    }
    return substr(str, begin, end - begin)
}

BEGIN {
    FS=","
    print "<?xml version=\"1.0\"?>"
    print "<index>"
    publish_dates[0] = ""
    update_dates[0] = ""    
}
/^[[:space:]]*$/{
    next
}
{
    file = chomp($1)
    if(length(file) == 0) {
	print "File name missing." > "/dev/stderr"
	close("/dev/stderr")
	exit
    }
    title = chomp($2)
    if(length(title) == 0) {
	print file " title missing." > "/dev/stderr"
	close("/dev/stderr")
	exit
    }
    updated = chomp($3)
    if(length(updated) == 0) {
	print file " update date missing." > "/dev/stderr"
	close("/dev/stderr")
	exit
    }
    published = chomp($4)
    if(length(published) == 0) {
	print file " publication date missing." > "/dev/stderr"
	close("/dev/stderr")
	exit
    }

    update_datetime = unique_update(updated)
    publish_datetime = unique_publish(published)
    print "<entry><file>"uri_encode(file)"</file><title>"title"</title><updated date='" update_datetime "' datetime='" format_dateTime(update_datetime) "'>" \
	format_date(update_datetime)"</updated><published date='" publish_datetime "' datetime='" format_dateTime(publish_datetime) "'>"format_date(publish_datetime)"</published>"
    print "<keywords>"
    for(i = 5; i <= NF; ++i) {
	keyword = chomp($i)
	if(keyword in keywords) {
	    keywords[keyword] += 1
	} else {
	    keywords[keyword] = 1
	}
	print "<keyword uri='" under_space(keyword) "'>" keyword "</keyword>"
    }
    print "</keywords>"
    printf "<description>"
    system("xsltproc --nonet --nodtdattr --novalid description.xsl org-html/" file)
    print"</description>"

    command = "xsltproc --nonet --nodtdattr --novalid --stringparam file " file " get-thread-pointer.xsl generated/thread-pointers.xml"
    command_val = command " | xml sel -t -c '//*[name()=\"prev\" or name()=\"next\"]'"
    command_error = command " | xml sel -t -c '//error'"
    errors = ""
    command_error | getline errors
    close(command_error)

    if(length(errors) == 0) {
	command_val | getline threads
	close(command_val)
	print threads
    } else {
	print errors > "/dev/stderr"
	close("/dev/stderr")
    }
    print "</entry>"
}
END {
    t_max = array_max(keywords)
    t_min = array_min(keywords)

    # keywords[key] is the number of occurrences of that keyword in all of the blog post keyword lists
    for(key in keywords) {
	font_sizes[key] = font_size(keywords[key], t_min, t_max)
    }
    
    print "<keys>"
    for(key in font_sizes) {
	print "<word data-scale='" font_sizes[key] "' id='" under_space(key) "'>" key "</word>"
    }
    print "</keys>"
    print "</index>"
}
