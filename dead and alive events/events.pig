events = LOAD '/home/cloudera/Desktop/events.csv' USING PigStorage(',') AS (patientid:int, eventid:chararray, eventdesc:chararray, timestamp:chararray, value:float);

events = FOREACH events GENERATE patientid, eventid, ToDate(timestamp, 'yyyy-MM-dd') AS etimestamp, value;

mortality = LOAD'/home/cloudera/Desktop/mortality.csv' USING PigStorage(',') as (patientid:int, timestamp:chararray, label:int);

mortality = FOREACH mortality GENERATE patientid, ToDate(timestamp, 'yyyy-MM-dd') AS mtimestamp, label;

eventsjoin = JOIN events by patientid LEFT, mortality by patientid;
deadevents = Filter eventsjoin by(mortality::patientid is not null);
deadevents = FOREACH deadevents GENERATE events::patientid as patientid, events::eventid as eventid, events::value as value, mortality::label as label, DaysBetween(mortality::mtimestamp,events::etimestamp)-30 as time_difference;

aliveevents = Filter eventsjoin by(mortality::patientid is null);

aliveevents = FOREACH aliveevents GENERATE  events::etimestamp as timestamp, events::patientid as patientid, events::eventid as eventid, events::value as value, 0 as label;
aliveeventsgrp = GROUP aliveevents BY patientid;
aliveeventsindex = foreach aliveeventsgrp generate group as patientid,MAX(aliveevents.timestamp) as index;
aliveevents = join aliveevents by patientid, aliveeventsindex by patientid;
aliveevents =   FOREACH aliveevents GENERATE aliveevents::patientid as patientid, aliveevents::eventid as eventid, aliveevents::value as value, aliveevents::label as label, DaysBetween(aliveeventsindex::index,aliveevents::timestamp) as time_difference;

deadevents = ORDER deadevents BY patientid, eventid;
aliveevents = ORDER aliveevents BY patientid, eventid;
STORE aliveevents INTO '/home/cloudera/Desktop/aliveevents' USING PigStorage(',');
STORE deadevents INTO '/home/cloudera/Desktop/deadevents' USING PigStorage(',');


