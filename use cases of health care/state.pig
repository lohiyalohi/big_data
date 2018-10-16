health = load '/home/cloudera/Desktop/santosh/Payment_and_value_of_care_-_Hospital.csv' using PigStorage('\t') as (ProviderID:chararray,HospitalName:chararray,Address:chararray,City:chararray,State:chararray,ZIPCode:chararray,Countyname:chararray,Phonenumber:chararray,Paymentmeasurename:chararray,PaymentmeasureID:chararray,Paymentcategory:chararray,Denominator:chararray,Payment:chararray,Lowerestimate:chararray,Higherestimate:chararray,Paymentfootnote:chararray,Valueofcaredisplayname:chararray,ValueofcaredisplayID:chararray,Valueofcarecategory:chararray,Valueofcarefootnote:chararray,MeasureStartDate:chararray,MeasureEndDate:chararray,Location:chararray);

result = filter health by Paymentmeasurename == 'Payment for heart failure patients';
result1 = FOREACH result generate State,City,Hospitalname,Location;
split result1 into st1 if State =='AK',st2 if State =='AL',st3 if State =='AZ',
STORE st1 into '/home/cloudera/Desktop/santosh/st1' using PigStorage(',');
STORE st2 into '/home/cloudera/Desktop/santosh/st2' using PigStorage(',');
STORE st3 into '/home/cloudera/Desktop/santosh/st3' using PigStorage(',');
