function [String]=TimePrint(Seconds)
Day = fix(Seconds/(3600*24));
Houre = fix((Seconds-Day*24*3600)/3600);
Minute = fix((Seconds-Day*24*3600-3600*Houre)/60);
Second = round(Seconds-Day*24*3600-3600*Houre-60*Minute);
if Day == 0
    String=sprintf('%02d:%02d:%02d',Houre,Minute,Second);
else
    String=sprintf('%d-%02d:%02d:%02d',Day,Houre,Minute,Second);
end
if nargout==0
    fprintf(String);
end