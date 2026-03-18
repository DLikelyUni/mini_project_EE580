function filt=mp_makefilters() %mini project make filters
    fs=8*1e3;
    fc1=fs/6;
    fc2=fs/3;
   
    % Low pass config 4
    fp_shift=fs/300; 
    fpasslp=fc1-fp_shift;
    fstoplp=fs/5;
    B=fstoplp-fpasslp;
    Astop=60;
    Apass=0.1;
    % d = designfilt('lowpassiir', ...
    %     'PassbandFrequency', fpasslp, 'StopbandFrequency', fstoplp, ...
    %     'PassbandRipple', Apass, 'StopbandAttenuation', Astop, ...
    %     'DesignMethod', 'ellip');
    
    [n, wn] = ellipord(fpasslp/(fs/2), fstoplp/(fs/2), Apass, Astop);
    [blp, alp] = ellip(n, Apass, Astop, wn);
    %
    % band pass config 4
    fpassbp1 = fc1+fp_shift;
    fstopbp1 = fpassbp1-B;
    fpassbp2 = fc2-fp_shift;
    fstopbp2 = fpassbp2+B;
    % Bbp1=fpassbp1-fstopbp1;
    % Bbp2 = fstopbp2-fpassbp2;
    % 
    wp = [fpassbp1 fpassbp2]/(fs/2);  % Passband (normalized)
    ws = [fstopbp1 fstopbp2]/(fs/2);   % Stopband (normalized)
    
    [n, wn] = ellipord(wp, ws, Apass, Astop);
    [bbp, abp] = ellip(n, Apass, Astop, wn,'bandpass');
     
    %% High pass config 4
    fpasshp = fc2 + fp_shift;
    fstophp = fpasshp-B;
    % Bhp = fpasshp-fstophp;
    [n, wn] = ellipord(fpasshp/(fs/2), fstophp/(fs/2), Apass, Astop);
    [bhp, ahp] = ellip(n, Apass, Astop, wn,'high');
    

    config.fpasslp = fpasslp;
    config.fstoplp = fstoplp;
    config.fpasshp = fpasshp;
    config.fstophp = fstophp;
    config.fpassbp1 = fpassbp1;
    config.fstopbp1 = fstopbp1;
    config.fpassbp2 = fpassbp2;
    config.fstopbp2 = fstopbp2;

    filt.config=config;
    lowpass.b=single(blp);
    lowpass.a= single(alp);
    bandpass.b = single(bbp);
    bandpass.a = single(abp);
    highpass.b = single(bhp);
    highpass.a = single(ahp);

    filt.lowpass = lowpass;
    filt.bandpass = bandpass;
    filt.highpass = highpass;
end