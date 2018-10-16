data = load '/home/cloudera/Desktop/symptoms_bench.csv' using PigStorage(',') as (disease:chararray,symptom:chararray);
result = filter data by ((symptom == 'fever') or(symptom == 'headache'));
result1 = foreach result generate disease;
store result1 into '/home/cloudera/Desktop/result7' using PigStorage(',');

