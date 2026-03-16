%TEST MAIN
%Filter Implementation
clear;clc;close all;
L=10000;
x=wgn(L,1,0); %random noise signal

fs=8*1e3;
t=((0:L-1)*(1/fs));
t=t'*1e3;
%% load coefficients
lp=load("lowpass.mat");
bp=load("bandpass.mat");
%%
[bl,al]=sos2tf(lp.SOS,lp.G);
[bb,ab]=sos2tf(bp.SOS,bp.G);

Hl=tf(bl,al,-1);
Hb=tf(bb,ab,-1);

H=Hl+Hb;
[b,a]=tfdata(H,'v');
%%
y=filter(b,a,x);

figure('Name','lp+bp FFT')
plotFFT(y);
% plotFFT(x);
% plotsig(y_hp);
title('FFT expanded lp (lp+bp) filter output y[n].')

%%
function plotFFT(x)
    fs=8*1e3;
    plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
    xlabel('Hz');
    ylabel('amplitude');
    xlim([0 4000]);
    hold on;
end