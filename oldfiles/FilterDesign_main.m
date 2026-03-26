%EE580 mini project filter design
clear;clc;
fs=8*1e3;
fc1=fs/6;
fc2=fs/3;
x=wgn(10000,1,0);

filt=mp_makefilters;
%% low pass
[b_lp,a_lp]=sos2tf(lp.SOS,lp.G);
[sos,g]=tf2sos(b_lp,a_lp);
% zpad=zeros(1,19);
% a_lp=[a_lp zpad];
% b_lp=[b_lp zpad];
%%
lowpass.SOS=SOS_lp;
lowpass.G=G_lp;
bandpass.SOS=SOS_bp;
bandpass.G=G_bp;
highpass.SOS=SOS_hp;
highpass.G=G_hp;

save("lowpass4.mat","-struct","lowpass")
save("bandpass4.mat","-struct","bandpass")
save("highpass4.mat","-struct","highpass")
%%
% lowpass.SOS=SOS_lp2;
% lowpass.G=G_lp2;
% save("lowpass_t.mat","-struct","lowpass")
% %%
% bandpass.SOS=SOS_bp2;
% bandpass.G=G_bp2;
% save("bandpass_t.mat","-struct","bandpass")
% %%
% highpass.SOS=SOS_hp2;highpass.G=G_hp2;
% save("highpass_t.mat","-struct","highpass")
%%
[z,p,~]=sos2zp(SOS_lp,G_lp);

sos2=single(SOS_lp);
g2=single(G_lp);
[z2,p2,~]=sos2zp(sos2,g2);

figure()
tiledlayout(2,1)
nexttile
zplane(z,p);
title('LP: Pole Zero - Pre-Quantization')
nexttile
zplane(z2,p2);
title('LP: Pole Zero - Post-Quantization')
%%
[b_lp2,a_lp2]=sos2tf(sos2,g2);
%%
y_lp=filter(b_lp,a_lp,x);
y_lp2=filtfilt(sos2,g2,x);
%% band pass
[b_bp,a_bp]=sos2tf(SOS_bp,G_bp);
% a_bp=[a_bp 0];
% b_bp=[b_bp 0];
%%
% bandpass.a=a_bp;
% bandpass.b=b_bp;
% save("bandpass.mat","-struct","bandpass")

%%
% y_bp=filter(b_bp,a_bp,x);

figure(3);
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
xlabel('Hz');
xlim([0 4000]);
%%
figure(4);
tiledlayout(2,1)
nexttile
plot(fs*(0:(1/length(y_lp)):(length(y_lp)-1)/length(y_lp)),abs(fft(y_lp)));
xlabel('Hz');
xlim([0 4000]);
nexttile
plot(fs*(0:(1/length(y_lp2)):(length(y_lp2)-1)/length(y_lp2)),abs(fft(y_lp2)));
xlabel('Hz');
xlim([0 4000]);

%% high pass
[b_hp,a_hp]=sos2tf(SOS_hp,G_hp);
% zpad=zeros(1,19);
% a_hp=[a_hp zpad];
% b_hp=[b_hp zpad];
%%
highpass.a=a_hp;
highpass.b=b_hp;
save("highpass.mat","-struct","highpass")
%%

y_hp=filter(b_hp,a_hp,x);
%%
figure(3);
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
xlabel('Hz');
xlim([0 4000]);

figure(4);
plot(fs*(0:(1/length(y_hp)):(length(y_hp)-1)/length(y_hp)),abs(fft(y_hp)));
xlabel('Hz');
xlim([0 4000]);

%% HP + LP

a_hp = [a_hp zeros(1,32)];
b_hp = [b_hp zeros(1,32)];

a=a_lp+a_bp;
b=b_lp+b_bp;

a_2 = [a_lp a_hp];

b_2 = [b_lp b_hp];

y=filter(b_2,a_2,x);

figure(3);
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
xlabel('Hz');
xlim([0 4000]);

figure(4);
plot(fs*(0:(1/length(y)):(length(y)-1)/length(y)),abs(fft(y)));
xlabel('Hz');
% xlim([0 4000]);