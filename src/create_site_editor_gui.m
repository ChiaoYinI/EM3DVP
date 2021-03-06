function create_site_editor_gui(hObject,eventdata,handles)
%====================site editor=====================%
%             add, remove or modify sites            %
%====================================================%
% Known bug : when you cancel adding a edi to a newly
% added site. the cursor callback will not be destoryed and will be there
% forever.
% update:     added a wild function to add sites in arbitary location 
%             with data transfer function interpolated with surrounding sites
global custom sitename xyz
hcsmain=figure;
set(hcsmain,'units','normalized','position',[0.2 0.2 0.6 0.6],'numbertitle','off',...
    'name','Site Editor');
bcolor=get(hcsmain,'color');
haa=axes('units','normalized','position',[0.05 0.1 0.6 0.8],'tag','axisa');

custom.currentsite=1;

%button group 'EDIT'
hbgedit=uibuttongroup(hcsmain,'units','normalized',...
    'position',[0.7 0.68 0.28 0.27],...
    'title','edit',...
    'backgroundcolor',bcolor,...
    'tag','',...
    'fontweight','bold');
hcboxedit=uicontrol(hbgedit,'style','checkbox',...
    'units','normalized',...
    'position',[0.05 0.78 0.5 0.20],...
    'string','enable edit',...
    'tag','enable edit mode', ...
    'backgroundcolor',bcolor,...
    'tooltipstring','enable edit mode');
hadd_site=uicontrol(hbgedit,'style','radiobutton',...
    'units','normalized',...
    'position',[0.05 0.55 0.4 0.20],...
    'string','add site',...
    'tag','add site', ...
    'backgroundcolor',bcolor,...
    'tooltipstring','enable add mode',...
    'enable','off');
hdel_site=uicontrol(hbgedit,'style','radiobutton',...
    'units','normalized',...
    'position',[0.55 0.55 0.4 0.20],...
    'string','delete site',...
    'tag','delete site', ...
    'backgroundcolor',bcolor,...
    'tooltipstring','enable del mode',...
    'enable','off');
hmove_site=uicontrol(hbgedit,'style','radiobutton',...
    'units','normalized',...
    'position',[0.05 0.3 0.4 0.20],...
    'string','move site',...
    'tag','move site', ...
    'backgroundcolor',bcolor,...
    'tooltipstring','enable move mode',...
    'enable','off');
hrotate_sites=uicontrol(hbgedit,'style','pushbutton',...
    'units','normalized',...
    'position',[0.55 0.05 0.35 0.20],...
    'string','rotate sites',...
    'backgroundcolor',bcolor,...
    'enable','off');
hshift_sites=uicontrol(hbgedit,'style','pushbutton',...
    'units','normalized',...
    'position',[0.05 0.05 0.35 0.20],...
    'string','shift sites',...
    'backgroundcolor',bcolor,...
    'enable','off');

%button group 'import'
hbgimport=uibuttongroup(hcsmain,'units','normalized','position',...
    [0.7 0.1 0.28 0.27],'title','import data','backgroundcolor',bcolor,...
    'tag','','fontweight','bold');
hcboxnoise=uicontrol(hbgimport,'style','checkbox','units','normalized','position',...
    [0.05 0.80 0.65 0.20],'string','Add Noise to synthetic data','tag',...
    'enable adding noise','backgroundcolor',bcolor,'tooltipstring',...
    'enable adding noise');
hnoise_level=uicontrol(hbgimport,'style','edit','units','normalized','position',...
    [0.77 0.82 0.1 0.15],'string','5','tag','noise level', ...
    'backgroundcolor',bcolor);
hnoise_text=uicontrol(hbgimport,'style','text','units','normalized','position',...
    [0.87 0.79 0.1 0.15],'string','%','tag','%', ...
    'backgroundcolor',bcolor);

hcboxefloor=uicontrol(hbgimport,'style','checkbox','units','normalized','position',...
    [0.05 0.60 0.65 0.20],'string','fix error for synthetic data','value',...
    1,'backgroundcolor',bcolor,'tooltipstring',...
    'set var for synthetic data');
hefloor_level=uicontrol(hbgimport,'style','edit','units','normalized','position',...
    [0.77 0.62 0.1 0.15],'string','5','tag','efloor level', ...
    'backgroundcolor',bcolor);
hefloor_text=uicontrol(hbgimport,'style','text','units','normalized','position',...
    [0.87 0.59 0.1 0.15],'string','%','tag','%', ...
    'backgroundcolor',bcolor);
hpbloadws=uicontrol(hbgimport,'style','pushbutton','units','normalized','position',...
    [0.05 0.05 0.35 0.18],'string','WS data','tag','load WS data');
hpbloadmodem=uicontrol(hbgimport,'style','pushbutton','units','normalized','position',...
    [0.55 0.05 0.35 0.18],'string','ModEM data','tag','load ModEM data');
hpbloadxyz=uicontrol(hbgimport,'style','pushbutton','units','normalized','position',...
    [0.55 0.26 0.35 0.18],'string','XYZ location','tag','load XYZ location');
