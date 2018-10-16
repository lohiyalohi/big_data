log = LOAD '/home/cloudera/Desktop/log4j-application.log' as line;
LEVELS = foreach log generate REGEX_EXTRACT(line,'(TRACE|DEBUG|INFO|WARN|FATAL)',1) as LOGLEVEL;
FILTEREDLEVELS = FILTER LEVELS by LOGLEVEL is not null;
GROUPEDLEVELS = GROUP FILTEREDLEVELS by LOGLEVEL;
FREQUENCIES = foreach GROUPEDLEVELS generate group as LOGLEVEL,COUNT(FILTEREDLEVELS.LOGLEVEL) as count;
STORE FREQUENCIES into '/home/cloudera/Desktop/log' using PigStorage(',');
