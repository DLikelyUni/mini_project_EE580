%EE580 mini project filter design
fs=8*1e3;
fc1=fs/6;
fc2=fs/3;
x=wgn(10000,1,0);
%% low pass
[b_lp,a_lp]=sos2tf(SOS_lp,G_lp);
%%
zpad=zeros(1,19);
a_lp=[a_lp zpad];
b_lp=[b_lp zpad];
y_lp=filter(b_lp,a_lp,x);

figure(1);
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
xlabel('Hz');
xlim([0 4000]);

figure(2);
plot(fs*(0:(1/length(y_lp)):(length(y_lp)-1)/length(y_lp)),abs(fft(y_lp)));
xlabel('Hz');
xlim([0 4000]);
%%
%% high pass
[b_bp,a_bp]=sos2tf(SOS_bp,G_bp);
%%
a_bp=[a_bp 0];
b_bp=[b_bp 0];
%%
y_bp=filter(b_bp,a_bp,x);

figure(3);
plot(fs*(0:(1/length(x)):(length(x)-1)/length(x)),abs(fft(x)));
xlabel('Hz');
xlim([0 4000]);

figure(4);
plot(fs*(0:(1/length(y_bp)):(length(y_bp)-1)/length(y_bp)),abs(fft(y_bp)));
xlabel('Hz');
xlim([0 4000]);

%% high pass
[b_hp,a_hp]=sos2tf(SOS_hp,G_hp);
% zpad=zeros(1,19);
% a_hp=[a_hp zpad];
% b_hp=[b_hp zpad];
y_hp=filter(b_hp,a_hp,x);

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