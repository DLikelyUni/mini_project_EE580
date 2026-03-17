%Filter Implementation
clearvars;clc;
% close all;
L=10000;
rng(1);
x=wgn(L,1,0); %random noise signal

fs=8*1e3;
fc1=fs/6;
fc2=fs/3;

t=((0:L-1)*(1/fs));
t=t'*1e3;
% load coefficients
lp=load("lowpass3.mat");
bp=load("bandpass3.mat");
hp=load("highpass3.mat");

% quantise to single precision
x=single(x);
lp.SOSq=single(lp.SOS);
lp.Gq=single(lp.G);
bp.SOSq=single(bp.SOS);
bp.Gq=single(bp.G);
hp.SOSq=single(hp.SOS);
hp.Gq=single(hp.G);

% Filter signals
y_lp=filtfilt(lp.SOSq,lp.Gq,x);
% y_lp=filter(b_lp,a_lp,x);
y_bp=filtfilt(bp.SOSq,bp.Gq,x);
y_hp=filtfilt(hp.SOSq,hp.Gq,x);

% add filter outputs
y_all=y_lp+y_bp+y_hp;
y_LB=y_lp+y_bp;
y_LH=y_lp+y_hp;
y_BH=y_bp+y_hp;
%% save to data.h
[b_lp,a_lp]=sos2tf(lp.SOSq,lp.Gq);
[b_bp,a_bp]=sos2tf(bp.SOSq,bp.Gq);
[b_hp,a_hp]=sos2tf(hp.SOSq,hp.Gq);
% b_lp=single(b_lp);
% a_lp=single(a_lp);


% save_data;
% pz plots of filter coefficients
figure('Name','PZ plot of lp coeffs');
zplane(b_lp, a_lp);
title('Pole-Zero Plot from Coefficients');
grid on;

figure('Name','PZ plot of bp coeffs');
zplane(b_bp, a_bp);
title('Pole-Zero Plot from Coefficients');
grid on;

figure('Name','PZ plot of hp  coeffs');
zplane(b_hp, a_hp);
title('Pole-Zero Plot from Coefficients');
grid on;
%%
y_lp=filter(b_lp,a_lp,x);
y_bp=filter(b_bp,a_bp,x);
y_hp=filter(b_hp,a_hp,x);
y_all=y_lp+y_bp+y_hp;


%% magnitude-phase plots
Hlp = dfilt.df2sos(lp.SOSq,lp.Gq);
Hbp = dfilt.df2sos(bp.SOSq,bp.Gq);
Hhp = dfilt.df2sos(hp.SOSq,hp.Gq);
%%
% fvtool(Hlp);
% fvtool(Hbp);
% fvtool(Hhp);
%% plot pole zeros
plotpz(lp);
plotpz(bp);
plotpz(hp);
%%
X=abs(fft(x));
B=abs(fft(x-y_all));
normB=(B-min(X))/(max(X)-min(X));
normX=(X-min(X))/(max(X)-min(X));
% normdiff=normX-normB;
errorpercent=max(normB)*100;
%%
figure('Name','normalised frequency plot of signal')
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),normX)
hold on;
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),normB)
title('Normalised error value in reconstruction of signal')
ylabel('percentage')
xlim([0 4000])


%% figures 

%% frequency domain
figure('Name','x v y FFT')
tiledlayout(2,1)
nexttile
plotFFT(x);
title('FFT Input signal x[n], wgn.')
nexttile
plotFFT(y_all);
% plotsig(y_hp);
title('FFT allpass (lp+bp+hp) filter output y[n].')
%%

% freq plots for report
figure('Name','lp FFT')
% plotFFT(x);
plotFFT(y_lp);
% plotsig(y_lp);
title('FFT Lowpass filter output y_1[n].')
%
figure('Name','bp FFT')
plotFFT(x);
plotFFT(y_bp);
% plotsig(y_bp);
title('FFT Bandpass filter output y_2[n].')

figure('Name','hp FFT')
% plotFFT(x);
plotFFT(y_hp);
% plotsig(y_hp);
title('FFT Highpass filter output y_3[n].')
%% combined filters
figure('Name','all FFT 2')
plotFFT(x);
plotFFT(y_all);
% plotsig(y_hp);
title('FFT allpass (lp+bp+hp) filter output y[n].')
legend({'x' 'y all'})
%%
figure('Name','lp+bp FFT')
plotFFT(y_LB);
plotFFT(x);
legend({'filt output' 'x'})
% plotsig(y_hp);
title('FFT expanded lp (lp+bp) filter output y[n].')

figure('Name','lp+bp 2 FFT')
plotFFT(y_lp);
plotFFT(y_bp);
% plotsig(y_hp);
title('FFT expanded lp (lp+bp) filter output y[n].')

figure('Name','lp+hp FFT')
plotFFT(y_LH);
plotFFT(x);
% plotsig(y_hp);
legend({'filt output' 'x'})
title('FFT bandstop (lp+hp) filter output y[n].')

figure('Name','bp+hp FFT')
plotFFT(y_BH);
plotFFT(x);
legend({'filt output' 'x'})
% plotsig(y_hp);
title('FFT extended highpass (bp+hp) filter output y[n].')

figure('Name','bp+hp 2 FFT')
plotFFT(y_hp);
plotFFT(y_bp);
% plotsig(y_hp);
title('FFT extended highpass (bp+hp) filter output 2 y[n].')
%%
%time domain of filters
figure('Name','x[n] time')
plottime(x,t);
% plotsig(x);
title('Input signal x[n], wgn.')

figure('Name','lp time')
plottime(y_lp,t);
% plotsig(y_lp);
title('Lowpass filter output y_1[n].')

figure('Name','bp time')
plottime(y_bp,t);
% plotsig(y_bp);
title('Bandpass filter output y_2[n].')

figure('Name','hp time')
plottime(y_hp,t);
% plotsig(y_hp);
title('Highpass filter output y_3[n].')
%%
function plotFFT(x)
    fs=8*1e3;
    plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
    xlabel('Hz');
    ylabel('amplitude');
    xlim([0 4000]);
    hold on;
end

function plottime(x,t)
    plot(t,x);
    xlabel('t(ms)');
    ylabel('amplitude');
    xlim([0 t(end)])
    hold on;
end

function plotsig(x)
    plot(x);
    xlabel('sample (n)');
    ylabel('amplitude');
    hold on;
end

function plotpz(x)
    [z,p,~]=sos2zp(x.SOS,x.G);
    [zq,pq,~]=sos2zp(x.SOSq,x.Gq);
    figure()
    tiledlayout(2,1)
    nexttile
    zplane(z,p);
    title('Pole Zero - Pre-Quantization')
    nexttile
    zplane(zq,pq);
    title('Pole Zero - Quantized')
end

