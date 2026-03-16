fid = fopen('.\data_sos_arr.h','w');
%% Lowpass 
sos=lp.SOSq;G=lp.Gq;
%% sos
fprintf(fid,['#define N_LP %d x %d' char([13 10])], size(sos,1),size(sos,2));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float LP_SOS[] = { ','uchar');
for i=1:size(sos,1)-1
    for ct = 1:size(sos,2)
        if mod(ct,6)==0
            fprintf(fid,'%.7ff, ', single(sos(i,ct)));
        else
            fprintf(fid,'%.7ff, ', single(sos(i,ct)));
        end
    end
end

for ct = 1:size(sos,2)-1
    fprintf(fid,'%.7ff, ', single(sos(end,ct)));
end
fprintf(fid,'%.7ff', single(sos(end,end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%% G
fprintf(fid,['#define N_LP_G %d' char([13 10])], length(G));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float LP_G[] = { ','uchar');
for ct = 1:length(G)-1
    fprintf(fid,'%.7ff, ', single(G(ct)));
end
fprintf(fid,'%.7ff', single(G(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');
%% BANDPASS 
sos=bp.SOSq;G=bp.Gq;
%% sos
fprintf(fid,['#define N_BP_SOS %d x %d' char([13 10])], size(sos,1),size(sos,2));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float BP_SOS[] = { ','uchar');
for i=1:size(sos,1)-1
    for ct = 1:size(sos,2)
        if mod(ct,6)==0
            fprintf(fid,'%.7ff; ', single(sos(i,ct)));
        else
            fprintf(fid,'%.7ff, ', single(sos(i,ct)));
        end
    end
end

for ct = 1:size(sos,2)-1
    fprintf(fid,'%.7ff, ', single(sos(end,ct)));
end
fprintf(fid,'%.7ff', single(sos(end,end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%% G
fprintf(fid,['#define N_BP_G %d' char([13 10])], length(G));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float BP_G[] = { ','uchar');
for ct = 1:length(G)-1
    fprintf(fid,'%.7ff, ', single(G(ct)));
end
fprintf(fid,'%.7ff', single(G(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%% HIGHPASS 
sos=hp.SOSq;G=hp.Gq;
%% sos
fprintf(fid,['#define N_HP_SOS %d x %d' char([13 10])], size(sos,1),size(sos,2));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float HP_SOS[] = { ','uchar');
for i=1:size(sos,1)-1
    for ct = 1:size(sos,2)
        if mod(ct,6)==0
            fprintf(fid,'%.7ff; ', single(sos(i,ct)));
        else
            fprintf(fid,'%.7ff, ', single(sos(i,ct)));
        end
    end
end

for ct = 1:size(sos,2)-1
    fprintf(fid,'%.7ff, ', single(sos(end,ct)));
end
fprintf(fid,'%.7ff', single(sos(end,end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

%% G
fprintf(fid,['#define N_HP_G %d' char([13 10])], length(G));
fwrite(fid,char([13 10]),'uchar');

fwrite(fid,'float HP_G[] = { ','uchar');
for ct = 1:length(G)-1
    fprintf(fid,'%.7ff, ', single(G(ct)));
end
fprintf(fid,'%.7ff', single(G(end)));
fwrite(fid,[' };' char([13 10])],'uchar');
fwrite(fid,char([13 10]),'uchar');

fclose(fid);