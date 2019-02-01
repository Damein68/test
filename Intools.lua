script_name('Inst Tools')
script_version('2.4')
script_author('Damien_Requeste')
local sf = require 'sampfuncs'
local key = require "vkeys"
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
local imgui = require 'imgui' -- ��������� ����������
local encoding = require 'encoding' -- ��������� ����������
local wm = require 'lib.windows.message'
local gk = require 'game.keys'
local second_window = imgui.ImBool(false)
local third_window = imgui.ImBool(false)
local first_window = imgui.ImBool(false)
local bMainWindow = imgui.ImBool(false)
local sInputEdit = imgui.ImBuffer(128)
local bIsEnterEdit = imgui.ImBool(false)
local ystwindow = imgui.ImBool(false)
local tEditData = {
	id = -1,
	inputActive = false
}
encoding.default = 'CP1251' -- ��������� ��������� �� ���������, ��� ������ ��������� � ���������� �����. CP1251 - ��� Windows-1251
u8 = encoding.UTF8
require 'lib.sampfuncs'
seshsps = 1
ctag = "ITools {ffffff}|"
players1 = {'{ffffff}���\t{ffffff}����'}
players2 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
frak = nil
rang = nil
rabden = false
tload = false
tLastKeys = {}
function apply_custom_style()
  imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

style.Alpha = 1.0
style.ChildWindowRounding = 3
style.WindowRounding = 3
style.GrabRounding = 1
style.GrabMinSize = 20
style.FrameRounding = 3

colors[clr.Text] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.TextDisabled] = ImVec4(0.00, 0.40, 0.41, 1.00)
colors[clr.WindowBg] = ImVec4(0.00, 0.00, 0.00, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.Border] = ImVec4(0.00, 1.00, 1.00, 0.65)
colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg] = ImVec4(0.44, 0.80, 0.80, 0.18)
colors[clr.FrameBgHovered] = ImVec4(0.44, 0.80, 0.80, 0.27)
colors[clr.FrameBgActive] = ImVec4(0.44, 0.81, 0.86, 0.66)
colors[clr.TitleBg] = ImVec4(0.14, 0.18, 0.21, 0.73)
colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.54)
colors[clr.TitleBgActive] = ImVec4(0.00, 1.00, 1.00, 0.27)
colors[clr.MenuBarBg] = ImVec4(0.00, 0.00, 0.00, 0.20)
colors[clr.ScrollbarBg] = ImVec4(0.22, 0.29, 0.30, 0.71)
colors[clr.ScrollbarGrab] = ImVec4(0.00, 1.00, 1.00, 0.44)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 1.00, 1.00, 0.74)
colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.ComboBg] = ImVec4(0.16, 0.24, 0.22, 0.60)
colors[clr.CheckMark] = ImVec4(0.00, 1.00, 1.00, 0.68)
colors[clr.SliderGrab] = ImVec4(0.00, 1.00, 1.00, 0.36)
colors[clr.SliderGrabActive] = ImVec4(0.00, 1.00, 1.00, 0.76)
colors[clr.Button] = ImVec4(0.00, 0.65, 0.65, 0.46)
colors[clr.ButtonHovered] = ImVec4(0.01, 1.00, 1.00, 0.43)
colors[clr.ButtonActive] = ImVec4(0.00, 1.00, 1.00, 0.62)
colors[clr.Header] = ImVec4(0.00, 1.00, 1.00, 0.33)
colors[clr.HeaderHovered] = ImVec4(0.00, 1.00, 1.00, 0.42)
colors[clr.HeaderActive] = ImVec4(0.00, 1.00, 1.00, 0.54)
colors[clr.ResizeGrip] = ImVec4(0.00, 1.00, 1.00, 0.54)
colors[clr.ResizeGripHovered] = ImVec4(0.00, 1.00, 1.00, 0.74)
colors[clr.ResizeGripActive] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.CloseButton] = ImVec4(0.00, 0.78, 0.78, 0.35)
colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.78, 0.78, 0.47)
colors[clr.CloseButtonActive] = ImVec4(0.00, 0.78, 0.78, 1.00)
colors[clr.PlotLines] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.PlotLinesHovered] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.PlotHistogram] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.PlotHistogramHovered] = ImVec4(0.00, 1.00, 1.00, 1.00)
colors[clr.TextSelectedBg] = ImVec4(0.00, 1.00, 1.00, 0.22)
colors[clr.ModalWindowDarkening] = ImVec4(0.04, 0.10, 0.09, 0.51)
end
apply_custom_style()

local fileb = getWorkingDirectory() .. "\\config\\instools.bind"
local tBindList = {}
if doesFileExist(fileb) then
	local f = io.open(fileb, "r")
	if f then
		tBindList = decodeJson(f:read())
		f:close()
	end
else
	tBindList = {
        [1] = {
            text = "/time",
            v = {key.VK_3}
        }
	}
end

local instools =
{
  main =
  {
    posX = 1738,
    posY = 974,
    widehud = 320,
    male = true,
    wanted == false,
    clear == false,
    hud = false,
    tar = '������',
	tarr = '���',
	tarb = false,
	clistb = false,
	clisto = false,
	givra = false,
    clist = 0
  },
  commands = 
  {
    ticket = false,
	zaderjka = 5000
  },
   keys =
  {
	tload = 97,
	tazer = 97,
	fastmenu = 113
  }
}
cfg = inicfg.load(nil, 'instools/config.ini')

local libs = {'sphere.lua', 'rkeys.lua', 'imcustom/hotkey.lua', 'imgui.lua', 'MoonImGui.dll', 'imgui_addons.lua'}
function main()
  while not isSampAvailable() do wait(1000) end
  if seshsps == 1 then
    ftext("������ ������� ��������. /thelp - ������ �� ��������, /tset - ��������� �������.", -1)
	ftext('������� ������� ������� �������� Damien_Requeste')
  end
  if not doesDirectoryExist('moonloader/config/instools/') then createDirectory('moonloader/config/instools/') end
  if cfg == nil then
    sampAddChatMessage("{47f4f0}IT {ffffff}| ���������� ���� �������, �������.", -1)
    if inicfg.save(instools, 'instools/config.ini') then
      sampAddChatMessage("{47f4f0}IT {ffffff}| ���� ������� ������� ������.", -1)
      cfg = inicfg.load(nil, 'instools/config.ini')
    end
  end
  if not doesDirectoryExist('moonloader/lib/imcustom') then createDirectory('moonloader/lib/imcustom') end
  for k, v in pairs(libs) do
        if not doesFileExist('moonloader/lib/'..v) then
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/'..v, getWorkingDirectory()..'\\lib\\'..v)
            print('����������� ���������� '..v)
        end
    end
  while not doesFileExist('moonloader\\lib\\rkeys.lua') or not doesFileExist('moonloader\\lib\\imcustom\\hotkey.lua') or not doesFileExist('moonloader\\lib\\imgui.lua') or not doesFileExist('moonloader\\lib\\MoonImGui.dll') or not doesFileExist('moonloader\\lib\\imgui_addons.lua') do wait(0) end
  if not doesDirectoryExist('moonloader/instools') then createDirectory('moonloader/instools') end
  hk = require 'lib.imcustom.hotkey'
  rkeys = require 'rkeys'
  imgui.ToggleButton = require('imgui_addons').ToggleButton
  while not sampIsLocalPlayerSpawned() do wait(0) end
  local _, myid = sampGetPlayerIdByCharHandle(playerPed)
  local name, surname = string.match(sampGetPlayerNickname(myid), '(.+)_(.+)')
  sip, sport = sampGetCurrentServerAddress()
  sampSendChat('/stats')
  while not sampIsDialogActive() do wait(0) end
  proverkk = sampGetDialogText()
  local frakc = proverkk:match('.+�����������%:%s+(.+)%s+����')
  local rang = proverkk:match('.+����%:%s+(.+)%s+������')
  rank = rang
  frac = frakc
  sampCloseCurrentDialogWithButton(1)
  print(frakc)
  print(rang)
  ystf()
  local spawned = sampIsLocalPlayerSpawned()
  for k, v in pairs(tBindList) do
		rkeys.registerHotKey(v.v, true, onHotKey)
  end
  sampRegisterChatCommand('r', r)
  sampRegisterChatCommand('thelp', thelp)
  sampRegisterChatCommand('dmb', dmb)
  sampRegisterChatCommand('tset', tset)
  sampRegisterChatCommand('vig', vig)
  sampRegisterChatCommand('giverank', giverank)
  sampRegisterChatCommand('invite', invite)
  sampRegisterChatCommand('uninvite', uninvite)
  sampRegisterChatCommand('yst', function() ystwindow.v = not ystwindow.v end)
  while true do wait(0)
    if cfg == nil then
      sampAddChatMessage("{47f4f0}IT {ffffff}| ���������� ���� �������, �������.", -1)
      if inicfg.save(instools, 'instools/config.ini') then
        sampAddChatMessage("{47f4f0}IT {ffffff}| ���� ������� ������� ������.", -1)
        cfg = inicfg.load(nil, 'instools/config.ini')
      end
    end
	    local myhp = getCharHealth(PLAYER_PED)
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if wasKeyPressed(cfg.keys.fastmenu) and not sampIsDialogActive() and not sampIsChatInputActive() then
    submenus_show(fastmenu(id), "{47f4f0}IT {ffffff}| ������� ����")
    end
          if valid and doesCharExist(ped) then
            local result, id = sampGetPlayerIdByCharHandle(ped)
            if result and wasKeyPressed(key.VK_Z) then
                gmegafhandle = ped
                gmegafid = id
                gmegaflvl = sampGetPlayerScore(id)
                gmegaffrak = getFraktionBySkin(id)
                --[[ftext(gmegafid)
                ftext(gmegaflvl)
                ftext(gmegaffrak)]]
				megaftimer = os.time() + 300
                submenus_show(pkmmenu(id), "{47f4f0}Inst Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ������� - "..sampGetPlayerScore(id).." ")
            end
        end
		imgui.Process = second_window.v or third_window.v or bMainWindow.v or ystwindow.v
  end
  function rkeys.onHotKey(id, keys)
	if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
		return false
	end
