function AnisPara=anisdlg(Nz,currentz)
% a simple dialog for inputing the top, bottom and resistivity of the
% Block
parastr={'top layer of the anisotropic body:',...
    'bottom layer of the anisotropic body:',...
    'high resistivity of the anisotropic body(ohm m):',...
    'low resisitivity of the anisotropic body(ohm m):',...
    'anisotropic axis direction (north/up is zero):'};
while(1)
    AnisPara=inputdlg(parastr,'Block Parameter',1,{num2str(currentz),...
        num2str(currentz),'1000','10','0'});
    AnisPara = str2num(char(AnisPara));
    if AnisPara(1)>AnisPara(2)
         msgbox('The first layer number should be no larger than the bottom layer number'...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif AnisPara(1)<1||AnisPara(2)>Nz
         msgbox(['The Layer numbers should be positive between 1 and ',num2str(Nz)]...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif AnisPara(3)<=0||AnisPara(4)<=0;
         msgbox('The Resistivity value should be positive '...
             ,'Block Parameter');
         beep;
         uiwait;
    elseif AnisPara(3)<=AnisPara(4);
         msgbox('The High Resitivity should be larger than low... Got it?'...
             ,'Block Parameter');
         beep;
         uiwait;
    else
         AnisPara(1)=round(AnisPara(1));
         AnisPara(2)=round(AnisPara(2));
         break;
    end
end
return

