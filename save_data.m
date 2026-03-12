fid = fopen('.\assignment_1_ccs\data.h','w');
%% FIR FILTER
%% B
fprintf(fid,['#define N_FIR_B %d' char([13 10])], length(Hd2));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float Hd2[] = { ','uchar');
for ct = 1:length(Hd2)-1
    fprintf(fid,'%.7ff, ', single(Hd2(ct)));
end
fprintf(fid,'%.7ff', single(Hd2(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');
%% A
fprintf(fid,['#define N_FIR_A %d' char([13 10])], length(Hd1));
fwrite(fid,char([13 10]),'uchar');
fwrite(fid,'float Hd1[] = { ','uchar');
for ct = 1:length(Hd1)-1
    fprintf(fid,'%.7ff, ', single(Hd1(ct)));
end
fprintf(fid,'%.7ff', single(Hd1(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');


fclose(fid);