end
end

local fpt = [[
����� ��������� ���������:

� 1.1 ����� ��������� ������������� ���������, ������� ������ ��������� ��� ���������� ���������.
� 1.2 ���������� ��������� ������� ����������� ������� �� ���������.
� 1.3 ���������� ��������� ������� ����������� ����������� ����� ��������.
� 1.4 ���������� ��������� ����� �������� �� ������ ���. �������� ��� ������� ��������.
� 1.5 �������� ������ �� ����������� ��� �� ���������������.
� 1.6 ��������� ����� ��������� � ��������� ��� ���������� �� ����������� ��������� � ����� ����� ( � ����� ����, � ��� ����� /f, /fb, /b, /sms ).
� 1.7 ����� ����� ���� ������� � ����� ����� ����������� ���������.


[2] ����������� ����������� ���������:

� 2.1 ��������� ��������� ������ ��������� ����� ���������. 
� 2.2 ��������� ��������� ������ ����� � ��������� ��� ������� � ������ �����. 
� 2.3 ��������� ��������� ������ ������� �� ���������� ����������� ��� ������������ ��������.
� 2.4 ��������� ��������� ������ �������� ������ ��������� ��������� � �������� ������� ���.
� 2.5 ���������� ������� ������ �������� �������� �������������� � ���� ��� ����� ������.
� 2.5.1 ���������� �������� ������� ������� ������ ������� - � 15. 
� 2.5.2 C��������� ��� ������ ������� ������ ������� - � 4. 
� 2.5.3 ����� ������ ����� ������� �12.
� 2.5.4 ����������� ����� ������ ���������� ����� ������� �25.
� 2.5.5 ��������� ������ ��������� ������ ������ ������� �21.
� 2.5.6 ��������� ������ ���������� ������ ������ ������� �30.
� 2.5.7 ��������� ������� ���������� ������������� �� ������ ������ ������ ������� � 19.
� 2.5.8 ���������� ����������� �� ���������� ������� ������ ������� ������� - � 23.
� 2.5.9 ������� ��������� ����� ������ ����� �������.
� 2.6 ��������� ��������� ������ ����������� ������� �� ���������.
� 2.7 � ������� ����� ��������� ������ ������ �������� �������� � �����.
� 2.8 ��������� ��������� ������ ������� ����� ����� ��������� �� ��������� "�����������". (���������� ��� ������ �� ����� ����������).
� 2.9 ��������� ��������� ������ ����������� ����������� ����� ��������.
� 2.10 ��������� ��������� ������ ����� ������ � ������� ������ � ����� ���������. (����������: �������� ������� ��������� ����� � ������� ������ � ����� ��������� � �� �������� � ������ �����������)
� 2.11 ��������� ���������, ����������� � ��������� ��.��������� � ����, ������ ��������� ������ ������ ���� �� 00:00.
� 2.12 ��������� ���������, ����������� � ��������� ��.��������� � ����, ������ ����������� �� ����� � ������ ����������/���������/���������. 
� 2.13 ������ ��������� ����� ����� (������) � ������� ������ ������ ��������� �� ����� �����.


[3] ������� ���� � ���������:

� 3.1 � �����, ������� ���� ������ � 09:00 �� 21:00. � �������� ��� ������� ���� ������ � 09:00 �� 20:00.
� 3.2 ����� ��� �������� (�����) � 13:00 �� 14:00.
� 3.3 � ������� ����� ��������� ������ ����� ����������. (����������: ����, ����, ��� � ��������)
� 3.4 ��������� �������� ���� � ������� ����� ��� ���������� ��.�������.
� 3.5 ����� �������� �� ������, ���������� �� ����� ���������� � 15 �����.
� 3.6 ������ ���������, ������������ �� ������ �� ����� ��������, ������ ��������� ���� ��������, �������� �� ���� ����������� ���������.(�� ����� ��� �� 10 �����)
� 3.7 �� ������� ��������� ����� �������� �� ������ ����� ����� ����� �������� ���.
� 3.8 ��������� ���������� �� ������������� ������� � ������� �����.


[4] ����������� ��������� �����������:

� 4.1 �������� ������� ����� ��� ���������� �������.
� 4.2 �������� ������� ��������� ����� ��� ������� ������.
� 4.3 ������ ������ �� �� ����� ���������.
� 4.4 ����� �������� ��� ����������.
� 4.5 ������ ��������.
� 4.6 �������� ���� � ����� ��������.
� 4.7 ���������� � ������ � ������� �����.
� 4.8 ������ ����� ����������, �� ����������� ����� � ����� � �������.
� 4.9 ����� ����� ������ ����� (600 ������) ������ ��� �� ����� �������� ���. ����������: ������ � ������ �����, ������ � ��. �������� (�����) ��� ���������� ������������.
� 4.10 �������� ��������� � ��������� ��� ���������� �� ����������� ��������� � ����� ����� ( � ����� ����, � ��� ����� /f, /fb, /b, /sms ).
� 4.11 ������������ ���������, ������������� ���������, � ������ �����.
� 4.12 �������� �� ����� ��������������� ������, �� ������ ������� �����.
� 4.13 �������� ������������� ������� � ������� �����.
� 4.14 ����������� ������������ ���������� � ��������
� 4.15 ��������� ������������ ����� � ������� ������ � ��������������� ����������.


[5] �������� � ����������� ������� ���������:

� 5.1 � ������� ������ ��������� ������ ���������� � ��������� �������� ���������.
� 5.2 ���������� �������� ������� ��� ��������� �� ����� ���� � �����.
� 5.3 �������� � ���� � ����� ����������� ����� ������ � ��������� "�����������".
� 5.4 ������ ������ ����� ���� ��������� � ��������� ����������� � ����.
� 5.5 ������������ ����� ������ ����� ���� ��������� � ��������� ��. ����������� � ����.


[6] ��������� �� ��������� ������:

� 6.1 �� ��������� ������, ��������� ����� �������� ��������� �� ���������� �������� ������� ���������.

���������������� �����:

���������������� ����� - ��������� ������������ ����, ��� ������ ������� ������������ ����������� ��������������� �������� ������������ ��������� � �������������� ������ ��� (������������ �������� � ����� ������ ����������� ���������� ��������). 
�� ������� ������������ ������� ����, ������, � ������������������ ����� ���� ������� ������ ����, � ���� ��������� �����, ������� ��� �� �������� �� ����� ���� ����������� ��������� ���������� �����, �����, ��� � ��� ������� ������.

����� ������� ����� ������� �����, ��� ���������������� ����� ����������� ��������� ������������ ���������� ������������ ����������� �� ��� ���������. � ����������� � ��� ����� ������ ��� ����������� �� ���������. 
��� �� �� ������? ��������� ������ ������ ���� �� ����� ������� ������ ����� ��-�� ����, ��� �������� ����� �� ������ �����������, ������ ������� ��������� ����� ������ � ���������� ��� ������ �����, ��� ��� ����������� � ������� ��, � ������ ���������� ��������� ������ ���� ����������� �����������, ��� � ��������� � �������, ��� � �� ���������� ���������������� ����������.

� ������������ �������� � ��������� ����� ����������� ���� ��� �� ��������� ��������, � ����������� �������� - �������� ������������. 
� ������� ��������� "���������� �����", ��� ������� ��������� ��� �� ����� � �������� ����� � ����� ������� ����� ��������� ������������, �����������, ��������������� �������, � ����� ��������� ��������� ���� ���������� ���� ��������� ���� �������. 
� �� ����� ����������� ����� ���������� ����� �����, ���� �� ��� "��� � ���� �������" - ���������� ���� � ���-�� �������, � ���� � ��� ���� ��������� ������� �� � /sms ���. 
� ��� ��������� ������������. 
� ������� � ��������� ���������� � �������� ������ ��� �� ���������, ���� ��� ������� ��� �� � ���-�� �� ����, �� ������ ������ � ��. 
� �� ����������� ������ ���������� ������� ����������� ���������� � �� ��������, ������� ����� �������� ��������� ���������� � ���� ( �������� ���� ����� �������� ������ ����, ����������� ������ � ��, ����� �� ����� ����� ���������� ��� ������, ����� �������������).

�� ��������� ���� ������ � IC �� ������ ������� � �������� "��������� ����. �����". 
�� ��������� ���� ������ � ��� �� ������ ������� � �������� "���������� ���������", �������� �� ������� ��� ���� �� ��������� ����� ���������� ��������.
]]

