function [resltMTX, butt, handleMTX, n,m] = holdMode(butt,resltMTX,handleMTX,n,m,f2);

% allows choices to be continued to next png.

Getvars = get(f2,'WindowKeyPressFcn');
butt = Getvars{2};

 if get(butt.hold,'Value') == 1;
%      'it is on'
     set(butt.hold,'BackgroundColor',[0 0 1]);
 elseif get(butt.hold,'Value') == 0
%      'it is off'
      set(butt.hold,'BackgroundColor',[0.941176 0.941176 0.941176]);
 end
     
     