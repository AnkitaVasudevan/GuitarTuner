clearvars;

x=1;

ghighE=1318.1505;    
gB=987.7669;
gG=783.9911;    
gD=587.3297;    
gA=440;
glowE=329.6277;

guitar=[ghighE,gB,gG,gD,gA,glowE];

while x==1
    
    x=isempty (input ('Press enter to start program or press zero to quit. '));
    
    
    if x==1
    
        guitar_string = input ('Which string are you adjusting?\n1=e\n2=B\n3=G\n4=D\n5=A\n6=E\n');
        required_freq = guitar(guitar_string);
        
         y = isempty(input('Press enter to record input signal or 0 to start over. '));
        
        while y==1          

            Fs=44100;

            RecordObject = audiorecorder(Fs,16,1,-1);  %#ok<*TNMLP>
            record(RecordObject,2);
            pause(3);

            input = getaudiodata(RecordObject,'double');

            disp('This is how the input signal sounds. '); 
            sound (input,Fs);

            inputFFT = fft(input)/size(input,1);
            K=0:1:(Fs/2-1);
            
            if guitar_string==6                
                for i=400:size(inputFFT,1) 
                    inputFFT(i,1)=0;       
                end               
            else                
                for i=1500:size(inputFFT,1)                    
                    inputFFT(i,1)=0;                   
                end      
            end
            
            
            subplot(2,1,1);plot(input);
            subplot(2,1,2);plot(K,2*real(inputFFT(1:Fs/2)));
            
            if guitar_string==6                
                axis([ 200 500 -0.01 0.01])
                for i=400:size(inputFFT,1)                    
                    inputFFT(i,1)=0;                    
                end
                
            elseif guitar_string==5                
                axis([ 400 550 -0.01 0.01])                
                for i=550:size(inputFFT,1)
                    inputFFT(i,1)=0;                    
                end
                
            elseif guitar_string==4              
                axis([ 450 700 -0.01 0.01])
                for i=700:size(inputFFT,1)                    
                    inputFFT(i,1)=0;
                end
                
            elseif guitar_string==3                
                axis([ 650 850 -0.01 0.01])               
                for i=900:size(inputFFT,1)
                    inputFFT(i,1)=0;
                end
                
            elseif guitar_string==2                
                axis([ 800 1100 -0.01 0.01])                
                for i=1200:size(inputFFT,1)                    
                    inputFFT(i,1)=0;                    
                end
                
            elseif guitar_string==1                
                axis([ 1200 1400 -0.01 0.01])                
                for i=1500:size(inputFFT,1)
                    inputFFT(i,1)=0;
                end   
            end
      
        
        current_freq = K(find(inputFFT == max(inputFFT)));
        z=((current_freq-required_freq)/required_freq)*100;
        
        fprintf('Required Frequency is %d Hz.\n', required_freq);
        
        if (1.0015*required_freq) > current_freq && (0.9985*required_freq) < current_freq                 
                fprintf('You are in tune.\nThe frequency of the input signal is %d Hz.\n', current_freq);
                fprintf('Percent Error %d%% \n',z)
                
        elseif required_freq > current_freq                
                fprintf('Input frequency should be increased.\nThe frequency of the input signal is %d Hz.\n', current_freq);
                fprintf('Percent Error %d%% \n',z)
                
        elseif required_freq < current_freq              
                fprintf('Input frequency should be decreased.\nThe frequency of the input signal is %d Hz.\n', current_freq);
                fprintf('Percent Error %d%% \n',z)                
        end
        
        y = isempty(input('Press enter if you want to rerecord the same string or any number to start over.\n'));
            
            if y==1               
                continue;
            else 
                x=1;
            end
        end
        
    end
end
