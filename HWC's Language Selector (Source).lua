Font.fmLoad();

rescuePath={};
rescuePath[1]="mass:/PS2/APPS/WLE/WLE.ELF";
rescuePath[2]="mass:/PS2/APPS/WLE_ISR/WLE_ISR.ELF";
rescuePath[3]="mass:/PS2/APPS/WLE_ISRHDD/WLE_ISRHDD.ELF";
rescuePath[4]="mass:/PS2/APPS/WLE_KHN/WLE_KHN.ELF";
rescuePath[5]="mass:/PS2/APPS/WLE_SMB/WLE_SMB.ELF";
rescuePath[6]="mass:/PS2/APPS/WLE_HWC/WLE_HWC.ELF";
rescuePath[7]="mass:/PS2/APPS/ULE_442D/ULE_442D.ELF";
rescuePath[8]="mass:/PS2/APPS/ULE_437/ULE_437.ELF";
rescuePath[9]="mass:/PS2/APPS/LBFN/LBFN.ELF";
rescuePath[10]="mc0:/BOOT/BOOT.ELF";
rescuePath[11]="mc0:/APPS/ULE.ELF";
rescuePath[12]="mc0:/WLE/WLE.ELF";
rescuePath[13]="mc0:/ULE/ULE.ELF";
rescuePath[14]="mc0:/APPS/LBFN.ELF";
rescuePath[15]="mc0:/LBFN/LBFN.ELF";
rescuePath[16]="mc1:/BOOT/BOOT.ELF";
rescuePath[17]="mc1:/APPS/ULE.ELF";
rescuePath[18]="mc1:/WLE/WLE.ELF";
rescuePath[19]="mc1:/ULE/ULE.ELF";
rescuePath[20]="mc1:/LBFN/LBFN.ELF";
rescuePath[21]="mc1:/APPS/LBFN.ELF";

function LoadULE()
	for i = 1, 9 do
		if System.doesFileExist(rescuePath[i]) then
			System.loadELFUSB(rescuePath[i]);
		end
	end
	for i = 10, 21 do
		if System.doesFileExist(rescuePath[i]) then
			System.loadELF(rescuePath[i]);
		end
	end
end

function launchwithLang(languageValue)
	System.setSystemLanguage(languageValue);
	Font.fmUnload();
	if imanomode=="Launch Disc" then
		System.launchCDVD();
		ErrorString = "Error: Can't launch disc";
		waittillframe=imanoframe+150;
	elseif imanomode=="uLaunchELF / DEV1" then
		LoadULE();
		ErrorString = "Error: uLaunchELF / DEV1 not found";
		waittillframe=imanoframe+150;
	elseif imanomode=="Browser" then
		System.exitToBrowser();
		ErrorString = "Error: What the damn fuck?! This was unexpected!";
		waittillframe=imanoframe+150;
	end
	Font.fmLoad();
end

ErrorString = "";

imanomode="Launch Disc";

pad = Pads.get();
oldpad=pad;

temporaryVar = System.openFile("rom0:ROMVER", FREAD)
temporaryVar_size = System.sizeFile(temporaryVar)
ROMVER = System.readFile(temporaryVar, temporaryVar_size)
ROMVERRegion = string.sub(ROMVER,5,5)
System.closeFile(temporaryVar)

imanoframe = 1;
waittillframe = 1;

if ROMVERRegion~="E" then
	Screen.setMode(NTSC, 640, 448)
	imanoVideoMode="NTSC"
else
	Screen.setMode(PAL, 640, 512)
	imanoVideoMode="PAL"
end

while true do
	pad = Pads.get();
	
	Screen.clear();
	Graphics.drawRect(0, 0, 1280, 960, Color.new(0, 0, 0, 255))
	Font.fmPrint(30, 30, 0.57, "CROSS: English\nCIRCLE: Japanese\nSQUARE: Spanish\nTRIANGLE: French\nUP: German\nDOWN: Italian\nLEFT: Dutch\nRIGHT: Portuguese\n\nSTART: Change video mode\n\nExit to: "..imanomode.."\nPress SELECT to change exit option\n\n"..ErrorString.."\n\n")
	Screen.waitVblankStart()
	Screen.flip()
	
	if Pads.check(pad, PAD_CROSS) and not Pads.check(oldpad, PAD_CROSS) then
		launchwithLang(1);
	elseif Pads.check(pad, PAD_CIRCLE) and not Pads.check(oldpad, PAD_CIRCLE) then
		launchwithLang(0);
	elseif Pads.check(pad, PAD_SQUARE) and not Pads.check(oldpad, PAD_SQUARE) then
		launchwithLang(3);
	elseif Pads.check(pad, PAD_TRIANGLE) and not Pads.check(oldpad, PAD_TRIANGLE) then
		launchwithLang(2);
	elseif Pads.check(pad, PAD_UP) and not Pads.check(oldpad, PAD_UP) then
		launchwithLang(4);
	elseif Pads.check(pad, PAD_DOWN) and not Pads.check(oldpad, PAD_DOWN) then
		launchwithLang(5);
	elseif Pads.check(pad, PAD_LEFT) and not Pads.check(oldpad, PAD_LEFT) then
		launchwithLang(6);
	elseif Pads.check(pad, PAD_RIGHT) and not Pads.check(oldpad, PAD_RIGHT) then
		launchwithLang(7);
	elseif Pads.check(pad, PAD_SELECT) and not Pads.check(oldpad, PAD_SELECT) then
		if imanomode=="Launch Disc" then
			imanomode="uLaunchELF / DEV1";
		elseif imanomode=="uLaunchELF / DEV1" then
		--	imanomode="Browser";
		--elseif imanomode=="Browser" then
			imanomode="Launch Disc";
		end
	elseif Pads.check(pad, PAD_START) and not Pads.check(oldpad, PAD_START) then
		if imanoVideoMode=="PAL" then
			Screen.setMode(NTSC, 640, 448)
			imanoVideoMode="NTSC"
		else
			Screen.setMode(PAL, 640, 512)
			imanoVideoMode="PAL"
		end
	end
	imanoframe = imanoframe+1;
	if waittillframe == imanoframe then
		ErrorString = "";
	end
	oldpad=pad;
end