fid = fopen('.\data_ab.h','w');
%% Lowpass
%% B
fprintf(fid,['#define N_LOWPASS_B %d' char([13 10])], length(b_lp));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float b_lp[] = { ','uchar');
for ct = 1:length(b_lp)-1
    fprintf(fid,'%.7ff, ', single(b_lp(ct)));
end
fprintf(fid,'%.7ff', single(b_lp(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');
%% A

fprintf(fid,['#define N_LOWPASS_A %d' char([13 10])], length(a_lp));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float a_lp[] = { ','uchar');
for ct = 1:length(a_lp)-1
    fprintf(fid,'%.7ff, ', single(a_lp(ct)));
end
fprintf(fid,'%.7ff', single(a_lp(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%% Bandpass
%% B
fprintf(fid,['#define N_BANDPASS_B %d' char([13 10])], length(b_bp));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float b_bp[] = { ','uchar');
for ct = 1:length(b_bp)-1
    fprintf(fid,'%.7ff, ', single(b_bp(ct)));
end
fprintf(fid,'%.7ff', single(b_bp(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');
%% A

fprintf(fid,['#define N_BANDPASS_A %d' char([13 10])], length(a_bp));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float a_bp[] = { ','uchar');
for ct = 1:length(a_bp)-1
    fprintf(fid,'%.7ff, ', single(a_bp(ct)));
end
fprintf(fid,'%.7ff', single(a_bp(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%% Highpass FILTER
%% B
fprintf(fid,['#define N_HIGHPASS_B %d' char([13 10])], length(b_hp));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float b_hp[] = { ','uchar');
for ct = 1:length(b_hp)-1
    fprintf(fid,'%.7ff, ', single(b_hp(ct)));
end
fprintf(fid,'%.7ff', single(b_hp(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');
%% A

fprintf(fid,['#define N_HIGHPASS_A %d' char([13 10])], length(a_hp));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float a_hp[] = { ','uchar');
for ct = 1:length(a_hp)-1
    fprintf(fid,'%.7ff, ', single(a_hp(ct)));
end
fprintf(fid,'%.7ff', single(a_hp(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%%
fclose(fid);