function dmb()
	lua_thread.create(function()
		status = true
		sampSendChat('/members')
		while not gotovo do wait(0) end
		if gosmb then
			sampShowDialog(716, "{ffffff}� ����: "..gcount.." | {ae433d}����������� | {ffffff}Time: "..os.date("%H:%M:%S"), table.concat(players2, "\n"), "x", _, 5) -- ���������� ����������.
		elseif krimemb then
			sampShowDialog(716, "{ffffff}� ����: "..gcount.." | {ae433d}����������� | {ffffff}Time: "..os.date("%H:%M:%S"), table.concat(players1, "\n"), "x", _, 5) -- ���������� ����������.
		end
		gosmb = false
		krimemb = false
		gotovo = false
		status = false
		players2 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
		players1 = {'{ffffff}���\t{ffffff}����'}
		gcount = nil
	end)
end

function vig(pam)
  local id, pric = string.match(pam, '(%d+)%s+(.+)')
  if rank == '��.��������' or rank == '��.��������' or rank == '��������' or  rank == '�����������' then
  if id == nil then
    sampAddChatMessage("{47f4f0}Inst Tools {ffffff}| �������: /vig ID �������", -1)
  end
  if id ~=nil and not sampIsPlayerConnected(id) then
    sampAddChatMessage("{47f4f0}Inst Tools {ffffff}| ����� � ID: "..id.." �� ��������� � �������.", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
      if pric == nil then
        sampAddChatMessage("{47f4f0}Inst Tools {ffffff}| �������: /vig ID �������", -1)
      end
      if pric ~= nil then
	   if cfg.main.tarb then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/r [%s]: %s - �������� ������� �� �������: %s.", cfg.main.tarr, rpname, pric))
		else 
		name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
		sampSendChat(string.format("/r %s - �������� ������� �� �������: %s.", rpname, pric))
      end
  end
end
end
end

function getrang(rangg)
local ranks = 
        {
		['1'] = '������',
		['2'] = '�����������',
		['3'] = '�����������',
		['4'] = '��.����������',
		['5'] = '����������',
		['6'] = '�����������',
		['7'] = '��.��������',
		['8'] = '��.��������',
		['9'] = '��������'
		}
	return ranks[rangg]
end

function giverank(pam)
    lua_thread.create(function()
        local id, oldrank, rangg = pam:match('(%d+) (%d+) (%d+)')
	if cfg.main.givra then
	  if rank == '��.��������' or rank == '��.��������' or rank == '��������' or  rank == '�����������' then
        if id and oldrank and rangg then
		ranks = getrang(rangg)
				sampSendChat('/me ����(�) ������ ������� � �������� �� ������ ��������')
				wait(1500)
				sampSendChat('/me �����(�) ������ ������� � ������')
				wait(1500)
                sampSendChat(string.format('/me ������(�) ����� ������� � �������� "%s"', ranks))
				wait(1500)
				sampSendChat('/me ���������(�) �� ������� �������� �� ������ ����� �������')
				wait(1500)
				sampSendChat(string.format('/giverank %s %s', id, rangg))
				wait(1500)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: '..sampGetPlayerNickname(id):gsub('_', ' ')..' - %s � ��������� �� "%s"', cfg.main.tarr, oldrank <= rangg and '�������(�)' or '�������(�)', ranks))
                else
				sampSendChat(string.format('/r '..sampGetPlayerNickname(id):gsub('_', ' ')..' - %s � ��������� �� "%s"', oldrank <= rangg and '�������(�)' or '�������(�)', ranks))
            end
			else 
			ftext('�������: /giverank [id] [������ ����] [����� ����]')
		end
	  end
	end
	sampSendChat(string.format('/giverank %s %s', id, rangg))
   end)
 end

function invite(pam)
    lua_thread.create(function()
        local id = pam:match('(%d+)')
	  if rank == '��������' or  rank == '�����������' then
        if id then
                sampSendChat('/me ������(�) ������� � ������� ��� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
				wait(1500)
				sampSendChat(string.format('/invite %s', id))
				wait(5000)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: ����� ��������� ��������� - '..sampGetPlayerNickname(id):gsub('_', ' ')..'', cfg.main.tarr))
                else
				sampSendChat('/r ����� ��������� ��������� - '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
            end
			else 
			ftext('�������: /invite [id]')
		end
	  end
   end)
 end
 
 function uninvite(pam)
    lua_thread.create(function()
        local id, pri4ina = pam:match('(%d+)%s+(.+)')
	  if rank == '��.��������' or rank == '��������' or  rank == '�����������' then
        if id and pri4ina then
                sampSendChat('/me ������(�) ������� � '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
				wait(1500)
				sampSendChat(string.format('/uninvite %s %s', id, pri4ina))
				wait(1500)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: '..sampGetPlayerNickname(id):gsub('_', ' ')..' - ������ �� ������� "%s"', cfg.main.tarr, pri4ina))
                else
				sampSendChat(string.format('/r '..sampGetPlayerNickname(id):gsub('_', ' ')..' - ������ �� ������� "%s"', pri4ina))
            end
			else 
			ftext('�������: /uninvite [id] [�������]')
		end
	  end
   end)
 end
 
function thelp()
    lua_thread.create(function()
        submenus_show(thelpsub(), '{47f4f0}Inst Tools {ffffff}| Help')
    end)
end

function thelpsub()
    return
{
    {
        title = '{47f4f0}/tset {ffffff}- ������� ���� �������',
        onclick = function()
            sampSetChatInputEnabled(true)
            sampSetChatInputText('/tset')
        end
    },
    {
        title = '{47f4f0}/thelp {ffffff} - ������ �� �������',
        onclick = function()
            sampSetChatInputEnabled(true)
            sampSetChatInputText('/thelp ')
        end
    },
    {
        title = '{47f4f0}/vig [id] �������{ffffff} - ������ ������� �� �����',
        onclick = function()
            sampSetChatInputEnabled(true)
            sampSetChatInputText('/vig ')
        end
    },
	{
        title = '{47f4f0}/dmb {ffffff} - ������� /members � �������',
        onclick = function()
            sampSetChatInputEnabled(true)
            sampSetChatInputText('/dmb ')
        end
    },
	{
        title = '{47f4f0}/yst {ffffff} - ������� ����� ��',
        onclick = function()
            sampSetChatInputEnabled(true)
            sampSetChatInputText('/yst ')
        end
    },
    {
        title = '{47f4f0}�������:',
        onclick = function()
        end
    },
	{
        title = '{47f4f0}���+Z �� ������ {ffffff}- ���� ��������������',
        onclick = function()
        end
    },
    {
        title = '{47f4f0}'..key.id_to_name(cfg.keys.fastmenu)..' {ffffff}- "������� ����"',
        onclick = function()
        end
    }
}
end

function fastmenu(id)
 return
{
  {
   title = "{FFFFFF}���� {47f4f0}������",
    onclick = function()
	submenus_show(fthmenu(id), "{47f4f0}IT {ffffff}| ���� ������")
	end
   },
    {
   title = "{FFFFFF}���� {47f4f0}���.�������� {ff0000}(��� ��.�������)",
    onclick = function()
	if rank == '��.��������' or rank == '��.��������' or rank == '��������' or  rank == '�����������' then
	submenus_show(govmenu(id), "{47f4f0}IT {ffffff}| ���� ���.��������")
	end
	end
   },
}
end

function govmenu(id)
 return
{
  {
   title = "{FFFFFF}�������������",
    onclick = function()
	sampSendChat("/d OG, ����� ����� ��������������� ��������.")
    wait(5000)
    sampSendChat("/gov [Instructors]: ��������� ������ �����, �����y����, �����y����� ����������.")
    wait(5000)
    sampSendChat('/gov [Instructors]: � ������ ������ � ����� ��������� �������� ������������� �� ��������� "������".')
    wait(5000)
    sampSendChat("/gov [Instructors]: ���������� � �����������: ����� ��� ���������� � �����, �������������������, �������� ���.")
    wait(5000)
    sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
	end
   },
    {
   title = "{FFFFFF}������ �� ������������",
    onclick = function()
	sampSendChat("/d OG, ����� ����� ��������������� ��������.")
        wait(5000)
        sampSendChat("/gov [Instructors]: ��������� ������ �����, �����y����, �����y����� ����������.")
        wait(5000)
        sampSendChat('/gov [Instructors]: � ������ ������ ������� ��������� �� ��������� "�����������".')
        wait(5000)
        sampSendChat("/gov [Instructors]: �� ����� ����������, �� ������ ������������ �� ��.������� �����. ")
        wait(5000)
        sampSendChat("/d OG, ��������� ����� ��������������� ��������.")
	end
   },
   {
   title = "{FFFFFF}������ ���. �����",
    onclick = function()
	sampSetChatInputEnabled(true)
	sampSetChatInputText("/d OG, ������� ���.����� ��")
	end
   },
   {
   title = "{FFFFFF}��������� � ����� ���. �����",
    onclick = function()
	sampSetChatInputEnabled(true)
	sampSetChatInputText("/d OG, ��������� ��� ����� ���.�������� �� ���������� ��")
	end
   }
}
end

function fthmenu(id)
 return
{
  {
    title = "{FFFFFF}������ ��� {47f4f0}������",
    onclick = function()
	    sampSendChat("�����������. �� ������� �� ���������� � ���������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("/me �������(�) ������� ������� ��������� ")
        wait(cfg.commands.zaderjka)
        sampSendChat("/b /clist 23 ")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������� ������ �� ���� �������, ���� �� �� ������ �������� �� ������������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ������� ��������� ��� ���������� �� ����������� ��������� � ����� �����. ��� ������ ���� ��� �������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("����������� �������: ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�������� ��� �������� ������� � ������� � ���. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("� ������� ����� ���������� � �����. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������� ����� � ������� ���������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� ��������� � ���������, ��� ����� ����� ����� �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("����� � ��� ����� ���� ������� - ��� ��������� �� ������������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������� ������� �� ���� ������: ����� � �������� �� ��������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������� ��������� �� ������ ��� ����� 3 ���� ����� ��������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("/b ����� � �������� �� �������� ����� ����� �� ������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("���� ��������� ������ �������:")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ����� �������� ������ �����. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ��������� ����������, ����������� �� ��������� ����� � ����������� (�� ������). ")
        wait(cfg.commands.zaderjka)
        sampSendChat("���� ��������� �������� ������ � ���������� ��. �������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�������� ����� ����� ���� ������ � ���������� ��. �������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� ������� ����� ���������. ����� ��������� ������ � ������� ������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat('/b � ���� "������ ��� ��������" ���� ��� ������ �����, ��� ��� �� ��������! ')
        wait(cfg.commands.zaderjka)
        sampSendChat("���� ��������� ������� ����������� � ����������� ������ ���������� ���� � ��. �������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�������,��� ���������� ��� ������. ")
    end
  },
   {
    title = "{FFFFFF}������ ��� {47f4f0}������������",
    onclick = function()
	sampSendChat("�����������")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� �� ������� �� ������ �� ��������� ������������, ��� ���������� ������������ � �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("/b /clist 19")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� - ����� ����������, ������������ ��������������� ��������� �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� - ����� ���������, ������������ ������������� ��������� � ��������� ��������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("� �������� ����������, ����� ���������� ������ � �������� ���. ��������")
        wait(cfg.commands.zaderjka)
        sampSendChat("����� ������� ���� �������� ������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� �������� ������� ��.����������� � ������ ��������� ����������� �����������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ������� ��������� ��� ���������� �� ����������� ��������� � ����� �����.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� ������ ���� ������ ��������� - ���������� � ��. �������")
        wait(cfg.commands.zaderjka)
        sampSendChat("���� ��������� �������� ������ � ���������� ��. �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�������� ����� ����� ���� ������ � ���������� ��. �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� ������� ����� ���������. ����� ��������� ������ � ������� ������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ��������� ����������, ����������� �� ��������� ����� � ����������� (�� ������).")
        wait(cfg.commands.zaderjka)
        sampSendChat('/b � ���� "������ ��� ��������" ���� ��� ������ �����, ��� ��� �� ��������!')
        wait(cfg.commands.zaderjka)
        sampSendChat("���� ��������� ������� ����������� � ����������� ������ ���������� ���� � ��. �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�������, ��� ���������� ��� ������.")
	end
   },
   {
    title = "{FFFFFF}������ ��� {47f4f0}���",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local myname = sampGetPlayerNickname(myid)
        sampSendChat("���� �����������. � ��������� ��������� "..myname:gsub('_', ' ')..". ")
        wait(cfg.commands.zaderjka)
        sampSendChat('������ � ������� ������ �� ���� "���". ')
        wait(cfg.commands.zaderjka)
        sampSendChat("1. ���������� ����� � �����: ")
        wait(cfg.commands.zaderjka)
        sampSendChat("� ������ ����������� �������� 50 ��/�. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("� ����� ���� - 30 ��/�. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� ��������� ������ �������� �� ����������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("2. �������� ������: ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� ��� �������� ������� � ������� ���. ������ ��� �������������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� ���� ����� �� ����. ��������� ��������� � ������� � ����������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������������� �� ������� ���������� ����������� �������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� �� ������ ������, �� ��������� �������� �����. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������������� ����� ������� ��������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������� ��������� �� ���������� ���������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ������������� � ������� ���������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������, �� �������� ����� ������� ����������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� ���� ������ ��������. ������� �� ��������.")
	end
   },
   {
    title = "{FFFFFF}������ ��� {47f4f0}���������� ��������� � �������",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local myname = sampGetPlayerNickname(myid)
        sampSendChat("���� �����������. � ��������� ��������� "..myname:gsub('_', ' ')..". ")
        wait(cfg.commands.zaderjka)
        sampSendChat('������ � ������� ������ �� ���� "��������� � �������".')
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ��������� ������ ������ �� ���� �� ���� ��������")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� ����������� ������� �������� �������� ����������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ��������� ������������ � ������:")
        wait(cfg.commands.zaderjka)
        sampSendChat("1.�����������, ��� ��������� �� ���. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("2.��� ���������� ����� ��������� ������������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("3.�� ������� ������� �����, ������� �� ��� ����������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� �� �����, ���������� ��� �������� ��������� � �������: ")
        wait(cfg.commands.zaderjka)
        sampSendChat("1.��������� ������ ������ � �������� ���� � ����������� ������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("2.��������� ����������� ������ ���������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("3.��������� ������������� ������� ��� ������� �������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("4.��������� ����������� ������ ��� ���������� ������ �����. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("� ������ ��������� ���� ������, � ��� ����� ������ ��������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� �� �� �������� ��������� ��� ����� ��������� ��� ������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� ���� ���, ������� �� ��������.")
	end
   },
      {
    title = "{FFFFFF}������ ��� {47f4f0}������� ���������� ������ �����������",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local myname = sampGetPlayerNickname(myid)
        sampSendChat("���� �����������. � ��������� ��������� "..myname:gsub('_', ' ')..". ")
        wait(cfg.commands.zaderjka)
        sampSendChat('������ � ������� ������ �� ���� "������� ���������� ������ �����������".')
        wait(cfg.commands.zaderjka)
        sampSendChat("1. ������, ��� ���������� � �������� �� ������:")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� � ����������� ������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������, ��� �� ������������ � ������� �����.")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������, �� ������ �� �� ����� � ����� �������� �� ����� ���������� ������ �����������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("������������ � ������������ ��������� ��� ������� �������� � ����� (������).")
        wait(cfg.commands.zaderjka)
        sampSendChat("2. �����������:")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������� ���������� ������ ����������� ������� ���� ��� ��������������� �� �� ����������, �������� �����.")
        wait(cfg.commands.zaderjka)
        sampSendChat("�������� � �������� � ������� ������������ ���������, ���� ���� ����� �� ����������� ����������� ������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������� ����� � ��������� ���������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ������ ��� �������� �����.")
        wait(cfg.commands.zaderjka)
        sampSendChat("����������� � ������ ����� �� ������ �� ����� �� ��������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("���������� ������������� � ����������� ����� �� �����, ��� ����� �� ���������������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ����� ������� ������������� ��������, �������� �������, ������������ ��������� � ���������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ������������ � �������� � �������� ���������� ������ �����������.")
		wait(cfg.commands.zaderjka)
        sampSendChat("�� ���� ���, ������� �� ��������.")
	end
   },
        {
    title = "{FFFFFF}������ ��� {47f4f0}������� ������ �����",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local myname = sampGetPlayerNickname(myid)
        sampSendChat("���� �����������. � ��������� ��������� "..myname:gsub('_', ' ')..". ")
        wait(cfg.commands.zaderjka)
        sampSendChat('������ � ������� ������ �� ���� "������� ������ �����".')
        wait(cfg.commands.zaderjka)
        sampSendChat("1. ������� ������ �����:")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ���� ����������� ������ � ����������� ������. (������ �� ����� �.���-������ � �� ����� ������ � �.���-��������)")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ����� ��������� ������ ������������ �������� ������. (���� ������ � ����� ������� ���� ��������)")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ����� ��������� ������������� � ����� ����������� ������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("2. �����������:")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ���� � �����.")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ���� � ����������� ���������� � ����������� �������, � ������� �����������, � �������������� ������� ������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ���� ��� ������� �������� ��������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ ���� � ������� 500 ������ �� ��������, ���������� ����.")
	end
   },
      {
    title = "{FFFFFF}������ ��� {47f4f0}�������������",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local myname = sampGetPlayerNickname(myid)
        sampSendChat("���� �����������. � ��������� ��������� "..myname:gsub('_', ' ')..". ")
        wait(cfg.commands.zaderjka)
        sampSendChat('������ � ������� ������ �� ���� "�������������". ')
        wait(cfg.commands.zaderjka)
        sampSendChat("1. ������� �������������: ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��� ���������� ������ ����� ����� ��������� ��� ���������� � �� ����������� �� ���������� �����. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("����� ������� ������ ���� ��������� ������� �� ������� �� ������ ��������� �����. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������������� ������ ����������� ������ ��� ������� �������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ����� ������� ������������� ��������, �������� �������, ������������ ��������� � ���������.")
        wait(cfg.commands.zaderjka)
        sampSendChat("��������� ������������ � �������� � �������� ������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("������ � ��������� � ������� �����, ���������� � ������� ��� �� �������� ������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("����� ��� ����������� �������� � ����������� ����� �� �������� ��������� �� ������ ����� 300 ������.")
       wait(cfg.commands.zaderjka)
        sampSendChat("��������� ��������� ����� ������������� ������ ����������. ")
        wait(cfg.commands.zaderjka)
        sampSendChat("�� ���� ���, ������� �� ��������.")
	end
   }
}
end

do

function imgui.OnDrawFrame()
   if first_window.v then
	local tagfr = imgui.ImBuffer(u8(cfg.main.tarr), 256)
	local tagb = imgui.ImBool(cfg.main.tarb)
	local clistb = imgui.ImBool(cfg.main.clistb)
	local clisto = imgui.ImBool(cfg.main.clisto)
	local givra = imgui.ImBool(cfg.main.givra)
	local waitbuffer = imgui.ImInt(cfg.commands.zaderjka)
	local clistbuffer = imgui.ImInt(cfg.main.clist)
    local iScreenWidth, iScreenHeight = getScreenResolution()
	local btn_size = imgui.ImVec2(-0.1, 0)
	imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth/2, iScreenHeight/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(380, 320), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'���������##1', first_window)
	imgui.PushItemWidth(100)
	imgui.Text(u8("������������ �������"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'������������ �������', tagb) then
    cfg.main.tarb = not cfg.main.tarb
    end
	if tagb.v then
	if imgui.InputText(u8'������� ��� ���.', tagfr) then
    cfg.main.tarr = u8:decode(tagfr.v)
    end
	end
	imgui.Text(u8("������������ ���������"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'������������ ���������', clistb) then
        cfg.main.clistb = not cfg.main.clistb
    end
    if clistb.v then
        if imgui.SliderInt(u8"�������� �������� ������", clistbuffer, 0, 33) then
            cfg.main.clist = clistbuffer.v
        end
		imgui.Text(u8("������������ ��������� ����������"))
	    imgui.SameLine()
		if imgui.ToggleButton(u8'������������ ��������� ����������', clisto) then
        cfg.main.clisto = not cfg.main.clisto
        end
    end
	imgui.Text(u8("������������ ��������� /giverank"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'������������ ��������� /giverank', givra) then
        cfg.main.givra = not cfg.main.givra
    end
	if imgui.InputInt(u8'�������� � �������', waitbuffer) then
     cfg.commands.zaderjka = waitbuffer.v
    end
    if imgui.CustomButton(u8('��������� ���������'), imgui.ImVec4(0.11, 0.79, 0.07, 0.40), imgui.ImVec4(0.11, 0.79, 0.07, 1.00), imgui.ImVec4(0.11, 0.79, 0.07, 0.76), btn_size) then
	sampAddChatMessage('{47f4f0}Inst Tools {ffffff}| ��������� ������� ���������.', -1)
    inicfg.save(cfg, 'instools/config.ini') -- ��������� ��� ����� �������� � �������
    end
    imgui.End()
   end
    if ystwindow.v then
                imgui.LockPlayer = true
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
                imgui.Begin(u8('Inst Tools | ����� ��'), ystwindow)
                for line in io.lines('moonloader\\instools\\yst.txt') do
                    imgui.TextWrapped(u8(line))
                end
                imgui.End()
            end
  if second_window.v then
    imgui.LockPlayer = true
    imgui.ShowCursor = true
    local x, y = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
    imgui.Begin('Inst Tools | Main Menu', second_window, imgui.WindowFlags.NoResize)
	if imgui.Button(u8'������', btn_size) then
      bMainWindow.v = not bMainWindow.v
    end
    if imgui.Button(u8'��������� �������', btn_size) then
      first_window.v = not first_window.v
    end
    if imgui.Button(u8'������������� ������', btn_size) then
      showCursor(false)
      thisScript():reload()
    end
    imgui.End()
  end
  if bMainWindow.v then
  local iScreenWidth, iScreenHeight = getScreenResolution()
	local tLastKeys = {}
   
   imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
   imgui.SetNextWindowSize(imgui.ImVec2(800, 500), imgui.Cond.FirstUseEver)

   imgui.Begin(u8("IT | ������##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild("##bindlist", imgui.ImVec2(795, 442))
	for k, v in ipairs(tBindList) do
		if hk.HotKey("##HK" .. k, v, tLastKeys, 100) then
			if not rkeys.isHotKeyDefined(v.v) then
				if rkeys.isHotKeyDefined(tLastKeys.v) then
					rkeys.unRegisterHotKey(tLastKeys.v)
				end
				rkeys.registerHotKey(v.v, true, onHotKey)
			end
		end
		imgui.SameLine()
		if tEditData.id ~= k then
			local sText = v.text:gsub("%[enter%]$", "")
			imgui.BeginChild("##cliclzone" .. k, imgui.ImVec2(500, 21))
			imgui.AlignTextToFramePadding()
			if sText:len() > 0 then
				imgui.Text(u8(sText))
			else
				imgui.TextDisabled(u8("������ ��������� ..."))
			end
			imgui.EndChild()
			if imgui.IsItemClicked() then
				sInputEdit.v = sText:len() > 0 and u8(sText) or ""
				bIsEnterEdit.v = string.match(v.text, "(.)%[enter%]$") ~= nil
				tEditData.id = k
				tEditData.inputActve = true
			end
		else
			imgui.PushAllowKeyboardFocus(false)
			imgui.PushItemWidth(500)
			local save = imgui.InputText("##Edit" .. k, sInputEdit, imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopItemWidth()
			imgui.PopAllowKeyboardFocus()
			imgui.SameLine()
			imgui.Checkbox(u8("����") .. "##editCH" .. k, bIsEnterEdit)
			if save then
				tBindList[tEditData.id].text = u8:decode(sInputEdit.v) .. (bIsEnterEdit.v and "[enter]" or "")
				tEditData.id = -1
			end
			if tEditData.inputActve then
				tEditData.inputActve = false
				imgui.SetKeyboardFocusHere(-1)
			end
		end
	end
	imgui.EndChild()

	imgui.Separator()

	if imgui.Button(u8"�������� �������") then
		tBindList[#tBindList + 1] = {text = "", v = {}}
	end

   imgui.End()
  end
  end
end

function onHotKey(id, keys)
	local sKeys = tostring(table.concat(keys, " "))
	for k, v in pairs(tBindList) do
		if sKeys == tostring(table.concat(v.v, " ")) then
			if tostring(v.text):len() > 0 then
				local bIsEnter = string.match(v.text, "(.)%[enter%]$") ~= nil
				if bIsEnter then
					sampProcessChatInput(v.text:gsub("%[enter%]$", ""))
				else
					sampSetChatInputText(v.text)
					sampSetChatInputEnabled(true)
				end
			end
		end
	end
end

function onScriptTerminate(scr)
	if scr == script.this then
		if doesFileExist(fileb) then
			os.remove(fileb)
		end
		local f = io.open(fileb, "w")
		if f then
			f:write(encodeJson(tBindList))
			f:close()
		end
	end
end

addEventHandler("onWindowMessage", function (msg, wparam, lparam)
	if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
		if tEditData.id > -1 then
			if wparam == key.VK_ESCAPE then
				tEditData.id = -1
				consumeWindowMessage(true, true)
			elseif wparam == key.VK_TAB then
				bIsEnterEdit.v = not bIsEnterEdit.v
				consumeWindowMessage(true, true)
			end
		end
	end
end)

function submenus_show(menu, caption, select_button, close_button, back_button)
    select_button, close_button, back_button = select_button or '�', close_button or 'x', back_button or '�'
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == 'table' and v.title .. ' �' or v.title)
        end
        sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
        repeat
            wait(0)
            local result, button, list = sampHasDialogRespond(id)
            if result then
                if button == 1 and list ~= -1 then
                    local item = menu[list + 1]
                    if type(item.submenu) == 'table' then -- submenu
                        table.insert(prev_menus, {menu = menu, caption = caption})
                        if type(item.onclick) == 'function' then
                            item.onclick(menu, list + 1, item.submenu)
                        end
                        return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
                    elseif type(item.onclick) == 'function' then
                        local result = item.onclick(menu, list + 1)
                        if not result then return result end
                        return display(menu, id, caption)
                    end
                else -- if button == 0
                    if #prev_menus > 0 then
                        local prev_menu = prev_menus[#prev_menus]
                        prev_menus[#prev_menus] = nil
                        return display(prev_menu.menu, id - 1, prev_menu.caption)
                    end
                    return false
                end
            end
        until result
    end
    return display(menu, 31337, caption or menu.title)
end

function r(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/r [%s]: %s', cfg.main.tarr, pam))
        else
            sampSendChat(string.format('/r %s', pam))
        end
    else
        ftext('������� /r [�����]')
    end
end

function ftext(message)
    sampAddChatMessage(string.format('%s %s', ctag, message), 0x3D85C6)
end

function tset()
  second_window.v = not second_window.v
end	

function tloadtk()
    if tload == true then
     sampSendChat('/tload'..u8(cfg.main.norma))
    else if tload == false then
     sampSendChat("/tunload")
    end
  end
end
function imgui.CentrText(text)
            local width = imgui.GetWindowWidth()
            local calc = imgui.CalcTextSize(text)
            imgui.SetCursorPosX( width / 2 - calc.x / 2 )
            imgui.Text(text)
        end
        function imgui.CustomButton(name, color, colorHovered, colorActive, size)
            local clr = imgui.Col
            imgui.PushStyleColor(clr.Button, color)
            imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
            imgui.PushStyleColor(clr.ButtonActive, colorActive)
            if not size then size = imgui.ImVec2(0, 0) end
            local result = imgui.Button(name, size)
            imgui.PopStyleColor(3)
            return result
        end

function pkmmenu(id)
    return
    {
      {
        title = "{ffffff}� ���� ��������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(pricemenu(id), "{47f4f0}Inst Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{ffffff}� ����������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(instmenu(id), "{47f4f0}Inst Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{ffffff}� �������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(questimenu(id), "{47f4f0}Inst Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{ffffff}� ����������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(oformenu(id), "{47f4f0}Inst Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
        title = "{ffffff}� ������� �������",
        onclick = function()
        sampSendChat("/me ���� ����� � �����.")
        wait(1500)
        sampSendChat("/itazer")
        wait(1500)
        sampSendChat("/me ������� ����� �� ����")
        end
      }
    }
end

function questimenu(args)
    return
    {
      {
        title = '{5b83c2}� ������ �������� �� ��� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� ���� ��������',
        onclick = function()
          sampSendChat("������ � ����� ��� ���� �������� �� ���. ������?")
		end
      },
      {
        title = '{ffffff}� �����{ff0000} 50 ��/�',
        onclick = function()
        sampSendChat("����� ������������ �������� ��������� � ������?")
        end
      },
      {
        title = '{ffffff}� ����� ���������{ff0000} 30 ��/�',
        onclick = function()
        sampSendChat("����� ������������ �������� ��������� � ����� ���������?")
        end
      },
      {
        title = '{ffffff}� �����{ff0000} � ����� �������.',
        onclick = function()
        sampSendChat("� ����� ������� �������� �����?")
        end
      },
      {
        title = '{ffffff}� ���',
        onclick = function()
        sampSendChat("�� ������ � ���. ���� ��������?")
		wait(1500)
		sampAddChatMessage("{47f4f0}[IT] {FFFFFF}- ���������� �����: {A52A2A}������� ������ ������ ������������. ������� ��� � �� � ����� �� ��������.", -1)
        end
      }
    }
end

function oformenu(id)
    return
    {
      {
        title = '{5b83c2}� ������ ���������� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� �����.',
        onclick = function()
          sampSendChat("/do ���� � ����������� � ����� �����������.")
		  wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ����� � ����� ��� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do �������� � ����.")
		  wait(1700)
		  sampSendChat('/me ��������(�) ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
		  wait(1700)
		  sampSendChat("/givelicense "..id)
		  wait(1700)
		  sampCloseCurrentDialogWithButton(1)
		  wait(1700)
		  sampSendChat("����� �� �������.")
		end
      },
      {
        title = '{ffffff}� �������',
        onclick = function()
          sampSendChat("/do ���� � ����������� � ����� �����������.")
		  wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ����� � ����� ��� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do �������� � ����.")
		  wait(1700)
		  sampSendChat('/me ��������(�) ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
		  wait(1700)
		sampSendChat("/givelicense "..id)
		wait(1700)
		sampSetCurrentDialogListItem(2)
		wait(1700)
		sampCloseCurrentDialogWithButton(1)
        end
      },
      {
        title = '{ffffff}� �����',
        onclick = function()
          sampSendChat("/do ���� � ����������� � ����� �����������.")
		  wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ����� � ����� ��� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do �������� � ����.")
		  wait(1700)
		  sampSendChat('/me ��������(�) ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
		  wait(1700)
		sampSendChat("/givelicense "..id)
		wait(1700)
		sampSetCurrentDialogListItem(1)
		wait(1700)
		sampCloseCurrentDialogWithButton(1)
        end
      },
      {
        title = '{ffffff}� ������{ff0000} �� 2 ������.',
        onclick = function()
          sampSendChat("/do ���� � ����������� � ����� �����������.")
		  wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ����� � ����� ��� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do �������� � ����.")
		  wait(1700)
		  sampSendChat('/me ��������(�) ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
		  wait(1700)
		sampSendChat("/givelicense "..id)
		wait(1700)
		sampSetCurrentDialogListItem(4)
		wait(1700)
		sampCloseCurrentDialogWithButton(1)
        end
      },
      {
        title = '{ffffff}� �����',
        onclick = function()
          sampSendChat("/do ���� � ����������� � ����� �����������.")
		  wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ����� � ����� ��� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do �������� � ����.")
		  wait(1700)
		  sampSendChat('/me �������� ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
		  wait(1700)
		sampSendChat("/givelicense "..id)
		wait(1700)
		sampSetCurrentDialogListItem(3)
		wait(1700)
		sampCloseCurrentDialogWithButton(1)
        end
      },
      {
        title = '{ffffff}� ������',
        onclick = function()
          sampSendChat("/do ���� � ����������� � ����� �����������.")
		  wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ����� � ����� ��� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do �������� � ����.")
		  wait(1700)
		  sampSendChat('/me ��������(�) ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
		  wait(1700)
        sampSendChat("/givelicense "..id)
		wait(1700)
		sampSetCurrentDialogListItem(5)
		wait(1700)
		sampCloseCurrentDialogWithButton(1)
        end
      }
    }
end

function pricemenu(args)
    return
    {
      {
        title = '{5b83c2}� ������ ��������� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� �����.',
        onclick = function()
		if gmegaflvl <= 2 then
          sampSendChat("��������� ������ �������� ���������� - 500$.")
		  wait(1500)
		  sampSendChat("���������?")	  
		else if gmegaflvl <= 5 then
		  sampSendChat("��������� ������ �������� ���������� - 5.000$.")
		  wait(1500)
		  sampSendChat("���������?")	  
		else if gmegaflvl <= 15 then
		  sampSendChat("��������� ������ �������� ���������� - 10.000$.")
		  wait(1500)
		  sampSendChat("���������?")	  
		else if gmegaflvl >= 16 then
		  sampSendChat("��������� ������ �������� ���������� - 30.000$.")
		  wait(1500)
		  sampSendChat("���������?")	  
        end
		end
		end
		end
		end
      },
      {
        title = '{ffffff}� �������',
        onclick = function()
        sampSendChat("��������� ������ �������� ���������� - 2.000$.")
		wait(1500)
		sampSendChat("���������?")
        end
      },
      {
        title = '{ffffff}� �����',
        onclick = function()
        sampSendChat("��������� ������ �������� ���������� - 10.000$.")
		wait(1500)
		sampSendChat("���������?")
        end
      },
      {
        title = '{ffffff}� ������{ff0000} �� 2 ������.',
        onclick = function()
        sampSendChat("��������� ������ �������� ���������� - 50.000$.")
		wait(1500)
		sampSendChat("���������?")
        end
      },
      {
        title = '{ffffff}� �����',
        onclick = function()
        sampSendChat("��������� ������ �������� ���������� - 5.000$.")
		wait(1500)
		sampSendChat("���������?")
        end
      },
      {
        title = '{ffffff}� ��������',
        onclick = function()
        sampSendChat("����������� - 2.000$, ����� - 5.000$, �������� ������ - 10.000$, �������� �� ������ - 50.000$.")
        end
      }
    }
end

function instmenu(id)
    return
    {
      {
        title = '{5b83c2}� ������ ����������� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� �����������.',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        local myname = sampGetPlayerNickname(myid)
        sampSendChat("������������. � ��������� ��������� "..myname:gsub('_', ' ')..", ��� ���� ������?")
		wait(1500)
		sampSendChat('/do �� ������� ������� � �������� "'..rank..'" | '..myname:gsub('_', ' ')..'.')  
		end
      },
      {
        title = '{ffffff}� �������',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("��� �������, ����������.")
		wait(1500)
		sampSendChat("/b /showpass "..myid.."")
        end
      },
      {
        title = '{ffffff}� ���������� ���������',
        onclick = function()
        sampSendChat("/do ���� � ����������� � ����� �����������.")
		wait(1700)
		  sampSendChat("/me ���������(�) ����, ����� ���� ������ ������ ������ ������� � ����� �� ���������")
		  wait(1700)
		  sampSendChat("/me �������(�) ���������� ������ ����������")
		  wait(1700)
		  sampSendChat("/do ������ �������� � ����.")
		  wait(1700)
		sampSendChat('/me ���������(�) ������ "Autoschool San Fierro" � ������� �������� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
        end
      },
	  {
        title = '{ffffff}� ����������� � ��������',
        onclick = function()
        sampSendChat("������� �� �������, ����� ��� �������.")
        end
      }
    }
end

function ystf()
    if not doesFileExist('moonloader/instools/yst.txt') then
        local file = io.open("moonloader/instools/yst.txt", "w")
        file:write(fpt)
        file:close()
        file = nil
    end
end

function getFraktionBySkin(playerid)
    fraks = {
        [0] = '�����������',
        [1] = '�����������',
        [2] = '�����������',
        [3] = '�����������',
        [4] = '�����������',
        [5] = '�����������',
        [6] = '�����������',
        [7] = '�����������',
        [8] = '�����������',
        [9] = '�����������',
        [10] = '�����������',
        [11] = '�����������',
        [12] = '�����������',
        [13] = '�����������',
        [14] = '�����������',
        [15] = '�����������',
        [16] = '�����������',
        [17] = '�����������',
        [18] = '�����������',
        [19] = '�����������',
        [20] = '�����������',
        [21] = 'Ballas',
        [22] = '�����������',
        [23] = '�����������',
        [24] = '�����������',
        [25] = '�����������',
        [26] = '�����������',
        [27] = '�����������',
        [28] = '�����������',
        [29] = '�����������',
        [30] = 'Rifa',
        [31] = '�����������',
        [32] = '�����������',
        [33] = '�����������',
        [34] = '�����������',
        [35] = '�����������',
        [36] = '�����������',
        [37] = '�����������',
        [38] = '�����������',
        [39] = '�����������',
        [40] = '�����������',
        [41] = 'Aztec',
        [42] = '�����������',
        [43] = '�����������',
        [44] = 'Aztec',
        [45] = '�����������',
        [46] = '�����������',
        [47] = 'Vagos',
        [48] = 'Aztec',
        [49] = '�����������',
        [50] = '�����������',
        [51] = '�����������',
        [52] = '�����������',
        [53] = '�����������',
        [54] = '�����������',
        [55] = '�����������',
        [56] = 'Grove',
        [57] = '�����',
        [58] = '�����������',
        [59] = '���������',
        [60] = '�����������',
        [61] = '�����',
        [62] = '�����������',
        [63] = '�����������',
        [64] = '�����������',
        [65] = '�����������', -- ��� ��������
        [66] = '�����������',
        [67] = '�����������',
        [68] = '�����������',
        [69] = '�����������',
        [70] = '���',
        [71] = '�����������',
        [72] = '�����������',
        [73] = 'Army',
        [74] = '�����������',
        [75] = '�����������',
        [76] = '�����������',
        [77] = '�����������',
        [78] = '�����������',
        [79] = '�����������',
        [80] = '�����������',
        [81] = '�����������',
        [82] = '�����������',
        [83] = '�����������',
        [84] = '�����������',
        [85] = '�����������',
        [86] = 'Grove',
        [87] = '�����������',
        [88] = '�����������',
        [89] = '�����������',
        [90] = '�����������',
        [91] = '�����������', -- ��� ��������
        [92] = '�����������',
        [93] = '�����������',
        [94] = '�����������',
        [95] = '�����������',
        [96] = '�����������',
        [97] = '�����������',
        [98] = '�����',
        [99] = '�����������',
        [100] = '������',
        [101] = '�����������',
        [102] = 'Ballas',
        [103] = 'Ballas',
        [104] = 'Ballas',
        [105] = 'Grove',
        [106] = 'Grove',
        [107] = 'Grove',
        [108] = 'Vagos',
        [109] = 'Vagos',
        [110] = 'Vagos',
        [111] = 'RM',
        [112] = 'RM',
        [113] = 'LCN',
        [114] = 'Aztec',
        [115] = 'Aztec',
        [116] = 'Aztec',
        [117] = 'Yakuza',
        [118] = 'Yakuza',
        [119] = 'Rifa',
        [120] = 'Yakuza',
        [121] = '�����������',
        [122] = '�����������',
        [123] = 'Yakuza',
        [124] = 'LCN',
        [125] = 'RM',
        [126] = 'RM',
        [127] = 'LCN',
        [128] = '�����������',
        [129] = '�����������',
        [130] = '�����������',
        [131] = '�����������',
        [132] = '�����������',
        [133] = '�����������',
        [134] = '�����������',
        [135] = '�����������',
        [136] = '�����������',
        [137] = '�����������',
        [138] = '�����������',
        [139] = '�����������',
        [140] = '�����������',
        [141] = 'FBI',
        [142] = '�����������',
        [143] = '�����������',
        [144] = '�����������',
        [145] = '�����������',
        [146] = '�����������',
        [147] = '�����',
        [148] = '�����������',
        [149] = 'Grove',
        [150] = '�����',
        [151] = '�����������',
        [152] = '�����������',
        [153] = '�����������',
        [154] = '�����������',
        [155] = '�����������',
        [156] = '�����������',
        [157] = '�����������',
        [158] = '�����������',
        [159] = '�����������',
        [160] = '�����������',
        [161] = '�����������',
        [162] = '�����������',
        [163] = 'FBI',
        [164] = 'FBI',
        [165] = 'FBI',
        [166] = 'FBI',
        [167] = '�����������',
        [168] = '�����������',
        [169] = 'Yakuza',
        [170] = '�����������',
        [171] = '�����������',
        [172] = '�����������',
        [173] = 'Rifa',
        [174] = 'Rifa',
        [175] = 'Rifa',
        [176] = '�����������',
        [177] = '�����������',
        [178] = '�����������',
        [179] = 'Army',
        [180] = '�����������',
        [181] = '������',
        [182] = '�����������',
        [183] = '�����������',
        [184] = '�����������',
        [185] = '�����������',
        [186] = 'Yakuza',
        [187] = '�����',
        [188] = '���',
        [189] = '�����������',
        [190] = 'Vagos',
        [191] = 'Army',
        [192] = '�����������',
        [193] = 'Aztec',
        [194] = '�����������',
        [195] = 'Ballas',
        [196] = '�����������',
        [197] = '�����������',
        [198] = '�����������',
        [199] = '�����������',
        [200] = '�����������',
        [201] = '�����������',
        [202] = '�����������',
        [203] = '�����������',
        [204] = '�����������',
        [205] = '�����������',
        [206] = '�����������',
        [207] = '�����������',
        [208] = 'Yakuza',
        [209] = '�����������',
        [210] = '�����������',
        [211] = '���',
        [212] = '�����������',
        [213] = '�����������',
        [214] = 'LCN',
        [215] = '�����������',
        [216] = '�����������',
        [217] = '���',
        [218] = '�����������',
        [219] = '���',
        [220] = '�����������',
        [221] = '�����������',
        [222] = '�����������',
        [223] = 'LCN',
        [224] = '�����������',
        [225] = '�����������',
        [226] = 'Rifa',
        [227] = '�����',
        [228] = '�����������',
        [229] = '�����������',
        [230] = '�����������',
        [231] = '�����������',
        [232] = '�����������',
        [233] = '�����������',
        [234] = '�����������',
        [235] = '�����������',
        [236] = '�����������',
        [237] = '�����������',
        [238] = '�����������',
        [239] = '�����������',
        [240] = '���������',
        [241] = '�����������',
        [242] = '�����������',
        [243] = '�����������',
        [244] = '�����������',
        [245] = '�����������',
        [246] = '������',
        [247] = '������',
        [248] = '������',
        [249] = '�����������',
        [250] = '���',
        [251] = '�����������',
        [252] = 'Army',
        [253] = '�����������',
        [254] = '������',
        [255] = 'Army',
        [256] = '�����������',
        [257] = '�����������',
        [258] = '�����������',
        [259] = '�����������',
        [260] = '�����������',
        [261] = '���',
        [262] = '�����������',
        [263] = '�����������',
        [264] = '�����������',
        [265] = '�������',
        [266] = '�������',
        [267] = '�������',
        [268] = '�����������',
        [269] = 'Grove',
        [270] = 'Grove',
        [271] = 'Grove',
        [272] = 'RM',
        [273] = '�����������', -- ���� ��������
        [274] = '���',
        [275] = '���',
        [276] = '���',
        [277] = '�����������',
        [278] = '�����������',
        [279] = '�����������',
        [280] = '�������',
        [281] = '�������',
        [282] = '�������',
        [283] = '�������',
        [284] = '�������',
        [285] = '�������',
        [286] = 'FBI',
        [287] = 'Army',
        [288] = '�������',
        [289] = '�����������',
        [290] = '�����������',
        [291] = '�����������',
        [292] = 'Aztec',
        [293] = '�����������',
        [294] = '�����������',
        [295] = '�����������',
        [296] = '�����������',
        [297] = 'Grove',
        [298] = '�����������',
        [299] = '�����������',
        [300] = '�������',
        [301] = '�������',
        [302] = '�������',
        [303] = '�������',
        [304] = '�������',
        [305] = '�������',
        [306] = '�������',
        [307] = '�������',
        [308] = '���',
        [309] = '�������',
        [310] = '�������',
        [311] = '�������'
    }
    if sampIsPlayerConnected(playerid) then
        local result, handle = sampGetCharHandleBySampPlayerId(playerid)
        local skin = getCharModel(handle)
        return fraks[skin]
    end
end

function sampev.onSendSpawn()
    if cfg.main.clistb and rabden then
        lua_thread.create(function()
            wait(1200)
            ftext('���� ���� ������ ��: {9966cc}' .. cfg.main.clist)
            sampSendChat('/clist '..cfg.main.clist)
        end)
    end
end

function sampev.onServerMessage(color, text)
        if text:find('������� ���� �����') and color ~= -1 then
        if cfg.main.clistb then
		if rabden == false then
            lua_thread.create(function()
                wait(100)
                ftext('���� ���� ������ ��: {9966cc}' .. cfg.main.clist)
                sampSendChat('/clist '..tonumber(cfg.main.clist))
                rabden = true
				wait(1000)
				if cfg.main.clisto then
				local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                local myname = sampGetPlayerNickname(myid)
				sampSendChat("/me ������ �������")
                wait(1500)
                sampSendChat("/me ���� ���� ������, ����� ���� ������ �� � ����")
                wait(1500)
                sampSendChat("/me ���� ������� ������, ����� ���������� � ���")
                wait(1500)
                sampSendChat("/me ������� ������� �� �������")
                wait(1500)
                sampSendChat('/do �� ������� ������� � �������� "'..rank..'" | '..myname:gsub('_', ' ')..'.')  
			end
            end)
        end
	  end
    end
    if text:find('������� ���� �������') and color ~= -1 then
        rabden = false
    end
	if status then
		if text:match('ID: .+ | .+: .+ %- .+') and not fstatus then
			gosmb = true
			local id, nick, rang, stat = text:match('ID: (%d+) | (.+): (.+) %- (.+)')
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
			table.insert(players2, string.format('{'..color..'}%s[%s]{ffffff}\t%s\t%s', nick, id, rang, stat))
			return false
		end
		if text:match('�����: %d+ �������') then
			local count = text:match('�����: (%d+) �������')
			gcount = count
			gotovo = true
			return false
		end
		if color == -1 then
			return false
		end
		if color == 647175338 then
			return false
        end
        if text:match('ID: .+ | .+: .+') and not fstatus then
			krimemb = true
			local id, nick, rang = text:match('ID: (%d+) | (.+): (.+)')
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
			table.insert(players1, string.format('{'..color..'}%s[%s]{ffffff}\t%s', nick, id, rang))
			return false
        end
    end
end