/*
----------------------------------------------------------------------------------------------------------------------
::
::    Description: This MaxScript is for collecting materials and texture, searching by name, 
::					modify the texture path and copy the selection in the material editor.
::
----------------------------------------------------------------------------------------------------------------------
:: LICENSE -------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
::    Copyright (C) 2013 Jonathan Baecker (jb_alvarado)
::
::    This program is free software: you can redistribute it and/or modify
::    it under the terms of the GNU General Public License as published by
::    the Free Software Foundation, either version 3 of the License, or
::    (at your option) any later version.
::
::    This program is distributed in the hope that it will be useful,
::    but WITHOUT ANY WARRANTY; without even the implied warranty of
::    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::    GNU General Public License for more details.
::
::    You should have received a copy of the GNU General Public License
::    along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
:: History ----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
::
:: This is version 0.3 from 2013-05-27. Last bigger modification was on 2013-06-01
:: 2013-05-27: build the script
:: 2013-06-01: rewrite and optimize the code (Jonathan Baecker)
::
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
--
--  Script Name: Search Materials And Textures
--
--	Author:   Jonathan Baecker (jb_alvardo), www.pixelcrusher.de | blog.pixelcrusher.de
--
----------------------------------------------------------------------------------------------------------------------

*/

(
	global colMats = #()
	global colMatsS = #()
	
-------------------------------------------------------------------
--Search texture by name function
-------------------------------------------------------------------
fn GetBitmapTextures mtl =
	(
		local texFiles= #()
		
		join texFiles (getClassInstances bitmapTexture target:mtl asTrackViewPick:off)
	
		for texFile in texFiles do (
			join colMats  #(colMatsS = #(texFile))
			join colMatsS #("        " + getFilenameFile texFile.filename + getFilenameType texFile.filename)
			)
	)


-------------------------------------------------------------------
--Search material by name function
-------------------------------------------------------------------
fn matlists mtl = (	
		case classof mtl of ( 
			--------------------------------------------------
			--Blend
			--------------------------------------------------
			Blend:
			(	
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				
				local blendMat = #()
				
				if (mtl.map1 != undefined) do (
					join colMats  #(colMatsS = #(mtl.map1))
					join colMatsS #("    " + mtl.map1.name)
						
					GetBitmapTextures mtl.map1
					)
				if (mtl.map2 != undefined) do (	
					join colMats  #(colMatsS = #(mtl.map2))
					join colMatsS #("    " + mtl.map2.name)
						
					GetBitmapTextures mtl.map2
					)
			)
			--------------------------------------------------
			--Shellac
			--------------------------------------------------
			Shellac:
			(	
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				
				if (mtl.shellacMtl1 != undefined) do (	
					join colMats  #(colMatsS = #(mtl.shellacMtl1))
					join colMatsS #("    " + mtl.shellacMtl1.name)
						
					GetBitmapTextures mtl.shellacMtl1
					)
				if (mtl.shellacMtl2 != undefined) do (	
					join colMats  #(colMatsS = #(mtl.shellacMtl2))
					join colMatsS #("    " + mtl.shellacMtl2.name)
						
					GetBitmapTextures mtl.shellacMtl2	
					)
			)
			--------------------------------------------------
			--TopBottom 
			--------------------------------------------------
			TopBottom:
			(	
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				
				if (mtl.topMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.topMaterial))
					join colMatsS #("    " + mtl.topMaterial.name)
						
					GetBitmapTextures mtl.topMaterial	
					)
				if (mtl.bottomMaterial != undefined) do (	
					join colMats  #(colMatsS = #(mtl.bottomMaterial))
					join colMatsS #("    " + mtl.bottomMaterial.name)
						
					GetBitmapTextures mtl.bottomMaterial	
					)
			)
			--------------------------------------------------
			--DoubleSided 
			--------------------------------------------------
			doubleSided:
			(	
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				
				if (mtl.material1 != undefined) do (
					join colMats  #(colMatsS = #(mtl.material1))
					join colMatsS #("    " + mtl.material1.name)	

					GetBitmapTextures mtl.material1
					)
				if (mtl.material2 != undefined) do (	
					join colMats  #(colMatsS = #(mtl.material2))
					join colMatsS #("    " + mtl.material2.name)
						
					GetBitmapTextures mtl.material2	
					)
			)
			--------------------------------------------------
			--Shell_Material 
			--------------------------------------------------
			Shell_Material:
			(	
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
				
				if (mtl.originalMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.originalMaterial))
					join colMatsS #("    " + mtl.originalMaterial.name)
					
					GetBitmapTextures mtl.originalMaterial	
					)
				if (mtl.bakedMaterial != undefined) do (
					join colMats  #(colMatsS = #(mtl.bakedMaterial))
					join colMatsS #("    " + mtl.bakedMaterial.name)
					
					GetBitmapTextures mtl.bakedMaterial
					)
			)
			--------------------------------------------------
			-- Multimaterials
			--------------------------------------------------
			MultiMaterial: 
			( 
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
					
				local m
				for m = 1 to mtl.numsubs do 
				(
					if (mtl[m] != undefined) do (
						join colMats  #(colMatsS = #(mtl[m]))
						join colMatsS #("    " + mtl[m].name)
						
						GetBitmapTextures mtl[m]	
						)
				)
		 	)
			--------------------------------------------------
			--CompositeMaterial
			--------------------------------------------------
			CompositeMaterial: 
			( 
				join colMats  #(colMatsS = #(mtl))
				join colMatsS #(mtl.name)
					
				local c
				for c = 1 to mtl.materialList.count do 
				(	
					if (mtl.materialList[c] != undefined) do (
						join colMats  #(colMatsS = #(mtl.materialList[c]))
						join colMatsS #("    " + mtl.materialList[c].name)
							
						GetBitmapTextures mtl.materialList[c]		
						)
				)
		 	)
			--------------------------------------------------
			--all other materials
			--------------------------------------------------
			default:
			(
				if (superclassof mtl == material) do ( 
					join colMats  #(colMatsS = #(mtl))
					join colMatsS #(mtl.name)
						
					GetBitmapTextures mtl
					)
			)
			
		) --case end	
		
	) --fn matlists end

