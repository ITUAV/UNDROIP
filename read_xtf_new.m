function read_xtf_new(fname)


fid=fopen("135919_sss_refvraket.xtf",'rb');

chan=[];
sonar=[];

i=0;

tic

while ~feof(fid)
    cefa=fread(fid,1,'*uint16');
    ht=fread(fid,1,'*uint8',61);
    filesize = ftell(fid);
    ht=uint16(ht);
    
    if (cefa+ht==64206)
        i=i+1;
        fseek(fid,filesize-61,'bof');
        
        subchannelnumber=fread(fid,1,'*uint8');
        sonar.subchannelnumber(i)=subchannelnumber;
        numchanstofollow=fread(fid,1,'*uint16');
        sonar.numchanstofollow(i)=numchanstofollow;
        reserved1=fread(fid,2,'*uint16');
        numbytesthisrecord=fread(fid,1,'*uint32');
        sonar.numbytesthisrecord(i)=numbytesthisrecord;
        year=fread(fid,1,'*uint16');
        sonar.year(i)=year;
        month=fread(fid,1,'*uint8');
        sonar.month(i)=month;
        day=fread(fid,1,'*uint8');
        sonar.day(i)=day;
        hour=fread(fid,1,'*uint8');
        sonar.hour(i)=hour;
        minute=fread(fid,1,'*uint8');
        sonar.minute(i)=minute;
        second=fread(fid,1,'*uint8');
        sonar.second(i)=second;
        hseconds=fread(fid,1,'*uint8');
        sonar.hseconds(i)=hseconds;
        julianday=fread(fid,1,'*uint16');
        sonar.julianday(i)=julianday;
        eventnumber=fread(fid,1,'*uint32');
        sonar.eventnumber(i)=eventnumber;
        pingnumber=fread(fid,1,'*uint32');
        sonar.pingnumber(i)=pingnumber;
        soundvelocity=fread(fid,1,'*float');
        sonar.soundvelocity(i)=soundvelocity;
        oceantide=fread(fid,1,'*float');
        sonar.oceantide(i)=oceantide;
        reserved2=fread(fid,1,'*uint32');
        
        conductivityfreq=fread(fid,1,'*float');
        sonar.conductivityfreq(i)=conductivityfreq;
        temperaturefreq=fread(fid,1,'*float');
        sonar.temperaturefreq(i)=temperaturefreq;
        pressurefreq=fread(fid,1,'*float');
        sonar.pressurefreq(i)=pressurefreq;
        pressuretemp=fread(fid,1,'*float');
        sonar.pressuretemp(i)=pressuretemp;
        conductivity=fread(fid,1,'*float');
        sonar.conductivity(i)=conductivity;
        watertemperature=fread(fid,1,'*float');
        sonar.watertemperature(i)=watertemperature;
        pressure=fread(fid,1,'*float');
        sonar.pressure(i)=pressure;
        computedsoundvelocity=fread(fid,1,'*float');
        sonar.computedsoundvelocity(i)=computedsoundvelocity;
        magx=fread(fid,1,'*float');
        sonar.magx(i)=magx;
        magy=fread(fid,1,'*float');
        sonar.magy(i)=magy;
        magz=fread(fid,1,'*float');
        sonar.magz(i)=magz;
        auxval1=fread(fid,1,'*float');
        sonar.auxval1(i)=auxval1;
        auxval2=fread(fid,1,'*float');
        sonar.auxval2(i)=auxval2;
        auxval3=fread(fid,1,'*float');
        sonar.auxval3(i)=auxval3;
        auxval4=fread(fid,1,'*float');
        sonar.auxval4(i)=auxval4;
        auxval5=fread(fid,1,'*float');
        sonar.auxval5(i)=auxval5;
        auxval6=fread(fid,1,'*float');
        sonar.auxval6(i)=auxval6;
        speedlog=fread(fid,1,'*float');
        sonar.speedlog(i)=speedlog;
        turbidity=fread(fid,1,'*float');
        sonar.turbidity(i)=turbidity;
        shipspeed=fread(fid,1,'*float');
        sonar.shipspeed(i)=shipspeed;
        shipgyro=fread(fid,1,'*float');
        sonar.shipgyro(i)=shipgyro;
        shipYcoordinate=fread(fid,1,'double');
        sonar.shipYcoordinate(i)=shipYcoordinate;
        shipXcoordinate=fread(fid,1,'double');
        sonar.shipXcoordinate(i)=shipXcoordinate;
        shipaltitude=fread(fid,1,'*uint16');
        sonar.shipaltitude(i)=shipaltitude;
        shipdepth=fread(fid,1,'*uint16');
        sonar.shipdepth(i)=shipdepth;
        fixtimehour=fread(fid,1,'*uint8');
        sonar.fixtimehour(i)=fixtimehour;
        fixtimeminute=fread(fid,1,'*uint8');
        sonar.fixtimeminute(i)=fixtimeminute;
        fixtimesecond=fread(fid,1,'*uint8');
        sonar.fixtimesecond(i)=fixtimesecond;
        fixtimehsecond=fread(fid,1,'*uint8');
        sonar.fixtimehsecond(i)=fixtimehsecond;
        sensorspeed=fread(fid,1,'*float');
        sonar.sensorspeed(i)=sensorspeed;
        kp=fread(fid,1,'*float');
        
        
        sensorYcoordinate=fread(fid,1,'double');
        sonar.sensorYcoordinate(i)=sensorYcoordinate;
        sensorXcoordinate=fread(fid,1,'double');
        sonar.sensorXcoordinate(i)=sensorXcoordinate;
        
        sonarstatus=fread(fid,1,'*uint16');
        rangetofish=fread(fid,1,'*uint16');
        bearingtofish=fread(fid,1,'*uint16');
        cableout=fread(fid,1,'*uint16');
        layback=fread(fid,1,'*float');
        cabletension=fread(fid,1,'*float');
        sensordepth=fread(fid,1,'*float');
        sensorprimaryaltitude=fread(fid,1,'*float');
        sensorauxaltitude=fread(fid,1,'*float');
        sensorpitch=fread(fid,1,'*float');
        sonar.sensorpitch(i)=sensorpitch;
        sensorroll=fread(fid,1,'*float');
        sonar.sensorroll(i)=sensorroll;
        sensorheading=fread(fid,1,'*float');
        sonar.sensorheading(i)=sensorheading;
        heave=fread(fid,1,'*float');
        sonar.heave(i)=heave;
        yaw=fread(fid,1,'*float');
        sonar.yaw(i)=yaw;
        attitudetimetag=fread(fid,1,'*uint32');
        sonar.attitudetimetag(i)=attitudetimetag;
        dot=fread(fid,1,'*float');
        navfixmilliseconds=fread(fid,1,'*uint32');
        sonar.navfixmilliseconds(i)=navfixmilliseconds;
        computerclockhour=fread(fid,1,'*uint8');
        computerclockminute=fread(fid,1,'*uint8');
        computerclocksecond=fread(fid,1,'*uint8');
        computerclockhsecond=fread(fid,1,'*uint8');
        fishpositiondeltaX=fread(fid,1,'*short');
        fishpositiondeltaY=fread(fid,1,'*short');
        fishpositionerrorcode=fread(fid,1,'*uchar');
        reservedspace2=fread(fid,11,'*uint8');
        
        %read XTFPingChanHeader
        channelnumber=fread(fid,1,'*uint16');
        chan.channelnumber(i)=channelnumber;
        downsamplemethod=fread(fid,1,'*uint16');
        chan.downsamplemethod(i)=downsamplemethod;
        slantrange=fread(fid,1,'*float');
        chan.slantrange(i)=slantrange;
        groundrange=fread(fid,1,'*float');
        chan.groundrange(i)=groundrange;
        timedelay=fread(fid,1,'*float');
        chan.timedelay(i)=timedelay;
        timeduration=fread(fid,1,'*float');
        chan.timeduration(i)=timeduration;
        secondsperping=fread(fid,1,'*float');
        chan.secondsperping(i)=secondsperping;
        procflags=fread(fid,1,'*uint16');
        chan.procflags(i)=procflags;
        frequency=fread(fid,1,'*uint16');
        chan.frequency(i)=frequency;
        initialgaincode=fread(fid,1,'*uint16');
        chan.initialgaincode(i)=initialgaincode;
        gaincode=fread(fid,1,'*uint16');
        chan.gaincode(i)=gaincode;
        bandwidth=fread(fid,1,'*uint16');
        chan.bandwidth(i)=bandwidth;
        contactnumber=fread(fid,1,'*uint32');
        contactclassification=fread(fid,1,'*uint16');
        contactsubnumber=fread(fid,1,'*uint8');
        contacttype=fread(fid,1,'*uint8');
        numsamples=fread(fid,1,'*uint32');
        numsamples=double(numsamples);
        if numsamples >2000 || numsamples < 50
            numsamples=1000;
        end
        chan.numsample(i)=numsamples;
        millivoltscale=fread(fid,1,'*uint16');
        contacttimeofftrack=fread(fid,1,'*float');
        contactclosenumber=fread(fid,1,'*uint8');
        chanreserved2=fread(fid,1,'*uint8');
        fixedvsop=fread(fid,1,'*float');
        weight=fread(fid,1,'short');
        chanreservedspace=fread(fid,4,'*uint8');
        
        sample=fread(fid,[numsamples 1],'*uint16');
        chan.sample(:,i)=sample;
        
        %         samplestarb=fread(fid,[numsamples 1],'*uint16');
        %         chan.samplestarb(:,i)=samplestarb;
        
        filesize=ftell(fid);
        mod_1=mod(filesize,64);
        d_mod=64-mod_1;
        fseek(fid,filesize+d_mod,'bof');
        
    end
    
    
end

%check data loss
[~,c]=find(sonar.numchanstofollow~=2);





end