hpbloadlatlon=uicontrol(hbgimport,'style','pushbutton','units','normalized','position',...
    [0.05 0.26 0.35 0.18],'string','Lat/lon loc','tag','load Lat/lon location');
%button group 'Site Property'
hbgsite_prop=uibuttongroup(hcsmain,'units','normalized','position',...
    [0.7 0.40 0.28 0.25],'title','Site Property','backgroundcolor',bcolor,...
    'tag','','fontweight','bold');
hnametext=uicontrol(hbgsite_prop,'style','text','units','normalized','position',...
    [0.05 0.68 0.25 0.18],'string','site name','tag','name', ...
    'backgroundcolor',bcolor);
hxtext=uicontrol(hbgsite_prop,'style','text','units','normalized','position',...
    [0.55 0.68 0.25 0.18],'string','x (N-S)','tag','name', ...
    'backgroundcolor',bcolor);
hytext=uicontrol(hbgsite_prop,'style','text','units','normalized','position',...
    [0.05 0.25 0.25 0.18],'string','y (E-W)','tag','name', ...
    'backgroundcolor',bcolor);
hztext=uicontrol(hbgsite_prop,'style','text','units','normalized','position',...
    [0.55 0.25 0.25 0.18],'string','z (ELEV)','tag','name', ...
    'backgroundcolor',bcolor);
hsite_name=uicontrol(hbgsite_prop,'style','edit','units','normalized','position',...
    [0.05 0.55 0.4 0.2],'string','0','tag','name', ...
    'backgroundcolor',bcolor,'tooltipstring','site name');
hsite_x=uicontrol(hbgsite_prop,'style','edit','units','normalized','position',...
    [0.55 0.55 0.4 0.2],'string','0','tag','x loc', ...
    'backgroundcolor',bcolor,'tooltipstring','x location');
hsite_y=uicontrol(hbgsite_prop,'style','edit','units','normalized','position',...
    [0.05 0.1 0.4 0.2],'string','0','tag','y loc', ...
    'backgroundcolor',bcolor,'tooltipstring','y location');
hsite_z=uicontrol(hbgsite_prop,'style','edit','units','normalized','position',...
    [0.55 0.1 0.4 0.2],'string','0','tag','z loc', ...
    'backgroundcolor',bcolor,'tooltipstring','z location');
% other buttons
hpbcentre_site=uicontrol(hcsmain,'style','pushbutton','units','normalized','position',...
    [0.69 0.03 0.08 0.05],'string','centre site','tag','centre site','enable','off');

hpbquit=uicontrol(hcsmain,'style','pushbutton','units','normalized','position',...
    [0.89 0.03 0.08 0.05],'string','DONE','tag','exit');
htext=uicontrol(hcsmain,'style','text','units','normalized','position',...
    [0.20 0.9 0.25 0.03],'string','current site: ',...
    'backgroundcolor',bcolor);

% put all handles into a structure
handle.figure=hcsmain;
handle.axis=haa;
handle.buttons=[hpbcentre_site,hpbloadws,hpbloadmodem,hpbloadxyz,hpbloadlatlon,hpbquit];
handle.propertybox=[hsite_name,hsite_x,hsite_y,hsite_z];
handle.noisebox=[hcboxnoise,hnoise_level,hcboxefloor,hefloor_level];
handle.editbox=[hadd_site,hdel_site,hmove_site,hrotate_sites,hshift_sites];
handle.parent=handles;
handle.text=[htext,hnametext,hxtext,hytext,hztext,hnoise_text,hefloor_text];
handle.init= uisuspend(gcf);
handle.check=hcboxedit;


% set ui callbacks
set(hpbquit,'callback',{@quit_seditor,handle});
set(hpbloadws,'callback',{@import_WSdata,handle});
set(hpbloadmodem,'callback',{@import_ModEMdata,handle});
set(hpbloadxyz,'callback',{@import_xyz,handle});
set(hpbloadlatlon,'callback',{@import_xyz2,handle});
set(hcboxedit,'callback',{@enable_edit_site,handle});
set(hadd_site,'callback',{@add_site,handle,'axy'});
set(hdel_site,'callback',{@del_site,handle,'axy'});
set(hmove_site,'callback',{@move_site,handle,'axy'});
set(hrotate_sites,'callback',{@rotate_sites,handle});
set(hshift_sites,'callback',{@shift_sites,handle});
set(hpbcentre_site,'callback',{@centre_site,handle});
set(hsite_name,'callback',@set_site);
set(hsite_x,'callback',@set_site);
set(hsite_y,'callback',@set_site);
set(hsite_z,'callback',@set_site);

% initializing...
set(handle.editbox(3),'value',1)
if ~isempty(sitename)&&~isempty(xyz)
    plot_site(hObject,eventdata,handle,'noname');
    csite=['current site: ' char(sitename{custom.currentsite})];
    set(htext,'string',csite);
    set(handle.buttons(1),'enable','on')
end
return