rollout SearchMaterialAndTextures "Search Materials And Textures" width:400 height:640 (
	
		local ProgramName = "Search Material and Textures"
		local theSelection = undefined
	
	groupBox grpProgress "Progress:" pos:[10,10] width:380 height:60
		label lblProgress "" pos:[20,30] width:200 height:16
		progressBar prgProgress "" pos:[20,49] width:360 height:12 color:[0,200,0]
	
	groupBox grpSeMyTex "Collection From All Materials And Textures:" pos:[10,75] width:380 height:475
		button btnSeMatAndTex "Collect Materials and Textures" pos:[20,95] width:160 height:20
		editText edtMat "" pos:[16,120] width:300 height:20 readOnly:true
		button btnChangeTex "Browse" pos:[320,120] width:60 height:20
		listBox lbxTextures "" pos:[20,145] width:360 height:30
	
	groupBox grpSeByName "Search Material And Textures By Name:" pos:[10,555] width:380 height:75
		editText edtBox "" pos:[16,573] width:304 height:20 
		button btnSeMat "Search" pos:[330,573] width:50 height:20
		spinner spnSlotNum "Material Editor, Slot Number: " pos:[265,603] width:55 height:16 range:[1,24,1] type:#integer
		button btnMoveMat "Copy To" pos:[330,601] width:50 height:20	
	
	-----------------------------------------------
	--resize statment
	-----------------------------------------------
	on SearchMaterialAndTextures resized newSize do (
		
		grpProgress.width=newSize[1]-20
		
		grpSeMyTex.width=newSize[1]-20
		grpSeMyTex.height=newSize[2]-165
			edtMat.width=newSize[1]-105
			btnChangeTex.pos=[newSize[1]-80,120] 
			lbxTextures.width=newSize[1]-40
			lbxTextures.height=newSize[2]-244
		
		grpSeByName.width=newSize[1]-20
		grpSeByName.pos=[10, newSize[2]-85] 
			edtBox.width=newSize[1]-100
			edtBox.pos=[20,newSize[2]-67] 
			btnSeMat.pos=[newSize[1]-70,newSize[2]-67] 
			spnSlotNum.pos=[newSize[1]-91,newSize[2]-37] 
			btnMoveMat.pos=[newSize[1]-70,newSize[2]-39] 
		)

-----------------------------------------------
--Progress, fill material and texture array
-----------------------------------------------
	fn doMaterialList sceneMaterials = (
			--reset material and texture array
			colMats = #()
			colMatsS = #()
			local list = #()	
			
			if (sceneMaterials.count == 0) do
				(
					MessageBox "There are no materials in your current scene!" title:ProgramName 
				)				
								
			for i = 1 to sceneMaterials.count do 
				(
					lblProgress.caption = ("Material: " + sceneMaterials[i].name)
					matScene = sceneMaterials[i].name
					matlists sceneMaterials[i]
					prgProgress.value = 100.000 / sceneMaterials.count * i
				)
				
			lblProgress.caption = ("Done...")	
			prgProgress.value = 100
			
	--get names from materials and textures
		for m = 1 to colMats.count do (
			if (superclassof colMats[m][1] == material ) then (
				join list #(colMats[m][2])
				) else if (classof colMats[m][1] == BitmapTexture ) then (
					join list #(colMats[m][2])
					)
			)
			--fill the listBox lbxTextures box 
			lbxTextures.items = list
			
			if (lbxTextures.selection == 1) do (
				edtMat.text = list[1]
				theSelection = colMats[1][1]
				)
		)
	
-------------------------------------
	--Buttons
-------------------------------------
--collecting material list
-------------------------------------
on btnSeMatAndTex pressed do (
		doMaterialList sceneMaterials
	)	
	
-------------------------------------
--selected list entry
-------------------------------------	
on lbxTextures selected listSel do (
	if (superclassof colMats[listSel][1] == material) then ( 
		edtMat.text = colMats[listSel][1].name
		) else if (classof colMats[listSel][1] == BitmapTexture ) do (
			
		edtMat.text = getFilenamePath colMats[listSel][1].filename + getFilenameFile colMats[listSel][1].filename + getFilenameType colMats[listSel][1].filename
		)
		
		theSelection = colMats[listSel][1]
	)

-------------------------------------
--Browse Texture
-------------------------------------	
	on btnChangeTex pressed do ( 
		if (colMats.count == 0) do (
			MessageBox "Please collect materials and textures first!" title:ProgramName
			return false
			)
		
		local broList = #()
			
		for i = 1 to colMats.count do (
			if (superclassof colMats[i][1] == material) then ( 
				join broList #(colMats[i][1])
				) else if (classof colMats[i][1] == BitmapTexture ) do (
					join broList #(colMats[i][1])
					)
			)
		
		--get texture name an path
		for j = 1 to broList.count do (
			if (lbxTextures.selection == j AND classof broList[j] == BitmapTexture) then (
				filepath = getFilenamePath broList[j].filename + getFilenameFile broList[j].filename + getFilenameType broList[j].filename

				inputFile = getOpenFileName \
				caption:"Select Bitmap Image File" \
				filename:filepath \
				types:"All Files (*.*)|*.*|AVI File (*.avi)|*.avi|Mpeg File (*.mpg,*.mpeg)|*.mpg;*.mpeg|BMP Image File (*.bmp)|*.bmp|Kodak Cineon (*.cin)|*.cin|Combustion* by Discreet (*.cws)|*.cws\
				|OpenEXR Image File (*.exr)|*.exr|GIF Image File (*.gif)|*.gif|Radiance Image File (HDRI) (*.hdr*.pic)|*.hdr;*.pic|ILF Image File (*.ifl)|*.ifl\
				|JPEG Image File (*.jpg,*.jpe,*.jpeg)|*.jpg;*.jpe;*.jpeg|PNG Image File (*.png)|*.png|Adobe PSD Reader (*.psd)|*.psd|MOV QuickTime File (*.mov)|*.mov\
				|SGI Image File (*.rgb,*.rgba,*.sgi,*.int,*.inta,*.bw)|*.rgb;*.rgba;*.sgi;*.int;*.inta,*.bw|RLA Image File (*.rla)|*.rla|RPF (*.rpf)|*.rpf|Targa Image File (*.tga)|*.tga|Tif Image File (*.tif,*.tif)|*.tif;*.tiff\
				|YUV Image File (*.yuv)|*.yuv|DDS Image File (*.dds)|*.dds|" \
				historyCategory:"Textures"
			
				) else if (lbxTextures.selection == j AND superclassof broList[j] == material) then (
					MessageBox "Please select a texture map..." title:ProgramName
					exit
					)
				if (inputFile != undefined) do (
					broList[j].filename = inputFile
					lbxTextures.selection = j
					)	
			)
		doMaterialList sceneMaterials
		)
	
-------------------------------------
--search material by name
-------------------------------------
on btnSeMat pressed do (
	doMaterialList sceneMaterials
	
	if (edtBox.text != "") then (
		matLS = #()
		local i
		
		for i = 1 to meditMaterials.count do 
		(					
			join matLS #(meditMaterials [i].name)	
		)
		
		--check if material or texture name exist
		local NameMatch = undefined
		local NameIndex = 1
		local NumCount = #()
		
		for f = 1 to colMats.count do (
			if (colMats[f][1].name == edtBox.text) then (
				NameMatch = colMats[f][1]
				NameIndex = f
				) else if (classof colMats[f][1] ==BitmapTexture AND (getFilenameFile colMats[f][1].filename + getFilenameType colMats[f][1].filename) == edtBox.text) then (
					NameMatch = colMats[f][1]
					NameIndex = f
				
					join NumCount #(f)
					)
			)
			
		--count textures with the same name	
		if (NumCount.count > 1) do (
			MessageBox ("Texture is \"" + NumCount.count as string + "\" times in use! Select last...") title:ProgramName
			)	
		
		--jump to the searched material or texture	
		if (NameMatch != undefined) then (
				if (findItem matLS NameMatch.name > 0) then (
					lbxTextures.selection = NameIndex
					
					activeMeditSlot = (findItem matLS NameMatch.name) 
					MessageBox ("Material or Textures is already in Material Editor! SLOT: " + (findItem matLS NameMatch.name) as string) title:ProgramName
					) else (
					lbxTextures.selection = NameIndex
					theSelection = NameMatch
					)
				
			) else (
				MessageBox ("Material or Textures \"" + edtBox.text + "\" not found...") title:ProgramName
				)		
		) else ( 
			MessageBox "Please type a material name in the text field!" title:ProgramName
			)
	)
	
-------------------------------------
--copy texture to material editor
-------------------------------------		
on btnMoveMat pressed do (
	if (theSelection != undefined) then (
			
		matLS = #()
		local i
		
		for i = 1 to meditMaterials.count do (					
			join matLS #(meditMaterials [i].name)	
			)
		
		if (findItem matLS theSelection.name > 0) then (
			activeMeditSlot = (findItem matLS theSelection.name) 
			MessageBox ("Material or Textures is already in Material Editor! SLOT: " + (findItem matLS theSelection.name) as string) title:ProgramName
			) else (
				setMeditMaterial spnSlotNum.value theSelection
				)
		) else (
			MessageBox "Please collect, or search, and select something first!" title:ProgramName
			)
	)	
	
) --rollout end


try ( destroyDialog SearchMaterialAndTextures )
	catch (	MessageBox "Dialog not found!" )

	createDialog SearchMaterialAndTextures style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_resizing)
) --script end